import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/validators/validation.dart';

class SettingsForm extends StatelessWidget {
  const SettingsForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // App Settings
        PRoundedContainer(
          padding: const EdgeInsets.symmetric(
              vertical: PSizes.lg, horizontal: PSizes.md),
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cài đặt ứng dụng',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: PSizes.spaceBtwSections),

                // App Name
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Tên ứng dụng',
                    label: Text('Tên ứng dụng'),
                    prefixIcon: Icon(Iconsax.user),
                  ),
                ),
                const SizedBox(height: PSizes.spaceBtwInputFields),

                // Shipping Fee Input
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Phí vận chuyển',
                    label: Text('Phí vận chuyển'),
                    prefixIcon: Icon(Iconsax.ship),
                  ),
                ),
                const SizedBox(height: PSizes.spaceBtwSections),


                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text('Cập nhật ứng dụng'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
