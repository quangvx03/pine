import 'package:get/get.dart';
import 'package:pine/features/shop/controllers/product/cart_controller.dart';
import 'package:pine/features/shop/controllers/product/images_controller.dart';
import 'package:pine/features/shop/models/product_model.dart';
import 'package:pine/features/shop/models/product_variation_model.dart';

class VariationController extends GetxController {
  static VariationController get instance => Get.find();

  RxMap selectedAttributes = {}.obs;
  RxString variationStockStatus = ''.obs;
  Rx<ProductVariationModel> selectedVariation =
      ProductVariationModel.empty().obs;

  // Thêm trường để lưu productId hiện tại
  String currentProductId = '';

// Sửa phương thức onAttributeSelected
  void onAttributeSelected(
      ProductModel product, attributeName, attributeValue) {
    // Lưu productId hiện tại
    currentProductId = product.id;

    final attrs = Map<String, dynamic>.from(selectedAttributes);

    if (attrs[attributeName] == attributeValue) {
      attrs.remove(attributeName);
      selectedAttributes.remove(attributeName);

      if (attrs.isEmpty) {
        selectedVariation.value = ProductVariationModel.empty();
        variationStockStatus.value = '';

        // Sử dụng tag của sản phẩm
        final imagesController = Get.find<ImagesController>(tag: product.id);
        if (product.thumbnail.isNotEmpty) {
          imagesController.selectedProductImage.value = product.thumbnail;
        }

        return;
      }
    } else {
      attrs[attributeName] = attributeValue;
      selectedAttributes[attributeName] = attributeValue;
    }

    final variation = product.productVariations!.firstWhere(
        (variation) => _isSameAttributeValues(variation.attributeValues, attrs),
        orElse: () => ProductVariationModel.empty());

    // Sử dụng tag của sản phẩm để tìm ImagesController đúng
    final imagesController = Get.find<ImagesController>(tag: product.id);
    if (variation.image.isNotEmpty) {
      imagesController.selectedProductImage.value = variation.image;
    } else if (product.thumbnail.isNotEmpty) {
      imagesController.selectedProductImage.value = product.thumbnail;
    }

    if (variation.id.isNotEmpty) {
      final cartController = CartController.instance;
      cartController.productQuantityInCart.value =
          cartController.getVariationQuantityInCart(product.id, variation.id);
    } else {
      CartController.instance.productQuantityInCart.value = 0;
    }

    selectedVariation.value = variation;
    getProductVariationStockStatus();
  }

  /// Kiểm tra xem các thuộc tính đã chọn có khớp với biến thể nào không
  bool _isSameAttributeValues(Map<String, dynamic> variationsAttributes,
      Map<String, dynamic> selectedAttributes) {
    if (variationsAttributes.length != selectedAttributes.length) return false;

    for (final key in variationsAttributes.keys) {
      if (variationsAttributes[key] != selectedAttributes[key]) return false;
    }

    return true;
  }

  /// Kiểm tra tính khả dụng của thuộc tính dựa trên tồn kho
  Set<String?> getAttributesAvailabilityInVariation(
      List<ProductVariationModel> variations, String attributeName) {
    final availableVariationAttributeValues = variations
        .where((variation) {
          final int availableStock = variation.stock - (variation.soldQuantity);
          return variation.attributeValues[attributeName] != null &&
              variation.attributeValues[attributeName]!.isNotEmpty &&
              availableStock > 0;
        })
        .map((variation) => variation.attributeValues[attributeName])
        .toSet();

    return availableVariationAttributeValues;
  }

  /// Lấy tồn kho khả dụng của biến thể được chọn
  int getVariationAvailableStock() {
    if (selectedVariation.value.id.isEmpty) return 0;
    return selectedVariation.value.stock -
        (selectedVariation.value.soldQuantity);
  }

  /// Cập nhật trạng thái tồn kho của biến thể
  void getProductVariationStockStatus() {
    if (selectedVariation.value.id.isEmpty) {
      variationStockStatus.value = '';
      return;
    }

    final availableStock =
        selectedVariation.value.stock - (selectedVariation.value.soldQuantity);
    variationStockStatus.value =
        availableStock > 0 ? 'Còn hàng ($availableStock)' : 'Hết hàng';
  }

  /// Lấy giá của biến thể được chọn
  String getVariationPrice() {
    return (selectedVariation.value.salePrice > 0
            ? selectedVariation.value.salePrice
            : selectedVariation.value.price)
        .toString();
  }

  /// Lấy các giá trị thuộc tính khả dụng dựa trên lựa chọn hiện tại
  Set<String> getAvailableAttributeValues(
      List<ProductVariationModel> variations,
      String attributeName,
      RxMap selectedAttributes) {
    final filteredVariations = variations.where((variation) {
      if (selectedAttributes.isEmpty) return true;

      bool match = true;
      selectedAttributes.forEach((name, value) {
        if (name != attributeName) {
          if (variation.attributeValues[name] != value) {
            match = false;
          }
        }
      });

      return match;
    }).toList();

    final availableValues = filteredVariations
        .where((variation) {
          final int availableStock = variation.stock - (variation.soldQuantity);
          return variation.attributeValues.containsKey(attributeName) &&
              variation.attributeValues[attributeName] != null &&
              variation.attributeValues[attributeName]!.isNotEmpty &&
              availableStock > 0;
        })
        .map((variation) => variation.attributeValues[attributeName]!)
        .toSet();

    return availableValues;
  }

  /// Reset các thuộc tính đã chọn khi chuyển sản phẩm
  void resetSelectedAttributes() {
    selectedAttributes.clear();
    variationStockStatus.value = '';
    selectedVariation.value = ProductVariationModel.empty();
  }
}
