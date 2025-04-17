import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pine/common/widgets/appbar/appbar.dart';
import 'package:pine/common/widgets/shimmers/horizontal_product_shimmer.dart';
import 'package:pine/features/shop/controllers/category_controller.dart';
import 'package:pine/features/shop/models/category_model.dart';
import 'package:pine/features/shop/screens/all_product/all_products.dart';
import 'package:pine/features/shop/screens/category/sub_categories.dart';
import 'package:pine/utils/constants/colors.dart';
import 'package:pine/utils/constants/sizes.dart';
import 'package:pine/utils/helpers/cloud_helper_functions.dart';
import 'package:pine/utils/helpers/helper_functions.dart';
import 'package:pine/common/widgets/custom_shapes/containers/rounded_container.dart';

class AllCategoriesScreen extends StatelessWidget {
  const AllCategoriesScreen({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CategoryController());

    return Scaffold(
      appBar: PAppBar(title: Text(title), showBackArrow: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(PSizes.defaultSpace),
          child: FutureBuilder(
            future: controller.fetchAllCategories(),
            builder: (context, snapshot) {
              const loader = PHorizontalProductShimmer();
              final widget = PCloudHelperFunctions.checkMultiRecordState(
                  snapshot: snapshot, loader: loader);

              if (widget != null) return widget;

              final allCategories = snapshot.data!;

              // Phân chia danh mục cha và con
              final parentCategories = allCategories
                  .where((category) => category.parentId.isEmpty)
                  .toList();

              final subCategories = allCategories
                  .where((category) => category.parentId.isNotEmpty)
                  .toList();

              // Tạo map để lưu trữ thông tin danh mục cha
              final Map<String, CategoryModel> parentCategoryMap = {};
              for (var category in allCategories) {
                parentCategoryMap[category.id] = category;
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tiêu đề danh mục chính
                  Text(
                    'Danh mục chính',
                    style: Theme.of(context).textTheme.headlineSmall!.apply(
                          fontWeightDelta: 1,
                        ),
                  ),
                  const SizedBox(height: PSizes.spaceBtwItems),

                  // Danh mục cha
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: PSizes.spaceBtwItems,
                      mainAxisSpacing: PSizes.spaceBtwItems,
                      mainAxisExtent: 80,
                    ),
                    itemCount: parentCategories.length,
                    itemBuilder: (context, index) {
                      return PCategoryCard(
                        showBorder: true,
                        category: parentCategories[index],
                        onTap: () => Get.to(() => SubCategoriesScreen(
                            category: parentCategories[index])),
                      );
                    },
                  ),

                  const SizedBox(height: PSizes.spaceBtwSections),

                  Text(
                    'Danh mục phụ',
                    style: Theme.of(context).textTheme.headlineSmall!.apply(
                          fontWeightDelta: 1,
                        ),
                  ),
                  const SizedBox(height: PSizes.spaceBtwItems),

                  // Danh mục con
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: PSizes.spaceBtwItems,
                      mainAxisSpacing: PSizes.spaceBtwItems,
                      mainAxisExtent: 80,
                    ),
                    itemCount: subCategories.length,
                    itemBuilder: (context, index) {
                      final subCategory = subCategories[index];
                      final parentCategory =
                          parentCategoryMap[subCategory.parentId];

                      return PCategoryCard(
                        showBorder: true,
                        category: subCategory,
                        parentName: parentCategory?.name,
                        onTap: () => Get.to(() => AllProductsScreen(
                              title: subCategory.name,
                              showBackArrow: true,
                              categoryId: subCategory.id,
                            )),
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class PCategoryCard extends StatelessWidget {
  const PCategoryCard({
    super.key,
    required this.category,
    required this.showBorder,
    this.parentName,
    this.onTap,
  });

  final CategoryModel category;
  final bool showBorder;
  final String? parentName;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final dark = PHelperFunctions.isDarkMode(context);
    final hasParent = parentName != null;

    return GestureDetector(
      onTap: onTap,
      child: PRoundedContainer(
        showBorder: showBorder,
        backgroundColor: dark ? PColors.darkerGrey : Colors.transparent,
        padding: const EdgeInsets.all(PSizes.sm),
        child: Row(
          children: [
            // Phần hình ảnh
            Expanded(
              flex: 1,
              child: AspectRatio(
                aspectRatio: 0.75,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(PSizes.md),
                    image: DecorationImage(
                      image: NetworkImage(category.image),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(width: PSizes.sm),

            // Phần text
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Tên danh mục
                  Text(
                    category.name,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .apply(fontWeightDelta: 1),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  // Thêm thông tin danh mục cha nếu có
                  if (hasParent) ...[
                    const SizedBox(height: PSizes.xs / 2),
                    Row(
                      children: [
                        Icon(
                          Icons.keyboard_arrow_right,
                          size: 14,
                          color: dark
                              ? PColors.white.withValues(alpha: 0.7)
                              : PColors.darkGrey,
                        ),
                        const SizedBox(width: PSizes.xs / 2),
                        Expanded(
                          child: Text(
                            parentName!,
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium!
                                .copyWith(
                                  color: dark
                                      ? PColors.white.withValues(alpha: 0.7)
                                      : PColors.darkGrey,
                                ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
