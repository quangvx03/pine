import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pine/common/widgets/appbar/appbar.dart';
import 'package:pine/common/widgets/products/cart/cart_menu_icon.dart';
import 'package:pine/common/widgets/products/sortable/sortable_products.dart';
import 'package:pine/common/widgets/shimmers/vertical_product_shimmer.dart';
import 'package:pine/features/shop/controllers/product/product_controller.dart';
import 'package:pine/utils/constants/colors.dart';
import 'package:pine/utils/constants/sizes.dart';
import 'package:pine/utils/helpers/helper_functions.dart';

class AllProductsScreen extends StatefulWidget {
  const AllProductsScreen({
    super.key,
    required this.title,
    this.showBackArrow = true,
    this.categoryId = '',
    this.brandId = '',
  });

  final String title;
  final bool showBackArrow;
  final String categoryId;
  final String brandId;

  @override
  State<AllProductsScreen> createState() => _AllProductsScreenState();
}

class _AllProductsScreenState extends State<AllProductsScreen> {
  late final ProductController controller;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // Sử dụng controller toàn cục nếu đã tồn tại, hoặc tạo mới
    controller = Get.find<ProductController>();

    // Xác định xem đây có phải là màn hình "Tất cả sản phẩm" không (không có bộ lọc)
    bool isMainProductScreen =
        widget.categoryId.isEmpty && widget.brandId.isEmpty;

    // Nếu đây là màn hình chính tất cả sản phẩm (không có bộ lọc), reset lại controller
    if (isMainProductScreen) {
      controller.clearFilters();
    } else {
      controller.setFilterParameters(
        newCategoryId: widget.categoryId.isEmpty ? null : widget.categoryId,
        newBrandId: widget.brandId.isEmpty ? null : widget.brandId,
      );
    }

    // Tải sản phẩm đầu tiên khi vào màn hình (với lazy loading)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchProductsPaginated(isInitial: true);
    });

    // Thêm listener cho scrolling để load thêm sản phẩm khi cuộn đến cuối
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
      // Kiểm tra không phải trang cuối và không đang tải
      if (!controller.isLastPage.value && !controller.isLoadingMore.value) {
        controller.fetchProductsPaginated(isInitial: false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final dark = PHelperFunctions.isDarkMode(context);

    return Scaffold(
      appBar: PAppBar(
        title: Text(widget.title),
        showBackArrow: widget.showBackArrow,
        actions: const [PCartCounterIcon()],
      ),
      // Sử dụng ListView để có nền xám đồng nhất và hỗ trợ infinite scrolling
      body: ListView(
        controller: _scrollController,
        children: [
          // Products - Phần hiển thị danh sách sản phẩm có sortable
          Padding(
            padding: const EdgeInsets.fromLTRB(PSizes.defaultSpace,
                PSizes.spaceBtwItems, PSizes.defaultSpace, 0),
            child: Obx(() {
              // Hiển thị shimmer khi đang tải lần đầu
              if (controller.isLoading.value &&
                  controller.allProducts.isEmpty) {
                return const PVerticalProductShimmer();
              }

              if (controller.allProducts.isEmpty) {
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
                        'Không có sản phẩm nào!',
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }

              // Sử dụng PSortableProducts với các tùy chỉnh
              return PSortableProducts(
                products: controller.allProducts,
                useExpanded: false,
                isLoading: controller.isLoading.value ||
                    controller.isLoadingMore.value,
                isLastPage: controller.isLastPage.value,
                currentSortOption: controller.selectedSortOption.value,
                onSort: (sortOption) {
                  controller.changeSortOption(sortOption);
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
