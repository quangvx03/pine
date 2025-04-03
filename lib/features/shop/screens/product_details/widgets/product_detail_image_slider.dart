import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pine/features/shop/controllers/product/images_controller.dart';
import 'package:pine/features/shop/models/product_model.dart';
import 'package:pine/utils/helpers/helper_functions.dart';

import '../../../../../common/widgets/images/rounded_image.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';

class PProductImageSlider extends StatefulWidget {
  const PProductImageSlider({
    super.key,
    required this.product,
  });

  final ProductModel product;

  @override
  State<PProductImageSlider> createState() => _PProductImageSliderState();
}

class _PProductImageSliderState extends State<PProductImageSlider> {
  // Controller initialization moved outside build method
  late final ImagesController controller;
  late final List<String> images;

  @override
  void initState() {
    super.initState();
    // Create controller with unique tag based on product ID
    controller = Get.put(ImagesController(), tag: widget.product.id);
    images = controller.getAllProductImages(widget.product);
    // Set initial selected image
    controller.selectedProductImage.value = images.isNotEmpty ? images[0] : '';
  }

  @override
  void dispose() {
    // Properly dispose of the controller when widget is removed
    Get.delete<ImagesController>(tag: widget.product.id);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dark = PHelperFunctions.isDarkMode(context);

    return Container(
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
        ],
      ),
    );
  }
}
