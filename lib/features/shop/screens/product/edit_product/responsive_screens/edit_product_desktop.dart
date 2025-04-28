import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pine_admin_panel/features/shop/controllers/product/edit_product_controller.dart';
import 'package:pine_admin_panel/features/shop/screens/product/edit_product/widgets/additional_images.dart';
import 'package:pine_admin_panel/features/shop/screens/product/edit_product/widgets/attributes_widget.dart';
import 'package:pine_admin_panel/features/shop/screens/product/edit_product/widgets/brand_widget.dart';
import 'package:pine_admin_panel/features/shop/screens/product/edit_product/widgets/categories_widget.dart';
import 'package:pine_admin_panel/features/shop/screens/product/edit_product/widgets/product_type_widget.dart';
import 'package:pine_admin_panel/features/shop/screens/product/edit_product/widgets/stock_pricing_widget.dart';
import 'package:pine_admin_panel/features/shop/screens/product/edit_product/widgets/thumbnail_widget.dart';
import 'package:pine_admin_panel/features/shop/screens/product/edit_product/widgets/title_description.dart';
import 'package:pine_admin_panel/features/shop/screens/product/edit_product/widgets/variations_widget.dart';
import 'package:pine_admin_panel/features/shop/screens/product/edit_product/widgets/visibility_widget.dart';
import 'package:pine_admin_panel/features/shop/screens/product/edit_product/widgets/bottom_navigation_widget.dart';

import '../../../../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../../routes/routes.dart';
import '../../../../../../../utils/constants/sizes.dart';
import '../../../../../../../utils/device/device_utility.dart';
import '../../../../controllers/product/product_images_controller.dart';
import '../../../../models/product_model.dart';

class EditProductDesktopScreen extends StatelessWidget {
  const EditProductDesktopScreen({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductImagesController());
    final editController = Get.put(EditProductController());

    return Scaffold(
      bottomNavigationBar: ProductBottomNavigationButtons(product: product),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(PSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Breadcrumbs
              const PBreadcrumbsWithHeading(returnToPreviousScreen: true, heading: 'Cập nhật sản phẩm', breadcrumbItems: [{ 'label': 'Danh sách sản phẩm', 'path': PRoutes.products }, 'Cập nhật sản phẩm']),
              const SizedBox(height: PSizes.spaceBtwSections),

              // Edit Product
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      flex: PDeviceUtils.isTabletScreen(context) ? 2 : 3,
                      child: Column(
                        crossAxisAlignment:  CrossAxisAlignment.start,
                        children: [
                          // Basic Information
                          ProductTitleAndDescription(product: product),
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
                                ProductTypeWidget(product: product),
                                const SizedBox(height: PSizes.spaceBtwInputFields),

                                // Stock
                                ProductStockAndPricing(product: product),
                                const SizedBox(height: PSizes.spaceBtwSections),

                                // Attributes
                                ProductAttributes(product: product),
                                const SizedBox(height: PSizes.spaceBtwSections),
                              ],
                            ),
                          ),
                          const SizedBox(height: PSizes.spaceBtwSections),

                          // Variations
                          ProductVariations(product: product),
                        ],
                      )
                  ),
                  const SizedBox(width: PSizes.defaultSpace),

                  // Sidebar
                  Expanded(
                      child: Column(
                        children: [
                          // Product Thumbnail
                          ProductThumbnailImage(product: product),
                          const SizedBox(height: PSizes.spaceBtwSections),

                          // Product Images
                          PRoundedContainer(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Tất cả ảnh sản phẩm', style: Theme.of(context).textTheme.headlineSmall),
                                const SizedBox(height: PSizes.spaceBtwItems),
                                ProductAdditionalImages(
                                  additionalProductImagesURLs: ProductImagesController.instance.additionalProductImagesUrls,
                                  onTapToAddImages: () {
                                    editController.selectMultipleProductImages();
                                  },
                                  onTapToRemoveImage: (index) {
                                    editController.removeAdditionalImage(index);
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: PSizes.spaceBtwSections),

                          // Product Brand
                          ProductBrand(product: product),
                          const SizedBox(height: PSizes.spaceBtwSections),

                          // Product Categories
                          ProductCategories(product: product),
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
