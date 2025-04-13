import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pine_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:pine_admin_panel/common/widgets/shimmers/shimmer.dart';
import 'package:pine_admin_panel/utils/constants/sizes.dart';
import 'package:pine_admin_panel/utils/validators/validation.dart';

import '../../../../../../../utils/constants/enums.dart';
import '../../../../../../../utils/constants/text_strings.dart';
import '../../../../../personalization/models/user_model.dart';
import '../../../../controllers/customer/edit_staff_controller.dart';

class EditStaffForm extends StatelessWidget {
  const EditStaffForm({super.key, required this.staff});

  final UserModel staff;

  @override
  Widget build(BuildContext context) {
    final editController = Get.put(EditStaffController());

    // Khởi tạo dữ liệu nhân viên vào controller
    Future.microtask(() => editController.init(staff));

    return PRoundedContainer(
      width: 800, // Cấu trúc 2 cột như trong CreateStaffForm
      padding: const EdgeInsets.all(PSizes.defaultSpace),
      child: Form(
        key: editController.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Heading
            const SizedBox(height: PSizes.sm),
            Text('Cập nhật thông tin nhân viên', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: PSizes.spaceBtwSections),

            // Tạo layout 2 cột
            Row(
              children: [
                // Cột 1
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Tên nhân viên
                      TextFormField(
                        controller: editController.firstNameController,
                        validator: (value) => PValidator.validateEmptyText('Tên', value),
                        decoration: const InputDecoration(
                          labelText: 'Tên',
                          prefixIcon: Icon(Iconsax.user),
                          contentPadding: EdgeInsets.symmetric(vertical: 15),
                        ),
                      ),
                      const SizedBox(height: PSizes.spaceBtwInputFields),

                      // Họ nhân viên
                      TextFormField(
                        controller: editController.lastNameController,
                        validator: (value) => PValidator.validateEmptyText('Họ', value),
                        decoration: const InputDecoration(
                          labelText: 'Họ',
                          prefixIcon: Icon(Iconsax.user),
                          contentPadding: EdgeInsets.symmetric(vertical: 15),
                        ),
                      ),
                      const SizedBox(height: PSizes.spaceBtwInputFields),

                      // Email nhân viên
                      TextFormField(
                        controller: editController.emailController,
                        validator: (value) => PValidator.validateEmptyText('Email', value),
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Iconsax.sms),
                          contentPadding: EdgeInsets.symmetric(vertical: 15),
                        ),
                      ),
                      const SizedBox(height: PSizes.spaceBtwInputFields),
                      // Số điện thoại
                      TextFormField(
                        controller: editController.phoneNumberController,
                        validator: (value) => PValidator.validateEmptyText('Số điện thoại', value),
                        decoration: const InputDecoration(
                            labelText: PTexts.phoneNo, prefixIcon: Icon(Iconsax.call)),
                        keyboardType: TextInputType.phone,
                      ),
                    ],
                  ),
                ),

                // Khoảng cách giữa các cột
                const SizedBox(width: PSizes.spaceBtwSections),

                // Cột 2
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Địa chỉ
                      TextFormField(
                        controller: editController.streetController,
                        validator: (value) => PValidator.validateEmptyText('Địa chỉ', value),
                        decoration: const InputDecoration(
                          labelText: 'Địa chỉ',
                          prefixIcon: Icon(Iconsax.location),
                          contentPadding: EdgeInsets.symmetric(vertical: 15),
                        ),
                      ),
                      const SizedBox(height: PSizes.spaceBtwInputFields),

                      // Ward
                      TextFormField(
                        controller: editController.wardController,
                        validator: (value) => PValidator.validateEmptyText('Phường/Xã', value),
                        decoration: const InputDecoration(
                          labelText: 'Phường/Xã',
                          prefixIcon: Icon(Iconsax.location),
                          contentPadding: EdgeInsets.symmetric(vertical: 15),
                        ),
                      ),
                      const SizedBox(height: PSizes.spaceBtwInputFields),

                      // City
                      TextFormField(
                        controller: editController.cityController,
                        validator: (value) => PValidator.validateEmptyText('Thành phố', value),
                        decoration: const InputDecoration(
                          labelText: 'Thành phố',
                          prefixIcon: Icon(Iconsax.location),
                          contentPadding: EdgeInsets.symmetric(vertical: 15),
                        ),
                      ),
                      const SizedBox(height: PSizes.spaceBtwInputFields),

                      // Province
                      TextFormField(
                        controller: editController.provinceController,
                        validator: (value) => PValidator.validateEmptyText('Tỉnh', value),
                        decoration: const InputDecoration(
                          labelText: 'Tỉnh',
                          prefixIcon: Icon(Iconsax.location),
                          contentPadding: EdgeInsets.symmetric(vertical: 15),
                        ),
                      ),
                      const SizedBox(height: PSizes.spaceBtwInputFields),

                      // Vai trò (Role)
                      Obx(
                            () => editController.loading.value
                            ? const PShimmerEffect(width: double.infinity, height: 55)
                            : DropdownButtonFormField<String>(
                          value: editController.role.value == AppRole.admin ? 'Admin' : 'Staff',
                          onChanged: (value) {
                            if (value == 'Admin') {
                              editController.role.value = AppRole.admin;
                            } else {
                              editController.role.value = AppRole.staff;
                            }
                          },
                          items: ['Admin', 'Staff']
                              .map((role) => DropdownMenuItem(value: role, child: Text(role)))
                              .toList(),
                          decoration: const InputDecoration(
                            labelText: 'Vai trò',
                            prefixIcon: Icon(Iconsax.category),
                            contentPadding: EdgeInsets.symmetric(vertical: 15),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: PSizes.spaceBtwInputFields * 2),

            // Nút Submit
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => editController.updateStaff(staff),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Cập nhật nhân viên'),
              ),
            ),
            const SizedBox(height: PSizes.spaceBtwInputFields),
          ],
        ),
      ),
    );
  }
}
