import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pine_admin_panel/common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import 'package:pine_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:pine_admin_panel/features/shop/controllers/product/product_images_controller.dart';
import 'package:pine_admin_panel/utils/constants/enums.dart';
import 'package:pine_admin_panel/utils/constants/sizes.dart';
import 'package:pine_admin_panel/utils/device/device_utility.dart';

import '../../../../../../../routes/routes.dart';
import '../widgets/additional_images.dart';
import '../widgets/attributes_widget.dart';
import '../widgets/bottom_navigation_widget.dart';
import '../widgets/brand_widget.dart';
import '../widgets/categories_widget.dart';
import '../widgets/product_type_widget.dart';
import '../widgets/stock_pricing_widget.dart';
import '../widgets/thumbnail_widget.dart';
import '../widgets/title_description.dart';
import '../widgets/variations_widget.dart';
import '../widgets/visibility_widget.dart';

class CreateProductDesktopScreen extends StatelessWidget {
  const CreateProductDesktopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductImagesController());

    return Scaffold(
      bottomNavigationBar: const ProductBottomNavigationButtons(),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(PSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Breadcrumbs
              const PBreadcrumbsWithHeading(
                  returnToPreviousScreen: true,
                  heading: 'Thêm sản phẩm',
                  breadcrumbItems: [{ 'label': 'Danh sách sản phẩm', 'path': PRoutes.products }, 'Thêm sản phẩm']),
              const SizedBox(height: PSizes.spaceBtwSections),

              // Create Product
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: PDeviceUtils.isTabletScreen(context) ? 2 : 3,
                      child: Column(
                        crossAxisAlignment:  CrossAxisAlignment.start,
                        children: [
                          // Basic Information
                          const ProductTitleAndDescription(),
                          const SizedBox(height: PSizes.spaceBtwSections),

                          // Stock & Pricing
                          PRoundedContainer(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Heading
                                Text('Kho và Giá', style: Theme.of(context).textTheme.headlineSmall),
                                const SizedBox(height: PSizes.spaceBtwItems),

                                // Product Type
                                const ProductTypeWidget(),
                                const SizedBox(height: PSizes.spaceBtwInputFields),

                                // Stock
                                const ProductStockAndPricing(),
                                const SizedBox(height: PSizes.spaceBtwSections),

                                // Attributes
                                const ProductAttributes(),
                                const SizedBox(height: PSizes.spaceBtwSections),
                              ],
                            ),
                          ),
                          const SizedBox(height: PSizes.spaceBtwSections),

                          // Variations
                          const ProductVariations(),
                        ],
                      )
                  ),
                  const SizedBox(width: PSizes.defaultSpace),

                  // Sidebar
                  Expanded(
                      child: Column(
                        children: [
                          // Product Thumbnail
                          const ProductThumbnailImage(),
                          const SizedBox(height: PSizes.spaceBtwSections),

                          // Product Images
                          PRoundedContainer(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Tất cả ảnh sản phẩm', style: Theme.of(context).textTheme.headlineSmall),
                                const SizedBox(height: PSizes.spaceBtwItems),
                                ProductAdditionalImages(
                                  additionalProductImagesURLs: controller.additionalProductImagesUrls,
                                  onTapToAddImages: () => controller.selectMultipleProductImages(),
                                  onTapToRemoveImage: (index) => controller.removeImage(index),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: PSizes.spaceBtwSections),

                          // Product Brand
                          const ProductBrand(),
                          const SizedBox(height: PSizes.spaceBtwSections),

                          // Product Categories
                          const ProductCategories(),
                          const SizedBox(height: PSizes.spaceBtwSections),

                          // Product Visibility
                          const ProductVisibilityWidget(),
                          const SizedBox(height: PSizes.spaceBtwSections),
                        ],
                      )
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
