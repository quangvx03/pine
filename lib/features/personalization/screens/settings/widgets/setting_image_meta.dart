import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pine_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:pine_admin_panel/common/widgets/images/image_uploader.dart';
import 'package:pine_admin_panel/utils/constants/enums.dart';
import 'package:pine_admin_panel/utils/constants/image_strings.dart';
import 'package:pine_admin_panel/utils/constants/sizes.dart';

class ImageAndMeta extends StatelessWidget {
  const ImageAndMeta({super.key});

  @override
  Widget build(BuildContext context) {
    return PRoundedContainer(
      padding: const EdgeInsets.symmetric(vertical: PSizes.lg, horizontal: PSizes.md),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              // User Image
               const PImageUploader(
                  right: 10,
                  bottom: 20,
                  left: null,
                  width: 200,
                  height: 200,
                  circular: true,
                  icon: Iconsax.camera,
                  imageType: ImageType.asset,
                  image: PImages.defaultImage,
                ),

              const SizedBox(height: PSizes.spaceBtwItems),
              Text('Pine', style: Theme.of(context).textTheme.headlineLarge),
              const SizedBox(height: PSizes.spaceBtwSections),
            ],
          ),
        ],
      ),
    );
  }
}
