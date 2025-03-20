import 'package:flutter/material.dart';
import 'package:pine_admin_panel/common/widgets/images/p_rounded_image.dart';
import 'package:pine_admin_panel/utils/constants/colors.dart';
import 'package:pine_admin_panel/utils/constants/enums.dart';
import 'package:pine_admin_panel/utils/constants/image_strings.dart';

import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../utils/constants/sizes.dart';

class ProductThumbnailImage extends StatelessWidget {
  const ProductThumbnailImage({super.key});

  @override
  Widget build(BuildContext context) {
    return PRoundedContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Thumbnail Text
          Text('Ảnh đại diện sản phẩm', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: PSizes.spaceBtwItems),

          // Container for Product Thumbnail
          PRoundedContainer(
            height: 300,
            backgroundColor: PColors.primaryBackground,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Thumbnail Image
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                          child: PRoundedImage(width: 220, height: 220, image: PImages.defaultSingleImageIcon, imageType: ImageType.asset),
                      )
                    ],
                  ),

                  // Add Thumbnail Button
                  SizedBox(width: 200, child: OutlinedButton(onPressed: () {}, child: const Text("Thêm ảnh đại diện"))),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
