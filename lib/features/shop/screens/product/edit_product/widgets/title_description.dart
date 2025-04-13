import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pine_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:pine_admin_panel/features/shop/controllers/product/create_product_controller.dart';
import 'package:pine_admin_panel/features/shop/controllers/product/edit_product_controller.dart';
import 'package:pine_admin_panel/features/shop/models/product_model.dart';
import 'package:pine_admin_panel/utils/validators/validation.dart';

import '../../../../../../../utils/constants/sizes.dart';


class ProductTitleAndDescription extends StatelessWidget {
  const ProductTitleAndDescription({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final editController = Get.put(EditProductController());

    return PRoundedContainer(
      child: Form(
        key: editController.titleDescriptionFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Basic Information Text
              Text('Thông tin cơ bản', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: PSizes.spaceBtwItems),

              // Product Title Input Field
              TextFormField(
                controller: editController.title,
                validator: (value) => PValidator.validateEmptyText('Tiêu đề sản phẩm', value),
                decoration: const InputDecoration(labelText: 'Tiêu đề sản phẩm'),
              ),
              const SizedBox(height: PSizes.spaceBtwInputFields),

              // Product Description Input Field
              SizedBox(
                height: 300,
                child: TextFormField(
                  expands: true,
                  maxLines: null,
                  textAlign: TextAlign.start,
                  controller: editController.description,
                  keyboardType: TextInputType.multiline,
                  textAlignVertical: TextAlignVertical.top,
                  validator: (value) => PValidator.validateEmptyText('Mô tả sản phẩm', value),
                  decoration: const InputDecoration(
                    labelText: 'Mô tả sản phẩm',
                    hintText: 'Thêm mô tả sản phẩm...',
                    alignLabelWithHint: true,
                  ),
                ),
              )
            ],
          )
      ),
    );
  }
}
