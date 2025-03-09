import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pine/common/widgets/appbar/appbar.dart';
import 'package:pine/common/widgets/texts/section_heading.dart';
import 'package:pine/features/personalization/controllers/address_controller.dart';
import 'package:pine/utils/constants/sizes.dart';

class AddNewAddressScreen extends StatelessWidget {
  const AddNewAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = AddressController.instance;

    return Scaffold(
      appBar:
      const PAppBar(showBackArrow: true, title: Text('Thêm địa chỉ mới')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(PSizes.defaultSpace),
          child: Form(
            key: controller.addressFormKey,
            child: Column(
              children: [
                PSectionHeading(
                  title: 'Liên hệ',
                  showActionButton: false,
                ),
                const SizedBox(height: PSizes.spaceBtwInputFields),

                // Tên - có validation
                TextFormField(
                    controller: controller.name,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập tên';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Iconsax.user),
                        labelText: 'Tên'
                    )
                ),
                const SizedBox(height: PSizes.spaceBtwInputFields),

                TextFormField(
                  controller: controller.phoneNumber,
                  keyboardType: TextInputType.phone,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập số điện thoại';
                    }

                    // Kiểm tra định dạng số điện thoại VN
                    final phoneRegExp = RegExp(r'^(0)(\d{9})$');
                    if (!phoneRegExp.hasMatch(value)) {
                      return 'Số điện thoại không hợp lệ (10 số, bắt đầu bằng 0)';
                    }

                    return null;
                  },
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Iconsax.mobile),
                    labelText: 'Số điện thoại',
                    hintText: 'VD: 0901234567',
                    hintStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[400],
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(height: PSizes.spaceBtwInputFields),

                PSectionHeading(
                  title: 'Địa chỉ',
                  showActionButton: false,
                ),
                const SizedBox(height: PSizes.spaceBtwInputFields),

                // Đường/số nhà - có validation
                TextFormField(
                    controller: controller.street,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập tên đường, số nhà';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Iconsax.map),
                        labelText: 'Tên đường, số nhà'
                    )
                ),
                const SizedBox(height: PSizes.spaceBtwInputFields),

                TextFormField(
                    controller: controller.ward,
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Iconsax.house_2),
                        labelText: 'Phường/Xã'
                    )
                ),
                const SizedBox(height: PSizes.spaceBtwInputFields),

                TextFormField(
                    controller: controller.city,
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Iconsax.building),
                        labelText: 'Thành phố'
                    )
                ),
                const SizedBox(height: PSizes.spaceBtwInputFields),

                TextFormField(
                    controller: controller.province,
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Iconsax.activity),
                        labelText: 'Tỉnh'
                    )
                ),
                const SizedBox(height: PSizes.spaceBtwItems),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () {
                        if (controller.addressFormKey.currentState!.validate()) {
                          controller.addNewAddresses();
                        }
                      },
                      child: const Text('Lưu')
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}