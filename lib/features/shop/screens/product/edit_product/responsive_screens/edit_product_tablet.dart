import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

import '../../../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../routes/routes.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/device/device_utility.dart';
import '../../../../controllers/product_images_controller.dart';
import '../../../../models/product_model.dart';
import '../../create_product/widgets/additional_images.dart';
import '../../create_product/widgets/attributes_widget.dart';
import '../../create_product/widgets/bottom_navigation_widget.dart';
import '../../create_product/widgets/brand_widget.dart';
import '../../create_product/widgets/categories_widget.dart';
import '../../create_product/widgets/product_type_widget.dart';
import '../../create_product/widgets/stock_pricing_widget.dart';
import '../../create_product/widgets/thumbnail_widget.dart';
import '../../create_product/widgets/title_description.dart';
import '../../create_product/widgets/variations_widget.dart';
import '../../create_product/widgets/visibility_widget.dart';
import '../widgets/edit_product_form.dart';

class EditProductTabletScreen extends StatelessWidget {
  const EditProductTabletScreen({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductImagesController());
    return Scaffold(
      bottomNavigationBar: const ProductBottomNavigationButtons(),
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
                                  additionalProductImagesURLs: RxList<String>.empty(),
                                  onTapToAddImages: (){},
                                  onTapToRemoveImage: (index){},
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
