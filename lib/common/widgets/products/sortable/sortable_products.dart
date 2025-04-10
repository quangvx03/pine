import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pine/features/shop/controllers/product/product_controller.dart';
import 'package:pine/features/shop/models/product_model.dart';

import '../../../../utils/constants/sizes.dart';
import '../../layouts/grid_layout.dart';
import '../product_cards/product_card_vertical.dart';

class PSortableProducts extends StatefulWidget {
  const PSortableProducts({
    super.key,
    required this.products,
    this.onLoadMore,
    this.isLastPage = true,
    this.isLoading = false,
  });

  final List<ProductModel> products;
  final VoidCallback? onLoadMore;
  final bool isLastPage;
  final bool isLoading;

  @override
  State<PSortableProducts> createState() => _PSortableProductsState();
}

class _PSortableProductsState extends State<PSortableProducts> {
  late final ProductController controller;
  final RxList<ProductModel> products = <ProductModel>[].obs;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Khởi tạo controller
    controller =
        Get.put(ProductController(), tag: 'sortable_${widget.hashCode}');

    // Gán dữ liệu ban đầu
    products.assignAll(widget.products);
    _sortProducts(controller.selectedSortOption.value);

    // Thiết lập scroll listener nếu cần tải thêm
    if (widget.onLoadMore != null) {
      _scrollController.addListener(_onScroll);
    }
  }

  @override
  void didUpdateWidget(PSortableProducts oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Cập nhật danh sách khi dữ liệu thay đổi
    if (widget.products != oldWidget.products) {
      products.assignAll(widget.products);
      _sortProducts(controller.selectedSortOption.value);
    }
  }

  void _onScroll() {
    // Tải thêm khi cuộn đến gần cuối
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      if (!widget.isLastPage && !widget.isLoading) {
        widget.onLoadMore?.call();
      }
    }
  }

  @override
  void dispose() {
    Get.delete<ProductController>(tag: 'sortable_${widget.hashCode}');
    if (widget.onLoadMore != null) {
      _scrollController.removeListener(_onScroll);
    }
    _scrollController.dispose();
    products.close();
    super.dispose();
  }

  void _sortProducts(String sortOption) {
    List<ProductModel> sortedProducts = [...products];

    switch (sortOption) {
      case 'Tên':
        sortedProducts.sort((a, b) => a.title.compareTo(b.title));
        break;
      case 'Giá cao':
        sortedProducts.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'Giá thấp':
        sortedProducts.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'Mới nhất':
        sortedProducts.sort((a, b) => a.date!.compareTo(b.date!));
        break;
      case 'Giảm giá':
        sortedProducts.sort((a, b) {
          if (b.salePrice > 0) {
            return b.salePrice.compareTo(a.salePrice);
          } else if (a.salePrice > 0) {
            return -1;
          } else {
            return 1;
          }
        });
        break;
      default:
        sortedProducts.sort((a, b) => a.title.compareTo(b.title));
    }

    products.assignAll(sortedProducts);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// Dropdown để sắp xếp
        Obx(() => DropdownButtonFormField(
            decoration: const InputDecoration(prefixIcon: Icon(Iconsax.sort)),
            value: controller.selectedSortOption.value,
            onChanged: (value) {
              if (value != null) {
                controller.selectedSortOption.value = value;
                _sortProducts(value);
              }
            },
            items: [
              'Tên',
              'Giá cao',
              'Giá thấp',
              'Giảm giá',
              'Mới nhất',
            ]
                .map((option) =>
                    DropdownMenuItem(value: option, child: Text(option)))
                .toList())),

        const SizedBox(
          height: PSizes.spaceBtwSections,
        ),

        /// Danh sách sản phẩm
        Obx(() {
          if (products.isEmpty) {
            return const Center(child: Text('Không có sản phẩm nào'));
          }

          return Column(
            children: [
              // Grid layout cho sản phẩm
              PGridLayout(
                itemCount: products.length,
                itemBuilder: (_, index) =>
                    PProductCardVertical(product: products[index]),
              ),

              // Indicator tải thêm
              if (widget.isLoading)
                const Padding(
                  padding: EdgeInsets.all(PSizes.defaultSpace),
                  child: Center(child: CircularProgressIndicator()),
                ),
            ],
          );
        }),
      ],
    );
  }
}
