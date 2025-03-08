import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pine/features/shop/controllers/product/images_controller.dart';
import 'package:pine/features/shop/models/product_model.dart';
import 'package:pine/utils/helpers/helper_functions.dart';

import '../../../../../common/widgets/appbar/appbar.dart';
import '../../../../../common/widgets/custom_shapes/curved_edges/curved_edges_widget.dart';
import '../../../../../common/widgets/icons/circular_icon.dart';
import '../../../../../common/widgets/images/rounded_image.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';

class PProductImageSlider extends StatelessWidget {
  const PProductImageSlider({
    super.key,
    required this.product,
  });

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final dark = PHelperFunctions.isDarkMode(context);

    final controller = Get.put(ImagesController());
    final images = controller.getAllProductImages(product);

    return PCurvedEdgeWidget(
        child: Container(
      color: dark ? PColors.darkerGrey : PColors.light,
      child: Stack(
        children: [
          /// Main Large Image
          SizedBox(
              height: 400,
              child: Padding(
                padding: EdgeInsets.all(PSizes.productImageRadius * 2),
                child: Center(child: Obx(() {
                  final image = controller.selectedProductImage.value;
                  return GestureDetector(
                    onTap: () => controller.showEnlargedImage(image),
                    child: CachedNetworkImage(
                      imageUrl: image,
                      progressIndicatorBuilder: (_, __, downloadProgress) =>
                          CircularProgressIndicator(
                              value: downloadProgress.progress,
                              color: PColors.primary),
                    ),
                  );
                })),
              )),

          /// Image Slider
          Positioned(
            right: 0,
            bottom: 30,
            left: PSizes.defaultSpace,
            child: SizedBox(
              height: 64,
              child: ListView.separated(
                  itemCount: images.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  physics: const AlwaysScrollableScrollPhysics(),
                  separatorBuilder: (_, __) =>
                      const SizedBox(width: PSizes.spaceBtwItems),
                  itemBuilder: (_, index) => Obx(() {
                        final imageSelected =
                            controller.selectedProductImage.value ==
                                images[index];
                        return PRoundedImage(
                          width: 64,
                          isNetworkImage: true,
                          imageUrl: images[index],
                          padding: const EdgeInsets.all(PSizes.sm),
                          backgroundColor: dark ? PColors.dark : PColors.white,
                          onPressed: () => controller
                              .selectedProductImage.value = images[index],
                          border: Border.all(
                              color: imageSelected
                                  ? PColors.primary
                                  : Colors.transparent),
                        );
                      })),
            ),
          ),

          const PAppBar(
            showBackArrow: true,
            actions: [
              PCircularIcon(
                icon: Iconsax.heart5,
                color: PColors.favorite,
              )
            ],
          )
        ],
      ),
    ));
  }
}
