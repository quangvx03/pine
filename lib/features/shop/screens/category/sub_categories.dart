import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pine/common/widgets/appbar/appbar.dart';
import 'package:pine/common/widgets/images/rounded_image.dart';
import 'package:pine/common/widgets/products/product_cards/product_card_horizontal.dart';
import 'package:pine/common/widgets/shimmers/horizontal_product_shimmer.dart';
import 'package:pine/common/widgets/texts/section_heading.dart';
import 'package:pine/features/shop/controllers/brand_controller.dart';
import 'package:pine/features/shop/controllers/category_controller.dart';
import 'package:pine/features/shop/models/brand_model.dart';
import 'package:pine/features/shop/models/category_model.dart';
import 'package:pine/features/shop/screens/all_product/all_products.dart';
import 'package:pine/features/shop/screens/brand/brand_products.dart';
import 'package:pine/utils/constants/sizes.dart';
import 'package:pine/utils/helpers/cloud_helper_functions.dart';

class SubCategoriesScreen extends StatelessWidget {
  const SubCategoriesScreen({super.key, required this.category});

  final CategoryModel category;

  @override
  Widget build(BuildContext context) {
    final categoryController = CategoryController.instance;
    final brandController =
        BrandController.getInstance("brands_${category.id}");

    return Scaffold(
      appBar: PAppBar(title: Text(category.name), showBackArrow: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(PSizes.defaultSpace),
          child: Column(
            children: [
              // Hình ảnh danh mục
              PRoundedImage(
                  width: double.infinity,
                  height: 100,
                  imageUrl: category.image,
                  fit: BoxFit.contain,
                  applyImageRadius: true,
                  isNetworkImage: true),
              const SizedBox(height: PSizes.spaceBtwSections),

              // Phần hiển thị thương hiệu thuộc danh mục
              _buildCategoryBrands(brandController),

              // Danh mục phụ
              FutureBuilder(
                future: categoryController.getSubCategories(category.id),
                builder: (context, snapshot) {
                  /// Handle loader, no record or error message
                  const loader = PHorizontalProductShimmer();
                  final widget = PCloudHelperFunctions.checkMultiRecordState(
                      snapshot: snapshot, loader: loader);
                  if (widget != null) return widget;

                  /// Record found
                  final subCategories = snapshot.data!;

                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: subCategories.length,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (_, index) {
                      final subCategory = subCategories[index];

                      return FutureBuilder(
                          future: categoryController.getCategoryProducts(
                              categoryId: subCategory.id),
                          builder: (context, snapshot) {
                            /// Handle loader, no record or error message
                            final widget =
                                PCloudHelperFunctions.checkMultiRecordState(
                                    snapshot: snapshot, loader: loader);
                            if (widget != null) return widget;

                            /// Record found
                            final products = snapshot.data!;

                            return Column(
                              children: [
                                /// Heading
                                PSectionHeading(
                                  title: subCategory.name,
                                  onPressed: () =>
                                      Get.to(() => AllProductsScreen(
                                            title: subCategory.name,
                                            showBackArrow: true,
                                            categoryId: subCategory.id,
                                          )),
                                ),
                                const SizedBox(
                                    height: PSizes.spaceBtwItems / 2),

                                SizedBox(
                                  height: 115,
                                  child: ListView.separated(
                                      itemCount: products.length,
                                      scrollDirection: Axis.horizontal,
                                      separatorBuilder: (context, index) =>
                                          const SizedBox(
                                              width: PSizes.spaceBtwItems),
                                      itemBuilder: (context, index) =>
                                          PProductCardHorizontal(
                                              product: products[index])),
                                ),

                                const SizedBox(height: PSizes.spaceBtwItems),
                              ],
                            );
                          });
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget hiển thị thương hiệu thuộc danh mục
  Widget _buildCategoryBrands(BrandController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PSectionHeading(
          title: 'Thương hiệu thuộc ${category.name}',
          showActionButton: false,
        ),
        const SizedBox(height: PSizes.spaceBtwItems),
        FutureBuilder<List<BrandModel>>(
          future: controller.getAllBrandsForCategoryWithSales(category.id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Column(
                children: [
                  const _BrandListShimmer(),
                  const SizedBox(height: PSizes.spaceBtwSections),
                ],
              );
            }

            if (snapshot.hasError ||
                !snapshot.hasData ||
                snapshot.data!.isEmpty) {
              return const SizedBox();
            }

            final brands = snapshot.data!;

            return SizedBox(
              height: 100,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: brands.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(width: PSizes.spaceBtwItems),
                itemBuilder: (context, index) {
                  final brand = brands[index];
                  return _BrandItem(brand: brand);
                },
              ),
            );
          },
        ),
      ],
    );
  }
}

// Widget item hiển thị thương hiệu
class _BrandItem extends StatelessWidget {
  final BrandModel brand;

  const _BrandItem({required this.brand});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.to(() => BrandProducts(brand: brand)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Logo thương hiệu
          Container(
            height: 60,
            width: 60,
            padding: const EdgeInsets.all(PSizes.sm),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(100),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: brand.image.isNotEmpty
                ? Image.network(
                    brand.image,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) =>
                        const Icon(Icons.business, size: 30),
                  )
                : const Icon(Icons.business, size: 30),
          ),
          const SizedBox(height: PSizes.sm / 2),

          // Tên thương hiệu
          SizedBox(
            width: 70,
            child: Text(
              brand.name,
              style: Theme.of(context).textTheme.labelLarge,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

// Widget shimmer hiển thị khi đang tải
class _BrandListShimmer extends StatelessWidget {
  const _BrandListShimmer();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 6,
        separatorBuilder: (_, __) =>
            const SizedBox(width: PSizes.spaceBtwItems),
        itemBuilder: (context, _) {
          return Column(
            children: [
              Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              const SizedBox(height: PSizes.sm / 2),
              Container(
                height: 12,
                width: 60,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 4),
              Container(
                height: 12,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
