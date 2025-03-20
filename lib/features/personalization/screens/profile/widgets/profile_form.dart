import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pine_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:pine_admin_panel/utils/constants/sizes.dart';
import 'package:pine_admin_panel/utils/validators/validation.dart';

class ProfileForm extends StatelessWidget {
  const ProfileForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PRoundedContainer(
          padding: const EdgeInsets.symmetric(
              vertical: PSizes.lg, horizontal: PSizes.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Thông tin tài khoản',
                  style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: PSizes.spaceBtwSections),

              // Form
              Form(
                child: Column(
                  children: [
                    // First and Last Name
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            decoration: const InputDecoration(
                              hintText: 'Họ',
                              label: Text('Họ'),
                              prefixIcon: Icon(Iconsax.user),
                            ),
                            validator: (value) =>
                                PValidator.validateEmptyText('Họ', value),
                          ),
                        ),
                        const SizedBox(width: PSizes.spaceBtwInputFields),
                        Expanded(
                          child: TextFormField(
                            decoration: const InputDecoration(
                              hintText: 'Tên',
                              label: Text('Tên'),
                              prefixIcon: Icon(Iconsax.user),
                            ),
                            validator: (value) =>
                                PValidator.validateEmptyText('Tên', value),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: PSizes.spaceBtwInputFields),

                    // Email and Phone
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            decoration: const InputDecoration(
                              hintText: 'Email',
                              label: Text('Email'),
                              prefixIcon: Icon(Iconsax.forward),
                              enabled: false,
                            ),
                          ),
                        ),
                        const SizedBox(width: PSizes.spaceBtwItems),
                        Expanded(
                          child: TextFormField(
                            decoration: const InputDecoration(
                              hintText: 'Số điện thoại',
                              label: Text('Số điện thoại'),
                              prefixIcon: Icon(Iconsax.mobile),
                            ),
                            validator: (value) => PValidator.validateEmptyText(
                                'Số điện thoại', value),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: PSizes.spaceBtwSections),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('Cập nhật tài khoản'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
