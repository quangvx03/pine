import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pine_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:pine_admin_panel/features/shop/controllers/coupon/coupon_controller.dart';
import 'package:pine_admin_panel/utils/constants/sizes.dart';
import 'package:pine_admin_panel/utils/validators/validation.dart';

import '../../../../../../../common/widgets/shimmers/shimmer.dart';
import '../../../../controllers/coupon/edit_coupon_controller.dart';
import '../../../../models/coupon_model.dart';


class EditCouponForm extends StatelessWidget {
  const EditCouponForm({super.key, required this.coupon});

  final CouponModel coupon;

  @override
  Widget build(BuildContext context) {
    final editController = Get.put(EditCouponController());
    Future.microtask(() => editController.init(coupon));
    final couponController = Get.put(CouponController());
    
    return PRoundedContainer(
      width: 800,
      padding: const EdgeInsets.all(PSizes.defaultSpace),
      child: Form(
        key: editController.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Heading
            const SizedBox(height: PSizes.sm),
            Text('Cập nhật mã giảm giá', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: PSizes.spaceBtwSections),
            Row(
              children: [
                // First column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Coupon Code Text Field
                      TextFormField(
                        controller: editController.couponCode,
                        validator: (value) => PValidator.validateEmptyText('Mã giảm giá', value),
                        decoration: const InputDecoration(
                          labelText: 'Mã giảm giá',
                          prefixIcon: Icon(Iconsax.ticket),
                          contentPadding: EdgeInsets.symmetric(vertical: 15),
                        ),
                      ),
                      const SizedBox(height: PSizes.spaceBtwInputFields),

                      // Discount Type Dropdown
                      Obx(
                            () => couponController.isLoading.value
                            ? const PShimmerEffect(width: double.infinity, height: 55)
                            : DropdownButtonFormField<String>(
                          value: editController.type.value.isEmpty ? null : editController.type.value,
                          onChanged: (value) => editController.type.value = value ?? '',
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

                      // Discount Amount Text Field
                      TextFormField(
                        controller: editController.discountAmount,
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
                        controller: editController.description,
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

                // Spacer between columns
                const SizedBox(width: PSizes.spaceBtwSections),

                // Second column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Minimum Purchase Amount Text Field
                      TextFormField(
                        controller: editController.minimumPurchaseAmount,
                        validator: (value) => PValidator.validateEmptyText('Mức mua tối thiểu', value),
                        decoration: const InputDecoration(
                          labelText: 'Mức mua tối thiểu',
                          prefixIcon: Icon(Iconsax.shopping_cart),
                          contentPadding: EdgeInsets.symmetric(vertical: 15),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: PSizes.spaceBtwInputFields),

                      // End Date Picker
                      TextFormField(
                        controller: editController.endDate,
                        validator: (value) => PValidator.validateEmptyText('Ngày hết hạn', value),
                        decoration: const InputDecoration(
                          labelText: 'Ngày hết hạn',
                          prefixIcon: Icon(Iconsax.calendar),
                          contentPadding: EdgeInsets.symmetric(vertical: 15),
                        ),
                        readOnly: true,
                        onTap: () => editController.pickEndDate(context),
                      ),
                      const SizedBox(height: PSizes.spaceBtwInputFields),

                      // Status Checkbox
                      Obx(
                            () => CheckboxListTile(
                          value: editController.status.value,
                          onChanged: (value) => editController.status.value = value ?? false,
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
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => editController.updateCoupon(coupon),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Cập nhật mã giảm giá'),
              ),
            ),
            const SizedBox(height: PSizes.spaceBtwInputFields),
          ],
        ),
      ),
    );
  }
}
