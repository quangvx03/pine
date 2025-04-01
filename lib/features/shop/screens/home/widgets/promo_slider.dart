import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pine/common/widgets/shimmers/shimmer.dart';
import 'package:pine/features/shop/controllers/banner_controller.dart';
import 'package:pine/navigation_menu.dart';

import '../../../../../common/widgets/custom_shapes/containers/circular_container.dart';
import '../../../../../common/widgets/images/rounded_image.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';

class PPromoSlider extends StatelessWidget {
  const PPromoSlider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BannerController());
    return Obx(() {
      if (controller.isLoading.value) {
        return const PShimmerEffect(width: double.infinity, height: 100);
      }

      if (controller.banners.isEmpty) {
        return const Center(child: Text('Không tìm thấy dữ liệu'));
      } else {
        return Column(
          children: [
            CarouselSlider(
                options: CarouselOptions(
                  viewportFraction: 1.05,
                  onPageChanged: (index, _) =>
                      controller.updatePageIndicator(index),
                  aspectRatio: 3 / 1,
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 5),
                  autoPlayAnimationDuration: Duration(milliseconds: 1200),
                  autoPlayCurve: Curves.easeInOut,
                ),
                items: controller.banners
                    .map((banner) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: AspectRatio(
                            aspectRatio: 3 / 1,
                            child: PRoundedImage(
                              imageUrl: banner.imageUrl,
                              isNetworkImage: true,
                              // Sửa lỗi chuyển hướng bằng cách thay thế toNamed với cách mới
                              onPressed: () {
                                if (banner.targetScreen == '/home') {
                                  final navController =
                                      Get.find<NavigationController>();
                                  navController.navigateToTab(0);
                                } else if (banner.targetScreen == '/store') {
                                  final navController =
                                      Get.find<NavigationController>();
                                  navController.navigateToTab(1);
                                } else if (banner.targetScreen == '/search') {
                                  final navController =
                                      Get.find<NavigationController>();
                                  navController.navigateToTab(2);
                                } else if (banner.targetScreen == '/settings' ||
                                    banner.targetScreen == '/account') {
                                  final navController =
                                      Get.find<NavigationController>();
                                  navController.navigateToTab(3);
                                } else {
                                  Get.toNamed(banner.targetScreen);
                                }
                              },
                              fit: BoxFit.cover,
                            ),
                          ),
                        ))
                    .toList()),
            const SizedBox(height: PSizes.spaceBtwItems),
            // Tách Obx ra thành một widget riêng biệt
            _buildPageIndicators(controller),
          ],
        );
      }
    });
  }

  // Widget riêng cho các chỉ báo trang
  Widget _buildPageIndicators(BannerController controller) {
    return Center(
      child: Obx(
        () => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (int i = 0; i < controller.banners.length; i++)
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
    );
  }
}
