import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pine/data/repositories/product_repository.dart';
import 'package:pine/features/shop/controllers/product/variation_controller.dart';
import 'package:pine/features/shop/models/cart_model.dart';
import 'package:pine/features/shop/models/product_model.dart';
import 'package:pine/features/shop/models/product_variation_model.dart';
import 'package:pine/utils/constants/colors.dart';
import 'package:pine/utils/constants/enums.dart';
import 'package:pine/utils/constants/sizes.dart';
import 'package:pine/utils/helpers/helper_functions.dart';
import 'package:pine/utils/local_storage/storage_utility.dart';
import 'package:pine/utils/popups/loaders.dart';

class CartController extends GetxController {
  static CartController get instance => Get.find();

  RxInt noOfCartItems = 0.obs;
  RxDouble totalCartPrice = 0.0.obs;
  RxDouble selectedItemsPrice = 0.0.obs;
  RxInt productQuantityInCart = 1.obs;
  RxList<CartModel> cartItems = <CartModel>[].obs;
  final variationController = VariationController.instance;

  // Map để lưu trạng thái được chọn của từng sản phẩm
  RxMap<String, bool> selectedItems = <String, bool>{}.obs;
  // Trạng thái checkbox "Chọn tất cả"
  RxBool selectAll = false.obs;

  // Biến để kiểm soát thông báo
  static const _notificationCooldown = Duration(milliseconds: 1500);
  final Map<String, DateTime> _lastNotificationByType = {};

  CartController() {
    loadCartItems();
  }

  // PHƯƠNG THỨC QUẢN LÝ THÔNG BÁO
  // =================================================================

  // Hiển thị thông báo cảnh báo với kiểm soát tần suất
  void showWarning(String title, String message, [String type = 'general']) {
    final now = DateTime.now();
    if (_lastNotificationByType[type] == null ||
        now.difference(_lastNotificationByType[type]!) >
            _notificationCooldown) {
      PLoaders.warningSnackBar(title: title, message: message);
      _lastNotificationByType[type] = now;
    }
  }

  // Hiển thị thông báo thành công với kiểm soát tần suất
  void showSuccess(String title, String message, [String type = 'general']) {
    final now = DateTime.now();
    if (_lastNotificationByType[type] == null ||
        now.difference(_lastNotificationByType[type]!) >
            _notificationCooldown) {
      PLoaders.successSnackBar(title: title, message: message);
      _lastNotificationByType[type] = now;
    }
  }

  void showOSuccess(String message, [String type = 'general']) {
    final now = DateTime.now();
    if (_lastNotificationByType[type] == null ||
        now.difference(_lastNotificationByType[type]!) >
            _notificationCooldown) {
      PLoaders.successOBar(message: message);
      _lastNotificationByType[type] = now;
    }
  }

  // Hiển thị thông báo toast với kiểm soát tần suất
  void showToast(String message, [String type = 'general']) {
    final now = DateTime.now();
    if (_lastNotificationByType[type] == null ||
        now.difference(_lastNotificationByType[type]!) >
            _notificationCooldown) {
      PLoaders.customToast(message: message);
      _lastNotificationByType[type] = now;
    }
  }

  // Sửa phương thức addToCart để cộng dồn thay vì cập nhật
  void addToCart(ProductModel product, [bool additive = false]) async {
    try {
      // Lấy dữ liệu mới nhất để đảm bảo cập nhật tồn kho
      final currentProduct =
          await ProductRepository.instance.getProductById(product.id);

      // Xử lý sản phẩm biến thể
      if (currentProduct.productType == ProductType.variable.toString()) {
        final variationController = VariationController.instance;

        // Kiểm tra đã chọn biến thể chưa
        if (variationController.selectedVariation.value.id.isEmpty) {
          showToast('Vui lòng chọn phân loại', 'choose_variation');
          return;
        }

        // Lấy biến thể được chọn
        final variation = currentProduct.productVariations!.firstWhere(
            (v) => v.id == variationController.selectedVariation.value.id,
            orElse: () => ProductVariationModel.empty());

        if (variation.id.isEmpty) {
          showWarning('Có lỗi xảy ra', 'Không tìm thấy phân loại đã chọn',
              'variation_not_found');
          return;
        }

        // Tính số lượng tồn kho khả dụng
        final availableStock = variation.stock - variation.soldQuantity;

        if (availableStock <= 0) {
          showWarning('Hết hàng', 'Phân loại này đã hết hàng', 'out_of_stock');
          return;
        }

        // Kiểm tra số lượng hiện có trong giỏ
        final currentQuantityInCart =
            getVariationQuantityInCart(currentProduct.id, variation.id);

        // Nếu thêm mới vượt quá tồn khọ
        if (currentQuantityInCart + productQuantityInCart.value >
            availableStock) {
          final remainingStock = availableStock - currentQuantityInCart;

          if (remainingStock <= 0) {
            showWarning(
                'Đã đạt giới hạn',
                'Bạn đã thêm hết số lượng tồn kho vào giỏ hàng',
                'max_stock_reached');
            return;
          }

          // Điều chỉnh số lượng thêm vào để không vượt quá tồn kho
          productQuantityInCart.value = remainingStock;
        }

        // Tạo đối tượng CartModel
        final cartItem =
            convertToCartItem(currentProduct, productQuantityInCart.value);

        // Tìm trong giỏ hàng
        int index = cartItems.indexWhere((item) =>
            item.productId == cartItem.productId &&
            item.variationId == cartItem.variationId);

        if (index >= 0) {
          if (additive) {
            // Cộng dồn số lượng
            cartItems[index].quantity += cartItem.quantity;
          } else {
            // Thay thế số lượng (hành vi cũ)
            cartItems[index].quantity = cartItem.quantity;
          }
        } else {
          // Thêm mới
          cartItems.add(cartItem);
          final key = getItemKey(cartItem);
          selectedItems[key] = false;
          selectAll.value = false;
        }
      } else {
        // Xử lý sản phẩm thường
        final availableStock =
            currentProduct.stock - currentProduct.soldQuantity;

        if (availableStock <= 0) {
          showWarning('Hết hàng', 'Sản phẩm này đã hết hàng', 'out_of_stock');
          return;
        }

        // Kiểm tra số lượng hiện có trong giỏ
        final currentQuantityInCart =
            getProductQuantityInCart(currentProduct.id);

        // Nếu thêm mới vượt quá tồn khọ
        if (currentQuantityInCart + productQuantityInCart.value >
            availableStock) {
          final remainingStock = availableStock - currentQuantityInCart;

          if (remainingStock <= 0) {
            showWarning(
                'Đã đạt giới hạn',
                'Bạn đã thêm hết số lượng tồn kho vào giỏ hàng',
                'max_stock_reached');
            return;
          }

          // Điều chỉnh số lượng
          productQuantityInCart.value = remainingStock;
        }

        // Tạo đối tượng CartModel
        final cartItem =
            convertToCartItem(currentProduct, productQuantityInCart.value);

        int index = cartItems.indexWhere((item) =>
            item.productId == cartItem.productId &&
            item.variationId == cartItem.variationId);

        if (index >= 0) {
          if (additive) {
            // Cộng dồn số lượng
            cartItems[index].quantity += cartItem.quantity;
          } else {
            // Thay thế số lượng (hành vi cũ)
            cartItems[index].quantity = cartItem.quantity;
          }
        } else {
          // Thêm mới
          cartItems.add(cartItem);
          final key = getItemKey(cartItem);
          selectedItems[key] = false;
          selectAll.value = false;
        }
      }

      // Cập nhật giỏ hàng và thông báo
      updateCart();
      showOSuccess('Đã thêm vào giỏ hàng', 'add_to_cart');
    } catch (e) {
      showWarning(
          'Có lỗi xảy ra', 'Không thể thêm vào giỏ hàng: $e', 'add_error');
    }
  }

  void addOneToCart(CartModel item) async {
    try {
      // Lấy dữ liệu sản phẩm mới nhất để có thông tin tồn kho cập nhật
      final product =
          await ProductRepository.instance.getProductById(item.productId);

      // Xác định số lượng tồn kho khả dụng
      int availableStock;

      // Kiểm tra nếu là sản phẩm biến thể
      if (item.variationId.isNotEmpty) {
        // Tìm biến thể tương ứng
        final variation = product.productVariations!.firstWhere(
            (v) => v.id == item.variationId,
            orElse: () => ProductVariationModel.empty());

        if (variation.id.isEmpty) {
          showWarning('Có lỗi xảy ra', 'Không tìm thấy phân loại sản phẩm',
              'variation_not_found');
          return;
        }

        availableStock = variation.stock - variation.soldQuantity;
      } else {
        // Sản phẩm thường
        availableStock = product.stock - product.soldQuantity;
      }

      // Kiểm tra số lượng hiện có trong giỏ
      final currentInCart = cartItems
          .firstWhere(
              (cartItem) =>
                  cartItem.productId == item.productId &&
                  cartItem.variationId == item.variationId,
              orElse: () => CartModel.empty())
          .quantity;

      // Kiểm tra xem có thể thêm 1 sản phẩm nữa không
      if (currentInCart >= availableStock) {
        showWarning(
            'Đã đạt giới hạn tồn kho',
            'Chỉ còn $availableStock sản phẩm, bạn đã có $currentInCart trong giỏ hàng',
            'stock_limit');
        return;
      }

      // Tiếp tục thêm sản phẩm nếu còn tồn kho
      int index = cartItems.indexWhere((cartItem) =>
          cartItem.productId == item.productId &&
          cartItem.variationId == item.variationId);

      if (index >= 0) {
        cartItems[index].quantity += 1;
      } else {
        cartItems.add(item);
        final key = getItemKey(item);
        selectedItems[key] = false;
        selectAll.value = false;
      }

      updateCart();
    } catch (e) {
      showWarning('Có lỗi xảy ra', 'Không thể thêm sản phẩm vào giỏ hàng: $e',
          'add_error');
    }
  }

  void removeOneFromCart(CartModel item) {
    int index = cartItems.indexWhere((cartItem) =>
        cartItem.productId == item.productId &&
        cartItem.variationId == item.variationId);

    if (index >= 0) {
      if (cartItems[index].quantity > 1) {
        cartItems[index].quantity -= 1;
      } else {
        cartItems[index].quantity == 1
            ? removeFromCartDialog(index)
            : cartItems.removeAt(index);
      }

      updateCart();
    }
  }

  void removeFromCartDialog(int index) {
    Get.defaultDialog(
      contentPadding: const EdgeInsets.all(PSizes.md),
      title: 'Xóa sản phẩm',
      middleText: 'Bạn có chắc chắn muốn xóa sản phẩm này khỏi giỏ hàng không?',
      confirm: ElevatedButton(
        onPressed: () {
          Get.back();
          cartItems.removeAt(index);
          updateCart();
          showSuccess(
              'Đã xóa', 'Sản phẩm đã được xóa khỏi giỏ hàng', 'remove_item');
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: PColors.error,
          side: const BorderSide(color: PColors.error),
        ),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: PSizes.lg),
          child: Text('Xóa'),
        ),
      ),
      cancel: OutlinedButton(
        child: const Text('Hủy'),
        onPressed: () => Get.back(),
      ),
    );
  }

  void updateAlreadyAddedProductCount(ProductModel product) {
    if (product.productType == ProductType.single.toString()) {
      int quantity = getProductQuantityInCart(product.id);
      productQuantityInCart.value = quantity > 0 ? quantity : 1;
    } else {
      final variationId = variationController.selectedVariation.value.id;
      if (variationId.isNotEmpty) {
        int quantity = getVariationQuantityInCart(product.id, variationId);
        productQuantityInCart.value = quantity > 0 ? quantity : 1;
      } else {
        productQuantityInCart.value = 1;
      }
    }
  }

  CartModel convertToCartItem(ProductModel product, int quantity) {
    if (product.productType == ProductType.single.toString()) {
      variationController.resetSelectedAttributes();
    }

    final variation = variationController.selectedVariation.value;
    final isVariation = variation.id.isNotEmpty;
    final price = isVariation
        ? variation.salePrice > 0
            ? variation.salePrice
            : variation.price
        : product.salePrice > 0
            ? product.salePrice
            : product.price;

    return CartModel(
      productId: product.id,
      title: product.title,
      price: price,
      quantity: quantity,
      variationId: variation.id,
      image: isVariation ? variation.image : product.thumbnail,
      brandName: product.brand != null ? product.brand!.name : '',
      selectedVariation: isVariation ? variation.attributeValues : null,
    );
  }

  void updateCart() {
    updateCartTotals();
    saveCartItems();
    saveSelectedItems();
    cartItems.refresh();
    updateSelectAll();
    updateSelectedPrice();
  }

  void updateCartTotals() {
    double calculatedTotalPrice = 0.0;
    int calculatedNoOfItems = 0;

    for (var item in cartItems) {
      calculatedTotalPrice += (item.price) * item.quantity.toDouble();
      calculatedNoOfItems += item.quantity;
    }

    totalCartPrice.value = calculatedTotalPrice;
    noOfCartItems.value = calculatedNoOfItems;
  }

  void saveCartItems() {
    final cartItemStrings = cartItems.map((item) => item.toJson()).toList();
    PLocalStorage.instance().writeData('cartItems', cartItemStrings);
  }

  void loadCartItems() {
    final cartItemStrings =
        PLocalStorage.instance().readData<List<dynamic>>('cartItems');
    if (cartItemStrings != null) {
      cartItems.assignAll(cartItemStrings
          .map((item) => CartModel.fromJson(item as Map<String, dynamic>)));

      final selectedItemsData =
          PLocalStorage.instance().readData('selectedCartItems');

      if (selectedItemsData != null &&
          selectedItemsData is Map<String, dynamic>) {
        selectedItems.clear();
        selectedItemsData.forEach((key, value) {
          if (value is bool) {
            selectedItems[key] = value;
          }
        });
      } else {
        selectedItems.clear();
        for (var item in cartItems) {
          final key = getItemKey(item);
          selectedItems[key] = false;
        }
      }

      updateCartTotals();
      updateSelectAll();
      updateSelectedPrice();
    }
  }

// Thêm phương thức để lưu trạng thái chọn
  void saveSelectedItems() {
    PLocalStorage.instance().writeData('selectedCartItems', selectedItems);
  }

  int getProductQuantityInCart(String productId) {
    final foundItem = cartItems
        .where((item) => item.productId == productId)
        .fold(0, (previousValue, element) => previousValue + element.quantity);
    return foundItem;
  }

  int getVariationQuantityInCart(String productId, String variationId) {
    final foundItem = cartItems.firstWhere(
      (item) => item.productId == productId && item.variationId == variationId,
      orElse: () => CartModel.empty(),
    );
    return foundItem.quantity;
  }

  void clearCart() {
    productQuantityInCart.value = 0;
    cartItems.clear();
    updateCart();
  }

  // Phương thức mới để tạo key duy nhất cho mỗi item trong giỏ hàng
  String getItemKey(CartModel item) {
    return "${item.productId}_${item.variationId}";
  }

  // Chọn/bỏ chọn một sản phẩm
  void toggleSelectItem(CartModel item) {
    final key = getItemKey(item);
    if (selectedItems.containsKey(key)) {
      selectedItems[key] = !selectedItems[key]!;
    } else {
      selectedItems[key] = true;
    }
    updateSelectAll();
    updateSelectedPrice();
  }

  // Cập nhật trạng thái "Chọn tất cả"
  void updateSelectAll() {
    if (cartItems.isEmpty) {
      selectAll.value = false;
      return;
    }

    bool allSelected = true;
    for (var item in cartItems) {
      final key = getItemKey(item);
      if (!selectedItems.containsKey(key) || !selectedItems[key]!) {
        allSelected = false;
        break;
      }
    }

    selectAll.value = allSelected;
  }

  // Chọn/bỏ chọn tất cả sản phẩm
  void toggleSelectAll() {
    selectAll.value = !selectAll.value;

    for (var item in cartItems) {
      final key = getItemKey(item);
      selectedItems[key] = selectAll.value;
    }

    updateSelectedPrice();
  }

  // Cập nhật giá của các sản phẩm được chọn
  void updateSelectedPrice() {
    double total = 0;

    for (var item in cartItems) {
      final key = getItemKey(item);
      if (selectedItems.containsKey(key) && selectedItems[key]!) {
        total += item.price * item.quantity;
      }
    }

    selectedItemsPrice.value = total;
  }

  void removeSelectedItems() {
    // Tạo danh sách các sản phẩm cần xóa
    List<CartModel> itemsToRemove = [];

    for (var item in cartItems) {
      final key = getItemKey(item);
      if (selectedItems.containsKey(key) && selectedItems[key]!) {
        itemsToRemove.add(item);
      }
    }

    // Xóa lần lượt từng sản phẩm
    for (var item in itemsToRemove) {
      cartItems.removeWhere((cartItem) =>
          cartItem.productId == item.productId &&
          cartItem.variationId == item.variationId);
      selectedItems.remove(getItemKey(item));
    }

    updateCart();
    updateSelectAll();
    updateSelectedPrice();

    // Sử dụng phương thức mới để hiển thị thông báo
    showSuccess('Đã xóa', 'Các sản phẩm đã chọn đã được xóa khỏi giỏ hàng',
        'remove_selected');
  }

  // Phương thức kiểm tra giỏ hàng hợp lệ để thanh toán
  bool validateCheckout(double minOrderValue, double maxOrderValue) {
    final selectedItems = getSelectedItems();
    final selectedPrice = selectedItemsPrice.value;

    if (selectedItems.isEmpty) {
      showWarning('Chưa có sản phẩm nào được chọn',
          'Vui lòng chọn ít nhất một sản phẩm để thanh toán', 'checkout_empty');
      return false;
    } else if (selectedPrice < minOrderValue) {
      showWarning(
          'Giá trị tối thiểu: ${PHelperFunctions.formatCurrency(minOrderValue.toInt())}',
          'Vui lòng thêm sản phẩm để đạt giá trị thanh toán tối thiểu',
          'checkout_min_value');
      return false;
    } else if (selectedPrice > maxOrderValue) {
      showWarning(
          'Giá trị tối đa: ${PHelperFunctions.formatCurrency(maxOrderValue.toInt())}',
          'Vui lòng giảm số lượng sản phẩm để không vượt giá trị cho phép',
          'checkout_max_value');
      return false;
    }

    return true;
  }

  // Lấy danh sách các sản phẩm đã chọn
  List<CartModel> getSelectedItems() {
    return cartItems.where((item) {
      final key = getItemKey(item);
      return selectedItems.containsKey(key) && selectedItems[key]!;
    }).toList();
  }

  int getTotalSelectedQuantity() {
    int totalQuantity = 0;
    for (var item in getSelectedItems()) {
      totalQuantity += item.quantity;
    }
    return totalQuantity;
  }
}
