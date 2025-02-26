import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pine/common/widgets/appbar/appbar.dart';
import 'package:pine/common/widgets/texts/section_heading.dart';
import 'package:pine/utils/constants/sizes.dart';

class AddNewAddressScreen extends StatelessWidget {
  const AddNewAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PAppBar(showBackArrow: true, title: Text('Thêm địa chỉ mới')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(PSizes.defaultSpace),
          child: Form(
            child: Column(
              children: [
                PSectionHeading(
                  title: 'Liên hệ',
                  showActionButton: false,
                ),
                const SizedBox(height: PSizes.spaceBtwInputFields),
                TextFormField(
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Iconsax.user), labelText: 'Tên')),
                const SizedBox(height: PSizes.spaceBtwInputFields),
                TextFormField(
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Iconsax.mobile),
                        labelText: 'Số điện thoại')),
                const SizedBox(height: PSizes.spaceBtwInputFields),
                PSectionHeading(
                  title: 'Địa chỉ',
                  showActionButton: false,
                ),
                const SizedBox(height: PSizes.spaceBtwInputFields),
                TextFormField(
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Iconsax.building_31),
                        labelText: 'Đường')),
                const SizedBox(height: PSizes.spaceBtwInputFields),
                TextFormField(
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Iconsax.house_2),
                        labelText: 'Số nhà')),
                const SizedBox(height: PSizes.spaceBtwInputFields),
                TextFormField(
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Iconsax.building),
                        labelText: 'Thành phố')),
                const SizedBox(height: PSizes.spaceBtwInputFields),
                TextFormField(
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Iconsax.activity), labelText: 'Tỉnh')),
                // Row(
                //   children: [
                //     Expanded(
                //         child: TextFormField(
                //             decoration: const InputDecoration(
                //                 prefixIcon: Icon(Iconsax.building),
                //                 labelText: 'Thành phố'))),
                //     const SizedBox(width: PSizes.spaceBtwInputFields),
                //     Expanded(
                //         child: TextFormField(
                //             decoration: const InputDecoration(
                //                 prefixIcon: Icon(Iconsax.activity),
                //                 labelText: 'Tỉnh'))),
                //   ],
                // ),
                const SizedBox(height: PSizes.spaceBtwInputFields),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(onPressed: () {}, child: Text('Lưu')),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
