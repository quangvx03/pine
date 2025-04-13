import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pine_admin_panel/features/shop/controllers/product/create_product_controller.dart';
import 'package:pine_admin_panel/features/shop/controllers/product/edit_product_controller.dart';
import 'package:pine_admin_panel/features/shop/models/product_model.dart';
import 'package:pine_admin_panel/utils/constants/enums.dart';
import 'package:pine_admin_panel/utils/validators/validation.dart';

import '../../../../../../../utils/constants/sizes.dart';


class ProductStockAndPricing extends StatelessWidget {
  const ProductStockAndPricing({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final editController = EditProductController.instance;

    return Obx(
      () => editController.productType.value == ProductType.single
      ? Form(
        key: editController.stockPriceFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Stock
              FractionallySizedBox(
                widthFactor: 0.45,
                child: TextFormField(
                  controller: editController.stock,
                  decoration: const InputDecoration(labelText: 'Kho', hintText: 'Thêm kho, chỉ được phép "số"'),
                  validator: (value) => PValidator.validateEmptyText('Kho', value),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                ),
              ),
              const SizedBox(height: PSizes.spaceBtwInputFields),

              // Pricing
              Row(
                children: [
                  // Price
                  Expanded(
                      child: TextFormField(
                        controller: editController.price,
                        decoration: const InputDecoration(labelText: 'Giá', hintText: 'Nhập giá sản phẩm'),
                        validator: (value) => PValidator.validateEmptyText('Giá', value),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                  ),
                  const SizedBox(width: PSizes.spaceBtwItems),

                  // Sale Price
                  Expanded(
                    child: TextFormField(
                      controller: editController.salePrice,
                      decoration: const InputDecoration(labelText: 'Giảm giá', hintText: 'Nhập giá sản phẩm'),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly, // Chỉ cho phép nhập số
                      ],
                    ),
                  ),
                ],
              )
            ],
          )
      )
      : const SizedBox.shrink(),
    );
  }
}
