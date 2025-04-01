import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pine/common/widgets/appbar/appbar.dart';
import 'package:pine/utils/constants/sizes.dart';
import 'package:pine/utils/validators/validation.dart';

import '../../../controllers/profile_edit_controller.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileEditController());
    return Scaffold(
      appBar: PAppBar(
        showBackArrow: true,
        title: const Text('Chỉnh sửa thông tin cá nhân'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(PSizes.defaultSpace),
          child: Form(
            key: controller.profileFormKey,
            child: Column(
              children: [
                const SizedBox(height: PSizes.spaceBtwItems),
                // Họ và Tên
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: controller.firstName,
                        validator: (value) =>
                            PValidator.validateEmptyText('Tên', value),
                        decoration: const InputDecoration(
                          labelText: 'Tên',
                          prefixIcon: Icon(Iconsax.user),
                        ),
                      ),
                    ),
                    const SizedBox(width: PSizes.spaceBtwItems),
                    Expanded(
                      child: TextFormField(
                        controller: controller.lastName,
                        validator: (value) =>
                            PValidator.validateEmptyText('Họ', value),
                        decoration: const InputDecoration(
                          labelText: 'Họ',
                          prefixIcon: Icon(Iconsax.user),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: PSizes.spaceBtwItems),

                // Email (hiển thị không cho phép chỉnh sửa)
                TextFormField(
                  controller: controller.email,
                  enabled: false, // Email không thể chỉnh sửa
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Iconsax.direct),
                    hintText: 'Email không thể thay đổi',
                  ),
                ),
                const SizedBox(height: PSizes.spaceBtwItems),

                // Số điện thoại
                TextFormField(
                  controller: controller.phoneNumber,
                  validator: (value) => PValidator.validatePhoneNumber(value),
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Số điện thoại',
                    prefixIcon: Icon(Iconsax.call),
                  ),
                ),
                const SizedBox(height: PSizes.spaceBtwItems),

                // Giới tính - Dropdown
                DropdownButtonFormField<String>(
                  value: controller.gender.value,
                  decoration: const InputDecoration(
                    labelText: 'Giới tính',
                    prefixIcon: Icon(Iconsax.user),
                  ),
                  items: ['Nam', 'Nữ', 'Khác']
                      .map((gender) => DropdownMenuItem(
                            value: gender,
                            child: Text(gender),
                          ))
                      .toList(),
                  onChanged: (value) {
                    controller.gender.value = value!;
                  },
                ),
                const SizedBox(height: PSizes.spaceBtwItems),

                // Ngày sinh - Date Picker
                InkWell(
                  onTap: () => controller.selectDate(context),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Ngày sinh',
                      prefixIcon: Icon(Iconsax.calendar),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Obx(() => Text(controller.dateOfBirth.value)),
                        const Icon(Icons.arrow_drop_down),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: PSizes.spaceBtwSections),

                // Nút Lưu
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => controller.updateUserProfile(),
                    child: const Text('Lưu thông tin'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
