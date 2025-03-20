import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pine_admin_panel/utils/validators/validation.dart';

import '../../../../../../utils/constants/sizes.dart';

class ProductStockAndPricing extends StatelessWidget {
  const ProductStockAndPricing({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stock
            FractionallySizedBox(
              widthFactor: 0.45,
              child: TextFormField(
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
                      decoration: const InputDecoration(labelText: 'Giá', hintText: 'Nhập giá sản phẩm'),
                      validator: (value) => PValidator.validateEmptyText('Giá', value),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0}đ')),
                      ],
                    ),
                ),
                const SizedBox(width: PSizes.spaceBtwItems),

                // Sale Price
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(labelText: 'Giảm giá', hintText: 'Nhập giá sản phẩm'),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0}đ')),
                    ],
                  ),
                ),
              ],
            )
          ],
        )
    );
  }
}
