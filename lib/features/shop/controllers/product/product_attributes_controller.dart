import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pine_admin_panel/features/shop/controllers/product/product_variations_controller.dart';
import 'package:pine_admin_panel/features/shop/models/product_attribute_model.dart';
import 'package:pine_admin_panel/utils/popups/dialogs.dart';

class ProductAttributesController extends GetxController {
  static ProductAttributesController get instance => Get.find();

  final isLoading = false.obs;
  final attributesFormKey = GlobalKey<FormState>();
  TextEditingController attributeName = TextEditingController();
  TextEditingController attributes = TextEditingController();
  final RxList<ProductAttributeModel> productAttributes = <ProductAttributeModel>[].obs;

  void addNewAttribute() {
    if (!attributesFormKey.currentState!.validate()) { return;}

    productAttributes.add(ProductAttributeModel(
      name: attributeName.text.trim(),
      values: attributes.text.trim().split('|').toList(),
    ));

    attributeName.text = '';
    attributes.text = '';
  }

  void removeAttribute(int index, BuildContext context) {
    PDialogs.defaultDialog(
      context: context,
      title: 'Xóa thuộc tính',
      content: 'Bạn có chắc chắn muốn xóa thuộc tính này không?',
      onConfirm: () {
        Navigator.of(context).pop();
        productAttributes.removeAt(index);

        ProductVariationController.instance.productVariations.value = [];
      },
    );
  }

  void resetProductAttributes() {
    productAttributes.clear();
  }
}
