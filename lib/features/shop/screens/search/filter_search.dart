import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pine/data/repositories/brand_repository.dart';
import 'package:pine/data/repositories/category_repository.dart';
import 'package:pine/features/shop/controllers/search_controller.dart';
import 'package:pine/features/shop/models/brand_model.dart';
import 'package:pine/features/shop/models/category_model.dart';
import 'package:pine/utils/constants/colors.dart';
import 'package:pine/utils/constants/sizes.dart';

class SearchFilterContent extends StatefulWidget {
  const SearchFilterContent({
    super.key,
    required this.onReset,
    required this.onApply,
  });

  final VoidCallback onReset;
  final VoidCallback onApply;

  @override
  State<SearchFilterContent> createState() => _SearchFilterContentState();
}

class _SearchFilterContentState extends State<SearchFilterContent> {
  late final ProductSearchController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<ProductSearchController>();

    // Đăng ký repositories một lần duy nhất khi khởi tạo
    _registerRepositories();

    // Đảm bảo giá trị maxPrice không vượt quá 5 triệu
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.maxPrice.value > 5000000) {
        controller.maxPrice.value = 5000000;
      }
    });
  }

  // Đăng ký repositories một cách an toàn
  void _registerRepositories() {
    try {
      if (!Get.isRegistered<CategoryRepository>()) {
        Get.put(CategoryRepository());
      }

      if (!Get.isRegistered<BrandRepository>()) {
        Get.put(BrandRepository());
      }
    } catch (e) {
      debugPrint('Lỗi khi đăng ký repositories: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Đảm bảo giá trị hợp lệ trước khi render
    final maxValue = 5000000.0;

    return Column(
      children: [
        // Content
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Danh mục
                _buildSection(
                  'Danh mục',
                  Obx(() => _buildSelectionField(
                        value: controller.selectedCategory.value,
                        onTap: () => _showCategoryModal(context),
                        imageUrl: controller.selectedCategoryImage.value,
                        isBrand: false,
                      )),
                ),

                // Thương hiệu
                _buildSection(
                  'Thương hiệu',
                  Obx(() => _buildSelectionField(
                        value: controller.selectedBrand.value,
                        onTap: () => _showBrandModal(context),
                        imageUrl: controller.selectedBrandImage.value,
                        isBrand: true,
                      )),
                ),

                // Khoảng giá
                _buildSection(
                  'Khoảng giá',
                  Obx(() {
                    // Đảm bảo giá trị không vượt quá 5 triệu
                    final minPrice = controller.minPrice.value;
                    final maxPrice = controller.maxPrice.value > maxValue
                        ? maxValue
                        : controller.maxPrice.value;

                    return Column(
                      children: [
                        // Hiển thị giá trị
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${_formatPrice(minPrice)}₫'),
                            Text('${_formatPrice(maxPrice)}₫'),
                          ],
                        ),
                        // Thanh trượt
                        RangeSlider(
                          values: RangeValues(minPrice, maxPrice),
                          min: 0,
                          max: maxValue,
                          divisions: 50,
                          activeColor: PColors.primary,
                          onChanged: (values) {
                            controller.minPrice.value = values.start;
                            controller.maxPrice.value = values.end;
                          },
                        ),
                        // Mức giá phổ biến
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _buildPriceOption('< 100k', 0, 100000),
                            _buildPriceOption('100k-500k', 100000, 500000),
                            _buildPriceOption('500k-1tr', 500000, 1000000),
                            _buildPriceOption('1tr-2tr', 1000000, 2000000),
                            _buildPriceOption('> 2tr', 2000000, maxValue),
                          ],
                        ),
                      ],
                    );
                  }),
                ),

                // Sắp xếp
                _buildSection(
                  'Sắp xếp theo',
                  Obx(() => Column(
                        children: List.generate(
                          controller.sortOptions.length,
                          (index) {
                            final isSelected =
                                controller.selectedSort.value == index;
                            return RadioListTile<int>(
                              title: Text(controller.sortOptions[index]),
                              value: index,
                              groupValue: controller.selectedSort.value,
                              onChanged: (v) =>
                                  controller.selectedSort.value = v!,
                              dense: true,
                              activeColor: PColors.primary,
                              contentPadding: EdgeInsets.zero,
                            );
                          },
                        ),
                      )),
                ),
              ],
            ),
          ),
        ),

        // Nút điều khiển
        Padding(
          padding: const EdgeInsets.fromLTRB(
              PSizes.defaultSpace, PSizes.sm, PSizes.defaultSpace, PSizes.xs),
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: OutlinedButton(
                    onPressed: widget.onReset,
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      side: BorderSide(color: PColors.primary),
                    ),
                    child: const Text('Đặt lại'),
                  ),
                ),
              ),
              const SizedBox(width: PSizes.defaultSpace),
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () async {
                      // Hiển thị loading nếu cần
                      controller.isLoading.value = true;

                      // Nếu đã chọn danh mục, sử dụng phương thức áp dụng bộ lọc danh mục
                      if (controller.selectedCategory.value != 'Tất cả') {
                        await controller.applyFiltersByCategory();
                      } else {
                        // Nếu không có danh mục, chỉ áp dụng các bộ lọc khác
                        controller.reapplyFilters();
                      }

                      // Gọi callback để đóng modal
                      widget.onApply();
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      backgroundColor: PColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                    ),
                    child: const Text('Áp dụng'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Hiển thị modal chọn danh mục
  void _showCategoryModal(BuildContext context) {
    try {
      final controller = Get.find<ProductSearchController>();
      if (controller.categories.length <= 1) {
        controller.loadCategories();
      }

      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        builder: (context) {
          return Container(
            padding: const EdgeInsets.fromLTRB(
                PSizes.defaultSpace, 0, PSizes.defaultSpace, PSizes.md),
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.8,
            ),
            child: FutureBuilder<List<CategoryModel>>(
              future: Get.find<CategoryRepository>().getAllCategories(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  debugPrint('Lỗi tải danh mục: ${snapshot.error}');
                  return Center(
                    child: Text(
                      'Không thể tải danh mục',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text(
                      'Không có danh mục',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  );
                }

                final categories = snapshot.data!;
                final Map<String, CategoryModel> categoryMap = {};

                // Tạo map từ tên danh mục -> model
                for (var category in categories) {
                  categoryMap[category.name] = category;
                }

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Chọn danh mục',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                    ),
                    const SizedBox(height: PSizes.spaceBtwItems),

                    // Danh sách danh mục dạng lưới
                    Expanded(
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 2.5,
                        ),
                        itemCount: controller.categories.length,
                        itemBuilder: (context, index) {
                          final categoryName = controller.categories[index];
                          final isSelected =
                              controller.selectedCategory.value == categoryName;

                          // Lấy model danh mục từ map nếu có
                          final categoryModel = categoryMap[categoryName];

                          return InkWell(
                            onTap: () {
                              controller.selectedCategory.value = categoryName;
                              controller.selectedCategoryImage.value =
                                  categoryModel?.image ?? '';
                              Navigator.pop(context);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? PColors.primary.withValues(alpha: 0.1)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: isSelected
                                      ? PColors.primary
                                      : Colors.grey.shade300,
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  // Icon hoặc logo danh mục
                                  Container(
                                    width: 40,
                                    height: 40,
                                    margin: const EdgeInsets.only(left: 8),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? PColors.primary
                                              .withValues(alpha: 0.2)
                                          : Colors.grey.shade100,
                                      shape: BoxShape.circle,
                                    ),
                                    child: categoryModel != null &&
                                            categoryName != 'Tất cả'
                                        ? ClipOval(
                                            child: Image.network(
                                              categoryModel.image,
                                              fit: BoxFit.contain,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                return Icon(
                                                  Iconsax.category,
                                                  color: isSelected
                                                      ? PColors.primary
                                                      : Colors.grey,
                                                  size: 20,
                                                );
                                              },
                                            ),
                                          )
                                        : Center(
                                            child: Icon(
                                              Iconsax.category,
                                              color: isSelected
                                                  ? PColors.primary
                                                  : Colors.grey,
                                              size: 20,
                                            ),
                                          ),
                                  ),

                                  const SizedBox(width: 8),

                                  // Tên danh mục
                                  Expanded(
                                    child: Text(
                                      categoryName,
                                      style: TextStyle(
                                        color: isSelected
                                            ? PColors.primary
                                            : Colors.black,
                                        fontWeight: isSelected
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                        fontSize: 13,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),

                                  // Dấu chọn
                                  if (isSelected)
                                    Container(
                                      margin: const EdgeInsets.only(right: 8),
                                      child: const Icon(
                                        Icons.check_circle,
                                        color: PColors.primary,
                                        size: 18,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        },
      );
    } catch (e) {
      debugPrint('Lỗi hiển thị modal danh mục: $e');
    }
  }

  // Hiển thị modal chọn thương hiệu
  void _showBrandModal(BuildContext context) {
    try {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        builder: (context) {
          return Container(
            padding: const EdgeInsets.fromLTRB(
                PSizes.defaultSpace, 0, PSizes.defaultSpace, PSizes.md),
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.8,
            ),
            child: FutureBuilder<List<BrandModel>>(
              future: Get.find<BrandRepository>().getAllBrands(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  debugPrint('Lỗi tải thương hiệu: ${snapshot.error}');
                  return Center(
                    child: Text(
                      'Không thể tải thương hiệu',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text(
                      'Không có thương hiệu',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  );
                }

                final brands = snapshot.data!;
                final Map<String, BrandModel> brandMap = {};

                // Tạo map từ tên thương hiệu -> model
                for (var brand in brands) {
                  brandMap[brand.name] = brand;
                }

                // Tạo danh sách từ repository nếu controller.brands trống
                final brandNames = ['Tất cả'];
                for (var brand in brands) {
                  brandNames.add(brand.name);
                }

                // Cập nhật controller.brands nếu rỗng
                if (controller.brands.length <= 1) {
                  controller.brands.value = brandNames;
                }

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Chọn thương hiệu',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                    ),
                    const SizedBox(height: PSizes.spaceBtwItems),

                    // Danh sách thương hiệu dạng lưới
                    Expanded(
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 2.5,
                        ),
                        itemCount: controller.brands.length,
                        itemBuilder: (context, index) {
                          final brandName = controller.brands[index];
                          final isSelected =
                              controller.selectedBrand.value == brandName;

                          // Lấy model thương hiệu từ map nếu có
                          final brandModel = brandMap[brandName];

                          return InkWell(
                            onTap: () {
                              controller.selectedBrand.value = brandName;
                              controller.selectedBrandImage.value =
                                  brandModel?.image ?? '';
                              Navigator.pop(context);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? PColors.primary.withValues(alpha: 0.1)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: isSelected
                                      ? PColors.primary
                                      : Colors.grey.shade300,
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  // Logo thương hiệu
                                  Container(
                                    width: 40,
                                    height: 40,
                                    margin: const EdgeInsets.only(left: 8),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? PColors.primary
                                              .withValues(alpha: 0.2)
                                          : Colors.grey.shade100,
                                      shape: BoxShape.circle,
                                    ),
                                    child: brandModel != null &&
                                            brandName != 'Tất cả'
                                        ? ClipOval(
                                            child: Image.network(
                                              brandModel.image,
                                              fit: BoxFit.contain,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                return Icon(
                                                  Iconsax.shop,
                                                  color: isSelected
                                                      ? PColors.primary
                                                      : Colors.grey,
                                                  size: 20,
                                                );
                                              },
                                            ),
                                          )
                                        : Center(
                                            child: Icon(
                                              Iconsax.shop,
                                              color: isSelected
                                                  ? PColors.primary
                                                  : Colors.grey,
                                              size: 20,
                                            ),
                                          ),
                                  ),

                                  const SizedBox(width: 8),

                                  // Tên thương hiệu
                                  Expanded(
                                    child: Text(
                                      brandName,
                                      style: TextStyle(
                                        color: isSelected
                                            ? PColors.primary
                                            : Colors.black,
                                        fontWeight: isSelected
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                        fontSize: 13,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),

                                  // Dấu chọn
                                  if (isSelected)
                                    Container(
                                      margin: const EdgeInsets.only(right: 8),
                                      child: const Icon(
                                        Icons.check_circle,
                                        color: PColors.primary,
                                        size: 18,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        },
      );
    } catch (e) {
      debugPrint('Lỗi hiển thị modal thương hiệu: $e');
    }
  }

  // Widget field hiển thị giá trị đã chọn
  Widget _buildSelectionField({
    required String value,
    required VoidCallback onTap,
    IconData? icon,
    String? imageUrl,
    bool isBrand = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48, // Tăng chiều cao một chút để hiển thị tốt hơn
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        child: Row(
          children: [
            // Icon hoặc hình ảnh
            if (imageUrl != null && imageUrl.isNotEmpty && value != 'Tất cả')
              Container(
                width: 32,
                height: 32,
                margin: const EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  shape: BoxShape.circle,
                ),
                child: ClipOval(
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        isBrand ? Iconsax.shop : Iconsax.category,
                        color: Colors.grey,
                        size: 20,
                      );
                    },
                  ),
                ),
              )
            else
              Container(
                width: 32,
                height: 32,
                margin: const EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon ?? (isBrand ? Iconsax.shop : Iconsax.category),
                  color: Colors.grey,
                  size: 20,
                ),
              ),

            // Giá trị đã chọn
            Expanded(
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // Mũi tên
            const Icon(
              Iconsax.arrow_right_3,
              size: 16,
              color: PColors.primary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        child,
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildPriceOption(
    String label,
    double min,
    double max,
  ) {
    final isSelected =
        controller.minPrice.value == min && controller.maxPrice.value == max;

    return InkWell(
      onTap: () {
        controller.minPrice.value = min;
        controller.maxPrice.value = max;
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? PColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: isSelected ? PColors.primary : Colors.grey.shade300,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  String _formatPrice(double price) {
    return price.toInt().toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
  }
}
