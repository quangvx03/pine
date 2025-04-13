import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pine_admin_panel/features/shop/controllers/product/create_product_controller.dart';
import 'package:pine_admin_panel/utils/constants/enums.dart';
import 'package:pine_admin_panel/utils/validators/validation.dart';

import '../../../../../../../utils/constants/sizes.dart';


class ProductStockAndPricing extends StatelessWidget {
  const ProductStockAndPricing({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = CreateProductController.instance;

    return Obx(
          () => controller.productType.value == ProductType.single
          ? Form(
        key: controller.stockPriceFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stock
            FractionallySizedBox(
              widthFactor: 0.45,
              child: TextFormField(
                controller: controller.stock,
                decoration: const InputDecoration(labelText: 'Kho', hintText: 'Thêm kho, chỉ được phép số',),
                validator: (value) => PValidator.validateEmptyText('Kho', value),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly,],
              ),
            ),
            const SizedBox(height: PSizes.spaceBtwInputFields),

            // Pricing
            Row(
              children: [
                // Price
                Expanded(
                  child: TextFormField(
                    controller: controller.price,
                    decoration: const InputDecoration(labelText: 'Giá', hintText: 'Nhập giá sản phẩm',),
                    validator: (value) => PValidator.validateEmptyText('Giá', value),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly,],
                  ),
                ),
                const SizedBox(width: PSizes.spaceBtwItems),

                // Sale Price
                Expanded(
                  child: TextFormField(
                    controller: controller.salePrice,
                    decoration: const InputDecoration(
                      labelText: 'Giảm giá',
                      hintText: 'Nhập giá sản phẩm',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly, // Chỉ cho phép nhập số
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      )
          : const SizedBox.shrink(),
    );
  }
}
