import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pine_admin_panel/features/shop/controllers/product/product_attributes_controller.dart';
import 'package:pine_admin_panel/features/shop/models/product_variation_model.dart';
import 'package:pine_admin_panel/utils/popups/dialogs.dart';

class ProductVariationController extends GetxController {
  static ProductVariationController get instance => Get.find();

  final isLoading = false.obs;
  final RxList<ProductVariationModel> productVariations = <ProductVariationModel>[].obs;

  List<Map<ProductVariationModel, TextEditingController>> stockControllersList = [];
  List<Map<ProductVariationModel, TextEditingController>> priceControllersList = [];
  List<Map<ProductVariationModel, TextEditingController>> salePriceControllersList = [];
  List<Map<ProductVariationModel, TextEditingController>> descriptionControllersList = [];

  final attributesController = Get.put(ProductAttributesController());

  void initializeVariationControllers(List<ProductVariationModel> variations) {
    stockControllersList.clear();
    priceControllersList.clear();
    salePriceControllersList.clear();
    descriptionControllersList.clear();

    for (var variation in variations) {
      Map<ProductVariationModel, TextEditingController> stockControllers = {};
      stockControllers[variation] = TextEditingController(text: variation.stock.toString());
      stockControllersList.add(stockControllers);

      Map<ProductVariationModel, TextEditingController> priceControllers = {};
      priceControllers[variation] = TextEditingController(text: variation.price.toString());
      priceControllersList.add(priceControllers);

      Map<ProductVariationModel, TextEditingController> salePriceControllers = {};
      salePriceControllers[variation] = TextEditingController(text: variation.salePrice.toString());
      salePriceControllersList.add(salePriceControllers);

      Map<ProductVariationModel, TextEditingController> descriptionControllers = {};
      descriptionControllers[variation] = TextEditingController(text: variation.description.toString());
      descriptionControllersList.add(descriptionControllers);
    }

  }

  void removeVariations(BuildContext context) {
    PDialogs.defaultDialog(
        context: context,
      title: 'Xóa thuộc tính',
      onConfirm: () {
          productVariations.value = [];
          resetAllValues();
          Navigator.of(context).pop();
      }
    );
  }

  void generateVariationsConfirmation(BuildContext context) {
    PDialogs.defaultDialog(
        context: context,
      confirmText: 'Tạo',
      title: 'Tạo thể loại',
      content: 'Một khi các thể loại được tạo ra, bạn không thể thêm nhiều thuộc tính hơn. Để thêm nhiều thể loại hơn, bạn phải xóa bất kỳ thuộc tính nào.',
      onConfirm: () => generateVariationsFromAttributes(),
    );
  }

  void generateVariationsFromAttributes() {

    final List<ProductVariationModel> variations = [];

    if (attributesController.productAttributes.isNotEmpty) {
      final List<List<String>> attributeCombinations =
          getCombinations(attributesController.productAttributes.map((attr) => attr.values ?? <String>[]).toList());

      for (final combination in attributeCombinations) {
        final Map<String, String> attributeValues =
            Map.fromIterables(attributesController.productAttributes.map((attr) => attr.name ?? ''), combination);

        final ProductVariationModel variation = ProductVariationModel(id: UniqueKey().toString(), attributeValues: attributeValues);

        variations.add(variation);

        final Map<ProductVariationModel, TextEditingController> stockControllers = {};
        final Map<ProductVariationModel, TextEditingController> priceControllers = {};
        final Map<ProductVariationModel, TextEditingController> salePriceControllers = {};
        final Map<ProductVariationModel, TextEditingController> descriptionControllers = {};

        stockControllers[variation] = TextEditingController();
        priceControllers[variation] = TextEditingController();
        salePriceControllers[variation] = TextEditingController();
        descriptionControllers[variation] = TextEditingController();

        stockControllersList.add(stockControllers);
        priceControllersList.add(priceControllers);
        salePriceControllersList.add(salePriceControllers);
        descriptionControllersList.add(descriptionControllers);
      }
    }

    productVariations.assignAll(variations);
  }

  List<List<String>> getCombinations(List<List<String>> lists) {
    final List<List<String>> result = [];
    combine(lists, 0, <String>[], result);
    return result;
  }

  void combine(List<List<String>> lists, int index, List<String> current, List<List<String>> result) {
    if (index == lists.length) {
      result.add(List.from(current));
      return;
    }

    for (final item in lists[index]) {
      final List<String> updated = List.from(current)..add(item);
      combine(lists, index + 1, updated, result);
    }
  }

  void resetAllValues() {
    productVariations.clear();
    stockControllersList.clear();
    priceControllersList.clear();
    salePriceControllersList.clear();
    descriptionControllersList.clear();
  }
}