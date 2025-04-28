import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pine_admin_panel/features/shop/controllers/product/product_attributes_controller.dart';
import 'package:pine_admin_panel/features/shop/models/product_variation_model.dart';
import 'package:pine_admin_panel/utils/popups/dialogs.dart';

class ProductVariationController extends GetxController {
  static ProductVariationController get instance => Get.find();

  final isLoading = false.obs;
  final RxList<ProductVariationModel> productVariations = <ProductVariationModel>[].obs;

  // ✅ Use variation.id as key for easy access
  final stockControllers = <String, TextEditingController>{};
  final priceControllers = <String, TextEditingController>{};
  final salePriceControllers = <String, TextEditingController>{};
  final descriptionControllers = <String, TextEditingController>{};

  final attributesController = Get.put(ProductAttributesController());

  void initializeVariationControllers(List<ProductVariationModel> variations) {
    stockControllers.clear();
    priceControllers.clear();
    salePriceControllers.clear();
    descriptionControllers.clear();

    for (var variation in variations) {
      stockControllers[variation.id] = TextEditingController(text: variation.stock.toString());
      priceControllers[variation.id] = TextEditingController(text: variation.price.toString());
      salePriceControllers[variation.id] = TextEditingController(text: variation.salePrice.toString());
      descriptionControllers[variation.id] = TextEditingController(text: variation.description.toString());
    }
  }

  void removeVariations(BuildContext context) {
    PDialogs.defaultDialog(
      context: context,
      title: 'Xóa thuộc tính',
      onConfirm: () {
        productVariations.clear();
        resetAllValues();
        Navigator.of(context).pop();
      },
    );
  }

  void generateVariationsConfirmation(BuildContext context) {
    PDialogs.defaultDialog(
      context: context,
      confirmText: 'Tạo',
      title: 'Tạo thể loại',
      content:
      'Một khi các thể loại được tạo ra, bạn không thể thêm nhiều thuộc tính hơn. Để thêm nhiều thể loại hơn, bạn phải xóa bất kỳ thuộc tính nào.',
      onConfirm: generateVariationsFromAttributes,
    );
  }

  void generateVariationsFromAttributes() {
    resetAllValues();
    final variations = <ProductVariationModel>[];

    if (attributesController.productAttributes.isNotEmpty) {
      final attributeCombinations = getCombinations(
        attributesController.productAttributes.map((attr) => attr.values ?? <String>[]).toList(),
      );

      for (final combination in attributeCombinations) {
        final attributeValues = Map.fromIterables(
          attributesController.productAttributes.map((attr) => attr.name ?? ''),
          combination,
        );

        final variation = ProductVariationModel(
          id: UniqueKey().toString(),
          attributeValues: attributeValues,
        );

        variations.add(variation);

        stockControllers[variation.id] = TextEditingController();
        priceControllers[variation.id] = TextEditingController();
        salePriceControllers[variation.id] = TextEditingController();
        descriptionControllers[variation.id] = TextEditingController();
      }
    }

    productVariations.assignAll(variations);
  }

  List<List<String>> getCombinations(List<List<String>> lists) {
    final result = <List<String>>[];
    combine(lists, 0, <String>[], result);
    return result;
  }

  void combine(List<List<String>> lists, int index, List<String> current, List<List<String>> result) {
    if (index == lists.length) {
      result.add(List.from(current));
      return;
    }

    for (final item in lists[index]) {
      final updated = List<String>.from(current)..add(item);
      combine(lists, index + 1, updated, result);
    }
  }

  void resetAllValues() {
    productVariations.clear();
    stockControllers.clear();
    priceControllers.clear();
    salePriceControllers.clear();
    descriptionControllers.clear();
  }
}
