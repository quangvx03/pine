import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pine/common/widgets/appbar/appbar.dart';
import 'package:pine/common/widgets/products/sortable/sortable_products.dart';
import 'package:pine/common/widgets/shimmers/vertical_product_shimmer.dart';
import 'package:pine/features/shop/controllers/brand_controller.dart';
import 'package:pine/utils/constants/colors.dart';
import 'package:pine/utils/constants/sizes.dart';
import 'package:pine/utils/helpers/helper_functions.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../models/brand_model.dart';

class BrandProducts extends StatefulWidget {
  const BrandProducts({super.key, required this.brand});

  final BrandModel brand;

  @override
  State<BrandProducts> createState() => _BrandProductsState();
}

class _BrandProductsState extends State<BrandProducts> {
  late final BrandController brandController;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    brandController = BrandController.getInstance(widget.brand.id);

    // Tải sản phẩm đầu tiên khi vào màn hình (với lazy loading)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      brandController.fetchBrandProductsPaginated(
          brandId: widget.brand.id, isInitial: true);

      brandController.fetchActualProductCount(widget.brand.id);
    });

    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  // Kiểm tra khi cuộn đến gần cuối danh sách để tải thêm sản phẩm
  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      if (!brandController.isLastPage.value &&
          !brandController.isLoadingMore.value) {
        brandController.fetchBrandProductsPaginated(
          brandId: widget.brand.id,
          isInitial: false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final dark = PHelperFunctions.isDarkMode(context);

    return Scaffold(
      appBar: PAppBar(
        title: Text(widget.brand.name),
        showBackArrow: true,
      ),
      body: ListView(
        controller: _scrollController,
        children: [
          Container(
            width: double.infinity,
            color:
                dark ? PColors.dark : PColors.primary.withValues(alpha: 0.05),
            child: Column(
              children: [
                // Logo và thông tin thương hiệu
                Padding(
                  padding: const EdgeInsets.all(PSizes.defaultSpace),
                  child: Column(
                    children: [
                      // Brand Image
                      Container(
                        width: 80,
                        height: 80,
                        padding: const EdgeInsets.all(PSizes.sm + 2),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: PColors.primary.withValues(alpha: 0.5),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 5,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: CachedNetworkImage(
                          imageUrl: widget.brand.image,
                          fit: BoxFit.contain,
                          errorWidget: (context, url, error) => Icon(
                            Icons.error_outline,
                            color: PColors.error,
                          ),
                        ),
                      ),

                      const SizedBox(height: PSizes.spaceBtwItems),

                      // Brand Title
                      Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Text(
                                widget.brand.name,
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: PSizes.xs),
                              child: Icon(
                                Iconsax.verify5,
                                color: PColors.primary,
                                size: PSizes.iconSm,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Thay đổi phần hiển thị số lượng sản phẩm
                      Container(
                        margin: const EdgeInsets.only(top: PSizes.sm),
                        padding: const EdgeInsets.symmetric(
                          horizontal: PSizes.md,
                          vertical: PSizes.xs,
                        ),
                        decoration: BoxDecoration(
                          color: PColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(PSizes.sm),
                        ),
                        child: Obx(
                          () => Text(
                            '${brandController.actualProductCount.value} sản phẩm',
                            style:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      color: PColors.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),

                // Thanh tiêu đề phần sản phẩm
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: PSizes.defaultSpace,
                    vertical: PSizes.md,
                  ),
                  decoration: BoxDecoration(
                    color: dark ? PColors.darkerGrey : Colors.white,
                    border: Border(
                      bottom: BorderSide(
                        color: dark ? Colors.black : Colors.grey.shade200,
                        width: 1,
                      ),
                    ),
                  ),
                  child: Text(
                    'Tất cả sản phẩm',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ],
            ),
          ),

          // Brand Products - Phần hiển thị danh sách sản phẩm có sortable
          Padding(
            padding: const EdgeInsets.fromLTRB(PSizes.defaultSpace,
                PSizes.spaceBtwItems, PSizes.defaultSpace, 0),
            child: Obx(() {
              if (brandController.isLoading.value &&
                  brandController.brandProducts.isEmpty) {
                return const PVerticalProductShimmer();
              }

              if (brandController.brandProducts.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Iconsax.box_1,
                        size: 54,
                        color: dark ? PColors.grey : Colors.grey.shade400,
                      ),
                      const SizedBox(height: PSizes.spaceBtwItems),
                      Text(
                        'Không có sản phẩm nào thuộc thương hiệu này!',
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }

              return Column(
                children: [
                  PSortableProducts(
                    products: brandController.brandProducts,
                    useExpanded: false,
                    isLoading: brandController.isLoadingMore.value,
                    isLastPage: brandController.isLastPage.value,
                    currentSortOption: brandController.selectedSortOption.value,
                    onSort: (String sortOption) {
                      brandController.sortProducts(sortOption);
                    },
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}
