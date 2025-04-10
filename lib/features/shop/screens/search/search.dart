import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pine/features/shop/controllers/search_controller.dart';
import 'package:pine/features/shop/screens/search/filter_bottom_sheet.dart';

import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../common/widgets/layouts/grid_layout.dart';
import '../../../../common/widgets/products/cart/cart_menu_icon.dart';
import '../../../../common/widgets/products/product_cards/product_card_vertical.dart';
import '../../../../common/widgets/shimmers/vertical_product_shimmer.dart';
import '../../../../common/widgets/texts/section_heading.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/device/device_utility.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductSearchController());

    return Scaffold(
      appBar: PAppBar(
        title:
            Text('Tìm kiếm', style: Theme.of(context).textTheme.headlineMedium),
        actions: [PCartCounterIcon()],
      ),
      body: Obx(() {
        final hasSearchQuery = controller.searchTextController.text.isNotEmpty;
        final isLoading = controller.isLoading.value;

        return SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: PSizes.defaultSpace),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: PSizes.spaceBtwItems),

                /// Thanh tìm kiếm và nút lọc
                _buildSearchRow(context, controller),
                const SizedBox(height: PSizes.spaceBtwItems),

                /// Lịch sử tìm kiếm hoặc gợi ý tìm kiếm
                if (!hasSearchQuery) ...[
                  _buildSearchHistory(controller),
                  const SizedBox(height: PSizes.spaceBtwSections),
                  _buildSearchSuggestions(),
                  const SizedBox(height: PSizes.spaceBtwSections),
                ],

                /// Kết quả tìm kiếm
                if (hasSearchQuery) ...[
                  // Hiển thị loading hoặc kết quả
                  if (isLoading)
                    const PVerticalProductShimmer(itemCount: 4)
                  else
                    _buildSearchResults(controller, context)
                ],
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildSearchRow(
      BuildContext context, ProductSearchController controller) {
    return Row(
      children: [
        // Thanh tìm kiếm
        Expanded(
          child: TextFormField(
            controller: controller.searchTextController,
            decoration: InputDecoration(
              prefixIcon: const Icon(
                Iconsax.search_normal,
                size: 18,
              ),
              hintText: 'Tìm kiếm sản phẩm...',
              suffixIcon: IconButton(
                icon: const Icon(Iconsax.close_square),
                onPressed: () {
                  controller.searchTextController.clear();
                  controller.searchResults.clear();
                  PDeviceUtils.hideKeyboard(context);
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(PSizes.cardRadiusLg),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(PSizes.cardRadiusLg),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(PSizes.cardRadiusLg),
                borderSide: BorderSide(color: PColors.primary),
              ),
            ),
            onFieldSubmitted: (_) {
              controller.searchProducts();
              PDeviceUtils.hideKeyboard(context);
            },
          ),
        ),

        // Nút lọc
        const SizedBox(width: PSizes.spaceBtwItems / 2),
        Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(PSizes.cardRadiusLg),
          ),
          child: IconButton(
            onPressed: () => _showFilterBottomSheet(context),
            icon: const Icon(Iconsax.filter),
            color: PColors.primary,
            iconSize: 18,
            tooltip: 'Lọc sản phẩm',
            padding: const EdgeInsets.all(16),
            constraints: const BoxConstraints(),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchHistory(ProductSearchController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tiêu đề phần lịch sử tìm kiếm
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Lịch sử tìm kiếm',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (controller.recentSearches.isNotEmpty)
              TextButton(
                onPressed: () => controller.clearRecentSearches(),
                style: TextButton.styleFrom(
                  minimumSize: Size.zero,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text('Xóa tất cả'),
              ),
          ],
        ),
        const SizedBox(height: PSizes.spaceBtwItems / 2),

        // Hiển thị lịch sử tìm kiếm
        Obx(() {
          if (controller.recentSearches.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  'Chưa có lịch sử tìm kiếm',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
            );
          }

          // Hiển thị lịch sử dưới dạng chip có thể cuộn ngang
          return Wrap(
            spacing: 4,
            runSpacing: 4,
            children: controller.recentSearches.take(12).map((term) {
              return InputChip(
                avatar: const Icon(
                  Iconsax.clock,
                  size: 16,
                  color: Colors.grey,
                ),
                label: Text(
                  term,
                  style: const TextStyle(fontSize: 12),
                ),
                deleteIcon: const Icon(
                  Icons.close,
                  size: 16,
                ),
                onDeleted: () {
                  controller.recentSearches.remove(term);
                },
                onPressed: () {
                  controller.searchTextController.text = term;
                  controller.searchProducts();
                },
                backgroundColor: Colors.grey.shade50,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: Colors.grey.shade300),
                ),
              );
            }).toList(),
          );
        }),
      ],
    );
  }

  Widget _buildSearchSuggestions() {
    // Các từ khóa gợi ý tìm kiếm phổ biến
    final suggestions = [
      'Nước',
      'Snack',
      'Bánh kẹo',
      'Mì gói',
      'Sữa',
      'Kem',
      'Gia vị',
      'Dầu gội',
      'Sữa tắm',
      'Bột giặt',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const PSectionHeading(
          title: 'Gợi ý tìm kiếm',
          showActionButton: false,
        ),
        const SizedBox(height: PSizes.spaceBtwItems),

        // Hiển thị gợi ý theo dạng lưới 2 cột
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: (suggestions.length / 2).ceil(), // Số hàng cần hiển thị
          itemBuilder: (context, rowIndex) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  // Cột 1
                  Expanded(
                    child: _buildSuggestionItem(suggestions[rowIndex * 2],
                        rowIndex * 2 >= suggestions.length),
                  ),

                  const SizedBox(width: 8),

                  // Cột 2 (kiểm tra xem có đủ phần tử không)
                  Expanded(
                    child: rowIndex * 2 + 1 < suggestions.length
                        ? _buildSuggestionItem(
                            suggestions[rowIndex * 2 + 1], false)
                        : const SizedBox(), // Trường hợp số lẻ
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSuggestionItem(String suggestion, bool isEmpty) {
    if (isEmpty) return const SizedBox();

    return InkWell(
      onTap: () {
        final controller = Get.find<ProductSearchController>();
        controller.searchTextController.text = suggestion;
        controller.searchProducts();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            const Icon(Iconsax.search_normal, size: 16, color: Colors.grey),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                suggestion,
                style: const TextStyle(fontSize: 14),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults(
      ProductSearchController controller, BuildContext context) {
    // Không có kết quả
    if (controller.searchResults.isEmpty) {
      return Center(
        child: Column(
          children: [
            const SizedBox(height: PSizes.spaceBtwSections),
            Icon(
              Iconsax.search_normal,
              size: 80,
              color: PColors.primary,
            ),
            const SizedBox(height: PSizes.spaceBtwItems),
            Text(
              'Không tìm thấy kết quả!',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: PSizes.spaceBtwItems),
            Text(
              'Hãy thử tìm kiếm với từ khóa khác',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    // Hiển thị kết quả tìm kiếm
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${controller.searchResults.length} kết quả tìm kiếm',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            // Nút sắp xếp kết quả
            PopupMenuButton<int>(
              icon: const Icon(Iconsax.sort),
              onSelected: (index) {
                controller.selectedSort.value = index;
                controller.searchProducts();
              },
              itemBuilder: (context) => [
                const PopupMenuItem(value: 0, child: Text('Phổ biến nhất')),
                const PopupMenuItem(value: 1, child: Text('Giá thấp đến cao')),
                const PopupMenuItem(value: 2, child: Text('Giá cao đến thấp')),
              ],
            ),
          ],
        ),
        const SizedBox(height: PSizes.spaceBtwItems),
        PGridLayout(
          itemCount: controller.searchResults.length,
          itemBuilder: (_, index) {
            return PProductCardVertical(
              product: controller.searchResults[index],
            );
          },
        ),
      ],
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: const FilterBottomSheet(),
      ),
    );
  }
}
