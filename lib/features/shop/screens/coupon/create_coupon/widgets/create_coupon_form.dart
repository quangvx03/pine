import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pine_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:pine_admin_panel/common/widgets/shimmers/shimmer.dart';
import 'package:pine_admin_panel/features/shop/controllers/coupon/create_coupon_controller.dart';
import 'package:pine_admin_panel/utils/constants/sizes.dart';
import 'package:pine_admin_panel/utils/validators/validation.dart';

import '../../../../controllers/coupon/coupon_controller.dart';



class CreateCouponForm extends StatelessWidget {
  const CreateCouponForm({super.key});

  @override
  Widget build(BuildContext context) {
    final createController = Get.put(CreateCouponController());
    final couponController = Get.put(CouponController());

    return PRoundedContainer(
      width: 800,
      padding: const EdgeInsets.all(PSizes.defaultSpace),
      child: Form(
        key: createController.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Heading
            const SizedBox(height: PSizes.sm),
            Text('Tạo mã giảm giá', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: PSizes.spaceBtwSections),

            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: createController.couponCode,
                        validator: (value) => PValidator.validateEmptyText('Mã giảm giá', value),
                        decoration: const InputDecoration(
                          labelText: 'Mã giảm giá',
                          prefixIcon: Icon(Iconsax.ticket),
                          contentPadding: EdgeInsets.symmetric(vertical: 15),
                        ),
                      ),
                      const SizedBox(height: PSizes.spaceBtwInputFields),

                      Obx(
                            () => couponController.isLoading.value
                            ? const PShimmerEffect(width: double.infinity, height: 55)
                            : DropdownButtonFormField<String>(
                          value: createController.type.value.isEmpty ? null : createController.type.value,
                          onChanged: (value) => createController.type.value = value ?? '',
                          items: ['Phần trăm', 'Cố định']
                              .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                              .toList(),
                          decoration: const InputDecoration(
                            labelText: 'Loại giảm giá',
                            prefixIcon: Icon(Iconsax.category),
                            contentPadding: EdgeInsets.symmetric(vertical: 15),
                          ),
                        ),
                      ),
                      const SizedBox(height: PSizes.spaceBtwInputFields),

                      TextFormField(
                        controller: createController.discountAmount,
                        validator: (value) => PValidator.validateEmptyText('Số tiền giảm', value),
                        decoration: const InputDecoration(
                          labelText: 'Số tiền giảm',
                          prefixIcon: Icon(Iconsax.money),
                          contentPadding: EdgeInsets.symmetric(vertical: 15),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: PSizes.spaceBtwInputFields),

                      TextFormField(
                        controller: createController.description,
                        validator: (value) => PValidator.validateEmptyText('Mô tả', value),
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'Mô tả mã giảm giá',
                          prefixIcon: Icon(Iconsax.message),
                          contentPadding: EdgeInsets.symmetric(vertical: 15),
                        ),
                      ),
                      const SizedBox(height: PSizes.spaceBtwInputFields),
                    ],
                  ),
                ),

                const SizedBox(width: PSizes.spaceBtwSections),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Minimum Purchase Amount Text Field
                      TextFormField(
                        controller: createController.minimumPurchaseAmount,
                        validator: (value) => PValidator.validateEmptyText('Mức mua tối thiểu', value),
                        decoration: const InputDecoration(
                          labelText: 'Mức mua tối thiểu',
                          prefixIcon: Icon(Iconsax.shopping_cart),
                          contentPadding: EdgeInsets.symmetric(vertical: 15),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: PSizes.spaceBtwInputFields),

                      TextFormField(
                        controller: createController.endDate,
                        validator: (value) => PValidator.validateEmptyText('Ngày hết hạn', value),
                        decoration: const InputDecoration(
                          labelText: 'Ngày hết hạn',
                          prefixIcon: Icon(Iconsax.calendar),
                          contentPadding: EdgeInsets.symmetric(vertical: 15),
                        ),
                        readOnly: true,
                        onTap: () => createController.pickEndDate(context),
                      ),
                      const SizedBox(height: PSizes.spaceBtwInputFields),

                      Obx(
                            () => CheckboxListTile(
                          value: createController.status.value,
                          onChanged: (value) => createController.status.value = value ?? false,
                          title: const Text('Kích hoạt mã giảm giá'),
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: PSizes.spaceBtwInputFields * 2),

            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => createController.createCoupon(),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Tạo mã giảm giá'),
              ),
            ),
            const SizedBox(height: PSizes.spaceBtwInputFields),
          ],
        ),
      ),
    );
  }
}
