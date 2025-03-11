import 'package:get/get.dart';
import 'package:pine/features/shop/controllers/product/variation_controller.dart';
import 'package:pine/features/shop/models/cart_item_model.dart';
import 'package:pine/features/shop/models/product_model.dart';
import 'package:pine/utils/constants/enums.dart';
import 'package:pine/utils/local_storage/storage_utility.dart';
import 'package:pine/utils/popups/loaders.dart';

class CartController extends GetxController {
  static CartController get instance => Get.find();

  RxInt noOfCartItems = 0.obs;
  RxDouble totalCartPrice = 0.0.obs;
  RxInt productQuantityInCart = 0.obs;
  RxList<CartItemModel> cartItems = <CartItemModel>[].obs;
  final variationController = VariationController.instance;

  CartController() {
    loadCartItems();
  }

  /// Add items in the cart
  void addToCart(ProductModel product) {
    // Quantity check
    if (productQuantityInCart.value < 1) {
      PLoaders.customToast(message: 'Chọn số lượng');
      return;
    }

    // Variation selected?
    if (product.productType == ProductType.variable.toString() &&
        variationController.selectedVariation.value.id.isEmpty) {
      PLoaders.customToast(message: 'Chọn phân loại');
      return;
    }

    // Out of stock status
    if (product.productType == ProductType.variable.toString()) {
      if (variationController.selectedVariation.value.stock < 1) {
        PLoaders.warningSnackBar(
            title: 'Có lỗi xảy ra!',
            message: 'Phân loại đã chọn hiện hết hàng.');
        return;
      }
    } else {
      if (product.stock < 1) {
        PLoaders.warningSnackBar(
            title: 'Có lỗi xảy ra!',
            message: 'Phân loại đã chọn hiện hết hàng.');
        return;
      }
    }

    // Convert the ProductModel to a CartItemModel with the given quantity
    final selectedCartItem =
    convertToCartItem(product, productQuantityInCart.value);

    // Check if already added in the Cart
    int index = cartItems.indexWhere((cartItem) =>
    cartItem.productId == selectedCartItem.productId &&
        cartItem.variationId == selectedCartItem.variationId);

    if (index >= 0) {
      // This quantity is already added or Updated/Removed from the design (Cart)(.)
      cartItems[index].quantity = selectedCartItem.quantity;
    } else {
      cartItems.add(selectedCartItem);
    }

    updateCart();
    PLoaders.customToast(
        message: 'Sản phẩm của bạn đã được thêm vào giỏ hàng.');
  }

  void addOneToCart(CartItemModel item) {
    int index = cartItems.indexWhere((cartItem) =>
    cartItem.productId == item.productId &&
        cartItem.variationId == item.variationId);

    if (index >= 0) {
      cartItems[index].quantity += 1;
    } else {
      cartItems.add(item);
    }

    updateCart();
  }

  void removeOneFromCart(CartItemModel item) {
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
      title: 'Xóa sản phẩm"',
      middleText: 'Bạn có chắc chắn muốn xóa sản phẩm này không?',
      onConfirm: () {
        cartItems.removeAt(index);
        updateCart();
        PLoaders.customToast(message: 'Sản phẩm đã được xóa khỏi giỏ hàng.');
        Get.back();
      },
      onCancel: () => () => Get.back(),
    );
  }

  /// Initialize already added item's count in the cart
  void updateAlreadyAddedProductCount(ProductModel product) {
    if (product.productType == ProductType.single.toString()) {
      productQuantityInCart.value = getProductQuantityInCart(product.id);
    } else {
      final variationId = variationController.selectedVariation.value.id;
      if (variationId.isNotEmpty) {
        productQuantityInCart.value =
            getVariationQuantityInCart(product.id, variationId);
      } else {
        productQuantityInCart.value = 0;
      }
    }
  }

  /// This function convert a ProductModel to a CartItemModel
  CartItemModel convertToCartItem(ProductModel product, int quantity) {
    if (product.productType == ProductType.single.toString()) {
      // Reset variation in case of single product type
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

    return CartItemModel(
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

  /// Update cart values
  void updateCart() {
    updateCartTotals();
    saveCartItems();
    cartItems.refresh();
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
          .map((item) => CartItemModel.fromJson(item as Map<String, dynamic>)));
      updateCartTotals();
    }
  }

  int getProductQuantityInCart(String productId) {
    final foundItem = cartItems
        .where((item) => item.productId == productId)
        .fold(0, (previousValue, element) => previousValue + element.quantity);
    return foundItem;
  }

  int getVariationQuantityInCart(String productId, String variationId) {
    final foundItem = cartItems.firstWhere(
          (item) =>
      item.productId == productId && item.variationId == variationId,
      orElse: () => CartItemModel.empty(),
    );
    return foundItem.quantity;
  }

  void clearCart() {
    productQuantityInCart.value = 0;
    cartItems.clear();
    updateCart();
  }
}
