import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pine/features/shop/controllers/home_controller.dart';

import '../../../../../common/widgets/custom_shapes/containers/circular_container.dart';
import '../../../../../common/widgets/images/rounded_image.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/image_strings.dart';
import '../../../../../utils/constants/sizes.dart';

class PPromoSlider extends StatelessWidget {
  const PPromoSlider({
    super.key,
    required this.banners,
  });

  final List<String> banners;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());
    return Column(
      children: [
        CarouselSlider(
            options: CarouselOptions(
              viewportFraction: 1,
              onPageChanged: (index, _) =>
                  controller.updatePageIndicator(index),
              aspectRatio: 3 / 1,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 5),
              autoPlayAnimationDuration: Duration(milliseconds: 1200),
              autoPlayCurve: Curves.easeInOut,
            ),
            items: banners
                .map((url) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: AspectRatio(
                          aspectRatio: 3 / 1,
                          child: PRoundedImage(
                            imageUrl: url,
                            fit: BoxFit.cover,
                          )),
                    ))
                .toList()),
        const SizedBox(height: PSizes.spaceBtwItems),
        Center(
          child: Obx(
            () => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (int i = 0; i < banners.length; i++)
                  PCircularContainer(
                    width: 15,
                    height: 4,
                    margin: const EdgeInsets.only(right: 5),
                    backgroundColor: controller.carouselCurrentIndex.value == i
                        ? PColors.primary
                        : PColors.grey,
                  ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
