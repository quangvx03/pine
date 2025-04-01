import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/repositories/brand_repository.dart';
import '../../../data/repositories/category_repository.dart';
import '../../../data/repositories/product_repository.dart';
import '../models/product_model.dart';

class ProductSearchController extends GetxController {
  static ProductSearchController get instance => Get.find();

  // Repositories
  final _productRepository = ProductRepository.instance;

  // Controllers
  final searchTextController = TextEditingController();

  // Variables
  final RxList<ProductModel> searchResults = <ProductModel>[].obs;
  final RxList<ProductModel> featuredProducts = <ProductModel>[].obs;
  final RxList<String> recentSearches = <String>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool showFilter = false.obs;

  // Filter variables
  final RxString selectedCategory = 'Tất cả'.obs;
  final RxString selectedBrand = 'Tất cả'.obs;
  final RxDouble minPrice = 0.0.obs;
  final RxDouble maxPrice = 10000000.0.obs;
  final RxInt selectedSort = 0.obs;

  // Lists for filters
  final RxList<String> categories = <String>['Tất cả'].obs;
  final RxList<String> brands = <String>['Tất cả'].obs;
  final sortOptions = [
    'Phổ biến nhất',
    'Giá thấp đến cao',
    'Giá cao đến thấp',
    'Đánh giá cao nhất',
    'Mới nhất'
  ].obs;

  // Popular searches
  final popularSearches = [
    'Sữa',
    'Nước giải khát',
    'Mì gói',
    'Dầu gội',
    'Bánh kẹo',
    'Giấy vệ sinh'
  ].obs;

  @override
  void onInit() {
    super.onInit();
    loadCategories();
    loadBrands();
    loadRecentSearches();
  }

  // Load categories for filter
  void loadCategories() async {
    try {
      final categoryRepo = Get.find<CategoryRepository>();
      final cats = await categoryRepo.getAllCategories();
      categories.value = ['Tất cả', ...cats.map((cat) => cat.name)];
    } catch (e) {
      debugPrint('Không thể tải danh mục: $e');
    }
  }

  // Load brands for filter
  void loadBrands() async {
    try {
      final brandRepo = Get.find<BrandRepository>();
      final brandsList = await brandRepo.getAllBrands();
      brands.value = ['Tất cả', ...brandsList.map((brand) => brand.name)];
    } catch (e) {
      debugPrint('Không thể tải thương hiệu: $e');
    }
  }

  // Load recent searches from local storage
  void loadRecentSearches() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final searches = prefs.getStringList('recent_searches') ?? [];
      recentSearches.assignAll(searches);
    } catch (e) {
      debugPrint('Không thể tải tìm kiếm gần đây: $e');
    }
  }

  // Save recent search to local storage
  void saveRecentSearch(String query) async {
    if (query.trim().isEmpty) return;

    try {
      // Add to recent searches, avoid duplicates and limit to 10 items
      if (recentSearches.contains(query)) {
        recentSearches.remove(query);
      }
      recentSearches.insert(0, query);
      if (recentSearches.length > 10) {
        recentSearches.removeLast();
      }

      // Save to local storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('recent_searches', recentSearches);
    } catch (e) {
      debugPrint('Không thể lưu tìm kiếm gần đây: $e');
    }
  }

  // Remove a recent search
  void removeRecentSearch(String query) async {
    recentSearches.remove(query);
    // Update local storage
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('recent_searches', recentSearches);
  }

  // Clear all recent searches
  void clearRecentSearches() async {
    recentSearches.clear();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('recent_searches');
  }

  // Cập nhật phương thức searchProducts
  void searchProducts() async {
    final query = searchTextController.text.trim();

    if (query.isEmpty) {
      searchResults.clear(); // Xóa kết quả nếu query rỗng
      return;
    }

    try {
      // Show loading
      isLoading.value = true;

      // Ghi log để debug
      debugPrint('Bắt đầu tìm kiếm với từ khóa: "$query"');

      // Perform search
      final results = await _productRepository.searchProducts(query);

      // Ghi log kết quả
      debugPrint('Nhận được ${results.length} kết quả từ repository');

      // Nếu đã chọn danh mục cụ thể (không phải "Tất cả"), bỏ qua bước lọc để tránh lọc quá mức
      if (selectedCategory.value == 'Tất cả' ||
          selectedCategory.value == 'Tất cả sản phẩm') {
        // Chỉ lọc theo giá và sắp xếp
        var filtered = results
            .where((product) => (product.price >= minPrice.value &&
                product.price <= maxPrice.value))
            .toList();

        // Sắp xếp nếu cần
        if (selectedSort.value > 0) {
          switch (selectedSort.value) {
            case 1: // Giá thấp đến cao
              filtered.sort((a, b) => a.price.compareTo(b.price));
              break;
            case 2: // Giá cao đến thấp
              filtered.sort((a, b) => b.price.compareTo(a.price));
              break;
            // Các trường hợp khác
          }
        }

        searchResults.assignAll(filtered);
      } else {
        // Nếu đã chọn danh mục cụ thể, áp dụng đầy đủ bộ lọc
        final filtered = applyFiltersToResults(results);
        searchResults.assignAll(filtered);
      }

      // Save search query to recent searches
      saveRecentSearch(query);
    } catch (e) {
      debugPrint('Lỗi tìm kiếm: $e');
      Get.snackbar('Lỗi tìm kiếm', 'Không thể tìm kiếm sản phẩm');
    } finally {
      isLoading.value = false;
    }
  }

  // Apply filters to search results - Sửa lỗi lọc theo danh mục
  List<ProductModel> applyFiltersToResults(List<ProductModel> results) {
    if (results.isEmpty) return [];

    var filtered = [...results];
    debugPrint('Áp dụng bộ lọc cho ${results.length} kết quả');

    try {
      // Filter by category - SỬA LỖI Ở ĐÂY
      if (selectedCategory.value != 'Tất cả' &&
          selectedCategory.value != 'Tất cả sản phẩm') {
        debugPrint('Lọc theo danh mục: ${selectedCategory.value}');
        filtered = filtered.where((product) {
          // Kiểm tra nếu sản phẩm thuộc danh mục này
          bool match = product.categoryId == selectedCategory.value;

          // Kiểm tra thêm trong title hoặc description
          if (!match) {
            if (product.title
                .toLowerCase()
                .contains(selectedCategory.value.toLowerCase())) {
              match = true;
            }
            if (!match && product.description != null) {
              if (product.description!
                  .toLowerCase()
                  .contains(selectedCategory.value.toLowerCase())) {
                match = true;
              }
            }
          }
          return match;
        }).toList();
        debugPrint('Sau khi lọc danh mục: ${filtered.length} kết quả');
      } else {
        debugPrint('Bỏ qua lọc danh mục vì đã chọn "Tất cả"');
      }

      // Filter by brand
      if (selectedBrand.value != 'Tất cả') {
        debugPrint('Lọc theo thương hiệu: ${selectedBrand.value}');
        filtered = filtered.where((product) {
          return product.brand?.name == selectedBrand.value;
        }).toList();
        debugPrint('Sau khi lọc thương hiệu: ${filtered.length} kết quả');
      }

      // Filter by price
      debugPrint('Lọc theo giá: ${minPrice.value} - ${maxPrice.value}');
      filtered = filtered
          .where((product) => (product.price >= minPrice.value &&
              product.price <= maxPrice.value))
          .toList();
      debugPrint('Sau khi lọc giá: ${filtered.length} kết quả');

      // Sort results
      if (selectedSort.value > 0) {
        debugPrint('Sắp xếp theo: ${sortOptions[selectedSort.value]}');
        switch (selectedSort.value) {
          case 1: // Giá thấp đến cao
            filtered.sort((a, b) => a.price.compareTo(b.price));
            break;
          case 2: // Giá cao đến thấp
            filtered.sort((a, b) => b.price.compareTo(a.price));
            break;
          case 3: // Stock (thay thế cho rating)
            filtered.sort((a, b) => b.stock.compareTo(a.stock));
            break;
          case 4: // Ngày (nếu có)
            filtered.sort((a, b) {
              if (a.date != null && b.date != null) {
                return b.date!.compareTo(a.date!);
              }
              return b.id.compareTo(a.id);
            });
            break;
        }
      }

      return filtered;
    } catch (e) {
      debugPrint('Lỗi khi áp dụng bộ lọc: $e');
      return results; // Trả về kết quả gốc nếu có lỗi
    }
  }

  // Cập nhật phương thức searchByCategory
  void searchByCategory(String categoryName) async {
    try {
      isLoading.value = true;
      debugPrint('Đang tìm kiếm theo danh mục: $categoryName');

      // Đặt category đã chọn
      selectedCategory.value = categoryName;

      // Đặt nội dung tìm kiếm vào ô tìm kiếm (chỉ khi cần)
      if (categoryName != 'Tất cả sản phẩm' && categoryName != 'Tất cả') {
        searchTextController.text = categoryName;
      } else {
        // Nếu chọn tất cả, để trống ô tìm kiếm
        searchTextController.text = '';
      }

      // Lấy tất cả sản phẩm
      final allProducts = await _productRepository.getAllProducts();
      debugPrint('Đã lấy ${allProducts.length} sản phẩm');

      // Lọc kết quả theo danh mục
      List<ProductModel> results = allProducts;

      if (categoryName != 'Tất cả sản phẩm' && categoryName != 'Tất cả') {
        // Lọc sơ bộ theo danh mục
        results = allProducts.where((product) {
          bool match = false;

          // Kiểm tra categoryId
          if (product.categoryId == categoryName) match = true;

          // Kiểm tra tên sản phẩm
          if (!match &&
              product.title
                  .toLowerCase()
                  .contains(categoryName.toLowerCase())) {
            match = true;
          }

          // Kiểm tra mô tả
          if (!match &&
              product.description != null &&
              product.description!
                  .toLowerCase()
                  .contains(categoryName.toLowerCase())) {
            match = true;
          }

          return match;
        }).toList();
      }

      debugPrint(
          'Tìm thấy ${results.length} sản phẩm thuộc danh mục "$categoryName"');

      // Áp dụng các bộ lọc khác nếu cần
      // Bỏ qua bước này để hiển thị tất cả sản phẩm trong danh mục
      // final filtered = applyFiltersToResults(results);

      // Cập nhật kết quả trực tiếp
      searchResults.assignAll(results);
    } catch (e) {
      debugPrint('Lỗi khi tìm kiếm theo danh mục: $e');
      Get.snackbar('Lỗi', 'Không thể tìm kiếm theo danh mục: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Reset filters
  void resetFilters() {
    selectedCategory.value = 'Tất cả';
    selectedBrand.value = 'Tất cả';
    minPrice.value = 0.0;
    maxPrice.value = 10000000.0;
    selectedSort.value = 0;
  }

  // Toggle filter panel
  void toggleFilter() {
    showFilter.value = !showFilter.value;
  }

  @override
  void onClose() {
    searchTextController.dispose();
    super.onClose();
  }
}
