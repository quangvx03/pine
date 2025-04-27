import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pine/features/shop/controllers/product/product_controller.dart';
import 'package:pine/features/shop/models/product_model.dart';
import 'package:pine/utils/constants/colors.dart';
import 'package:pine/utils/constants/sizes.dart';
import '../../layouts/grid_layout.dart';
import '../product_cards/product_card_vertical.dart';

class PSortableProducts extends StatefulWidget {
  const PSortableProducts({
    super.key,
    required this.products,
    this.onLoadMore,
    this.onSort,
    this.isLastPage = true,
    this.isLoading = false,
    this.useExpanded = false,
    this.currentSortOption,
  });

  final List<ProductModel> products;
  final VoidCallback? onLoadMore;
  final Function(String)? onSort;
  final bool isLastPage;
  final bool isLoading;
  final bool useExpanded;
  final String? currentSortOption; // Tùy chọn sắp xếp hiện tại từ bên ngoài

  @override
  State<PSortableProducts> createState() => _PSortableProductsState();
}

class _PSortableProductsState extends State<PSortableProducts> {
  // Sử dụng controller từ global scope thay vì tạo mới
  late final ProductController controller;
  final ScrollController _scrollController = ScrollController();

  // Tùy chọn sắp xếp
  final sortOptions = [
    "A-Z",
    "Z-A",
    "Giá cao",
    "Giá thấp",
    "Bán chạy",
    "Giảm giá",
    "Đánh giá"
  ];

  @override
  void initState() {
    super.initState();
    // Tìm controller hoặc tạo một controller tạm thời nếu không tìm thấy
    controller = Get.isRegistered<ProductController>()
        ? Get.find<ProductController>()
        : ProductController();

    if (widget.onLoadMore != null) {
      _scrollController.addListener(_onScroll);
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      if (!widget.isLastPage && !widget.isLoading) {
        widget.onLoadMore?.call();
      }
    }
  }

  @override
  void dispose() {
    if (widget.onLoadMore != null) {
      _scrollController.removeListener(_onScroll);
    }
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Lấy giá trị sắp xếp hiện tại từ widget nếu có, nếu không thì lấy từ controller
    final currentSortOption =
        widget.currentSortOption ?? controller.selectedSortOption.value;

    // Phần tùy chọn sắp xếp
    final sortingOptionsRow = Padding(
      padding: const EdgeInsets.only(bottom: PSizes.spaceBtwItems),
      child: Row(
        children: [
          const Text(
            'Sắp xếp:',
            style: TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 8),

          // Các tùy chọn sắp xếp
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: sortOptions.map((option) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: InkWell(
                      onTap: () {
                        if (widget.onSort != null) {
                          widget.onSort!(option);
                        }
                      },
                      borderRadius:
                          BorderRadius.circular(PSizes.borderRadiusSm),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: option == currentSortOption
                              ? PColors.primary
                              : Colors.transparent,
                          border: Border.all(
                            color: option == currentSortOption
                                ? PColors.primary
                                : Colors.grey.shade400,
                          ),
                          borderRadius: BorderRadius.circular(PSizes.sm),
                        ),
                        child: Text(
                          option,
                          style: TextStyle(
                            fontSize: 12,
                            color: option == currentSortOption
                                ? Colors.white
                                : Colors.black,
                            fontWeight: option == currentSortOption
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );

    // Hiển thị danh sách sản phẩm
    final productContent = widget.products.isEmpty && !widget.isLoading
        ? const Center(child: Text('Không có sản phẩm nào'))
        : ListView(
            shrinkWrap:
                true, // Quan trọng khi sử dụng trong SingleChildScrollView
            physics: widget.useExpanded
                ? null
                : const NeverScrollableScrollPhysics(), // Không cho scroll nếu không dùng Expanded
            controller: widget.useExpanded ? _scrollController : null,
            children: [
              // Grid layout với sản phẩm được truyền vào
              PGridLayout(
                itemCount: widget.products.length,
                itemBuilder: (_, index) =>
                    PProductCardVertical(product: widget.products[index]),
              ),

              // Khoảng cách trước loading indicator
              const SizedBox(height: PSizes.spaceBtwSections / 2),

              // Loading indicator hoặc thông báo
              Container(
                padding: const EdgeInsets.only(bottom: 16),
                child: widget.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : widget.isLastPage
                        ? Center(
                            child: Text(
                              'Đã hiển thị tất cả sản phẩm',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                      fontStyle: FontStyle.italic,
                                      color: PColors.darkGrey),
                            ),
                          )
                        : const SizedBox.shrink(),
              ),
            ],
          );

    // Trả về cấu trúc khác nhau tùy theo việc có sử dụng Expanded hay không
    if (widget.useExpanded) {
      return Column(
        children: [
          sortingOptionsRow,
          Expanded(child: productContent),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          sortingOptionsRow,
          productContent,
        ],
      );
    }
  }
}
