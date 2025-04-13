import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pine_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:pine_admin_panel/common/widgets/shimmers/shimmer.dart';
import 'package:pine_admin_panel/utils/constants/sizes.dart';
import 'package:pine_admin_panel/utils/validators/validation.dart';

import '../../../../../../../utils/constants/enums.dart';
import '../../../../../../../utils/constants/text_strings.dart';
import '../../../../controllers/customer/create_staff_controller.dart';
import '../../../../controllers/customer/customer_controller.dart';


class CreateStaffForm extends StatelessWidget {
  const CreateStaffForm({super.key});

  @override
  Widget build(BuildContext context) {
    final createController = Get.put(CreateStaffController());
    final staffController = Get.put(CustomerController());

    return PRoundedContainer(
      width: 800, // Adjust width for two-column layout
      padding: const EdgeInsets.all(PSizes.defaultSpace),
      child: Form(
        key: createController.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Heading
            const SizedBox(height: PSizes.sm),
            Text('Thông tin nhân viên', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: PSizes.spaceBtwSections),

            // Create a 2-column layout
            Row(
              children: [
                // First column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // First Name Text Field
                      TextFormField(
                        controller: createController.firstNameController,
                        validator: (value) => PValidator.validateEmptyText('Tên', value),
                        decoration: const InputDecoration(
                          labelText: 'Tên',
                          prefixIcon: Icon(Iconsax.user),
                          contentPadding: EdgeInsets.symmetric(vertical: 15),
                        ),
                      ),
                      const SizedBox(height: PSizes.spaceBtwInputFields),

                      // Last Name Text Field
                      TextFormField(
                        controller: createController.lastNameController,
                        validator: (value) => PValidator.validateEmptyText('Họ', value),
                        decoration: InputDecoration(
                          labelText: 'Họ',
                          prefixIcon: Icon(Iconsax.user),
                          contentPadding: EdgeInsets.symmetric(vertical: 15),
                        ),
                      ),
                      const SizedBox(height: PSizes.spaceBtwInputFields),

                      // Email Text Field
                      TextFormField(
                        controller: createController.emailController,
                        validator: (value) => PValidator.validateEmptyText('Email', value),
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Iconsax.sms),
                          contentPadding: EdgeInsets.symmetric(vertical: 15),
                        ),
                      ),
                      const SizedBox(height: PSizes.spaceBtwInputFields),
                      // Phone Number Text Field
                      TextFormField(
                        controller: createController.phoneNumberController,
                        validator: (value) => PValidator.validateEmptyText('Số điện thoại', value),
                        decoration: const InputDecoration(
                            labelText: PTexts.phoneNo, prefixIcon: Icon(Iconsax.call)),
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: PSizes.spaceBtwInputFields),

                      /// Password
                      Obx(
                            () => TextFormField(
                            validator: (value) => PValidator.validatePassword(value),
                            controller: createController.password,
                            obscureText: createController.hidePassword.value,
                            decoration: InputDecoration(
                                labelText: PTexts.password,
                                prefixIcon: const Icon(Iconsax.password_check),
                                suffixIcon: IconButton(
                                  onPressed: () => createController.hidePassword.value =
                                  !createController.hidePassword.value,
                                  icon: Icon(createController.hidePassword.value
                                      ? Iconsax.eye_slash
                                      : Iconsax.eye),
                                ))),
                      ),
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
                      // Address: Street Text Field
                      TextFormField(
                        controller: createController.streetController,
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
                        controller: createController.wardController,
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
                        controller: createController.cityController,
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
                        controller: createController.provinceController,
                        validator: (value) => PValidator.validateEmptyText('Tỉnh', value),
                        decoration: const InputDecoration(
                          labelText: 'Tỉnh',
                          prefixIcon: Icon(Iconsax.location),
                          contentPadding: EdgeInsets.symmetric(vertical: 15),
                        ),
                      ),
                      const SizedBox(height: PSizes.spaceBtwInputFields),
                      // Role Dropdown
                      Obx(
                            () => staffController.isLoading.value
                            ? const PShimmerEffect(width: double.infinity, height: 55)
                            : DropdownButtonFormField<String>(
                          value: createController.roleController.value == AppRole.admin
                              ? 'Admin'
                              : 'Staff', // Staff = AppRole.staff
                          onChanged: (value) {
                            if (value == 'Admin') {
                              createController.roleController.value = AppRole.admin;
                            } else {
                              createController.roleController.value = AppRole.staff;
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

            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => createController.createStaff(),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Thêm nhân viên'),
              ),
            ),
            const SizedBox(height: PSizes.spaceBtwInputFields),
          ],
        ),
      ),
    );
  }
}
