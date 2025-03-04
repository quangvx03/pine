import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pine/features/shop/controllers/category_controller.dart';
import 'package:pine/features/shop/screens/sub_category/sub_categories.dart';
import 'package:pine/utils/constants/colors.dart';
import '../../../../../common/widgets/image_text_widgets/vertical_image_text.dart';
import '../../../../../common/widgets/shimmers/category_shimmer.dart';
import '../../../../../utils/constants/sizes.dart';

class PHomeCategories extends StatelessWidget {
  const PHomeCategories({super.key});

  @override
  Widget build(BuildContext context) {
    final categoryController = Get.put(CategoryController());

    return Obx(() {
      if (categoryController.isLoading.value) return const PCategoryShimmer();

      if (categoryController.featuredCategories.isEmpty) {
        return Center(
          child: Text(
            'Không có dữ liệu!',
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .apply(color: Colors.white),
          ),
        );
      }

      return GridView.builder(
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: categoryController.featuredCategories.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: PSizes.spaceBtwItems,
          crossAxisSpacing: PSizes.spaceBtwItems / 2,
          childAspectRatio: 0.78,
        ),
        itemBuilder: (_, index) {
          final category = categoryController.featuredCategories[index];
          return PVerticalImageText(
            backgroundColor: PColors.primary.withValues(alpha: 0.125),
            image: category.image,
            title: category.name,
            onTap: () => Get.to(() => const SubCategoriesScreen()),
          );
        },
      );
    });
  }
}