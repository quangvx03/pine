import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pine_admin_panel/common/widgets/images/p_rounded_image.dart';
import 'package:pine_admin_panel/features/shop/controllers/product/product_images_controller.dart';
import 'package:pine_admin_panel/utils/constants/colors.dart';
import 'package:pine_admin_panel/utils/constants/enums.dart';
import 'package:pine_admin_panel/utils/constants/image_strings.dart';

import '../../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../../utils/constants/sizes.dart';
import '../../../../models/product_model.dart';


class ProductThumbnailImage extends StatelessWidget {
  const ProductThumbnailImage({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final ProductImagesController controller = Get.put(ProductImagesController());

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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                          child: Obx(
                                  () => PRoundedImage(
                                      width: 220,
                                      height: 220,
                                      image: controller.selectedThumbnailImageUrl.value ?? PImages.defaultSingleImageIcon,
                                      imageType: controller.selectedThumbnailImageUrl.value == null ? ImageType.asset : ImageType.network)
                          ),
                      )
                    ],
                  ),

                  // Add Thumbnail Button
                  SizedBox(
                      width: 200,
                      child: OutlinedButton(
                          onPressed: () => controller.selectThumbnailImage(),
                          child: const Text("Thêm ảnh đại diện"))),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
