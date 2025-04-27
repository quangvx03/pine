import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/repositories/brand_repository.dart';
import '../../../data/repositories/category_repository.dart';
import '../../../data/repositories/product_repository.dart';
import '../../../data/repositories/review_repository.dart';
import '../models/product_model.dart';

class ProductSearchController extends GetxController {
  static ProductSearchController get instance => Get.find();

  // Repositories
  late final ProductRepository _productRepository;
  late final ReviewRepository _reviewRepository;

  // Constructor
  ProductSearchController() {
    _initializeRepositories();
  }

  // Controllers
  final searchTextController = TextEditingController();

  // Search state
  final RxList<ProductModel> searchResults = <ProductModel>[].obs;
  final RxList<ProductModel> originalResults = <ProductModel>[].obs;
  final RxList<String> recentSearches = <String>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingSuggestions = false.obs;
  final RxBool showFilter = false.obs;

  // Filter state
  final RxString selectedCategory = 'Tất cả'.obs;
  final RxString selectedBrand = 'Tất cả'.obs;
  final RxString selectedCategoryImage = ''.obs;
  final RxString selectedBrandImage = ''.obs;
  final RxDouble minPrice = 0.0.obs;
  final RxDouble maxPrice = 5000000.0.obs;

  // Sorting state
  final RxInt selectedSort = 0.obs;
  final sortOptions = [
    'Mặc định',
    'Giá thấp đến cao',
    'Giá cao đến thấp',
    'Bán chạy nhất',
    'Đánh giá cao nhất',
    'Giảm giá cao nhất',
  ].obs;

  // Auto-suggestion state
  final RxList<String> autoSuggestions = <String>[].obs;
  final RxList<String> allProductTitles = <String>[].obs;
  final RxList<String> allCategoryNames = <String>[].obs;

  // Filter lists
  final RxList<String> categories = <String>['Tất cả'].obs;
  final RxList<String> brands = <String>['Tất cả'].obs;

  // Lookup maps
  final Map<String, String> categoryNameToIdMap = <String, String>{};
  final Map<String, String> categoryIdToNameMap = <String, String>{};

  // Cache
  final Map<String, double> _ratingsCache = <String, double>{};

  //-----------------------------------------------------------------------------------
  // LIFECYCLE METHODS
  //-----------------------------------------------------------------------------------

  void _initializeRepositories() {
    if (!Get.isRegistered<ProductRepository>()) {
      Get.put(ProductRepository(), permanent: true);
    }
    if (!Get.isRegistered<ReviewRepository>()) {
      Get.put(ReviewRepository(), permanent: true);
    }
    if (!Get.isRegistered<CategoryRepository>()) {
      Get.put(CategoryRepository(), permanent: true);
    }
    if (!Get.isRegistered<BrandRepository>()) {
      Get.put(BrandRepository(), permanent: true);
    }

    _productRepository = Get.find<ProductRepository>();
    _reviewRepository = Get.find<ReviewRepository>();
  }

  @override
  void onInit() {
    super.onInit();
    loadCategories();
    loadBrands();
    loadRecentSearches();
    loadProductTitles();
    searchTextController.addListener(_onSearchTextChanged);
  }

  @override
  void onClose() {
    if (searchTextController.hasListeners) {
      searchTextController.removeListener(_onSearchTextChanged);
    }
    super.onClose();
  }

  //-----------------------------------------------------------------------------------
  // SEARCH METHODS
  //-----------------------------------------------------------------------------------

  void clearResults() {
    searchResults.clear();
    originalResults.clear();
    autoSuggestions.clear();
    isLoading.value = false;
    isLoadingSuggestions.value = false;
  }

// Phương thức lấy nhanh đánh giá từ cache
  void preloadRatingsCache(List<ProductModel> products) async {
    if (products.isEmpty) return;

    try {
      // Lấy danh sách ID sản phẩm chưa có trong cache
      final idsToFetch = products
          .map((p) => p.id)
          .where((id) => !_ratingsCache.containsKey(id))
          .toList();

      if (idsToFetch.isEmpty) return;

      // Lấy đánh giá cho các ID chưa có trong cache
      final newRatings =
          await _productRepository.getProductsAverageRatings(idsToFetch);

      // Cập nhật cache
      _ratingsCache.addAll(newRatings);
    } catch (e) {
      debugPrint('Lỗi khi tải trước đánh giá: $e');
    }
  }

// Sửa lại phương thức searchProducts để preload ratings
  void searchProducts() async {
    final query = searchTextController.text.trim();

    if (query.isEmpty) {
      clearResults();
      return;
    }

    try {
      isLoading.value = true;
      autoSuggestions.clear();

      final results = await _productRepository.searchProducts(query);
      originalResults.assignAll([...results]);

      // Tải trước đánh giá để có thể sử dụng sau này
      preloadRatingsCache(results);

      final filtered = applyFilters(results);
      final sortedResults = await applySorting(filtered);
      searchResults.assignAll(sortedResults);

      saveRecentSearch(query);
    } catch (e) {
      // Xử lý lỗi
    } finally {
      isLoading.value = false;
    }
  }

  void _onSearchTextChanged() {
    final query = searchTextController.text.trim();

    if (query.length < 2 || searchResults.isNotEmpty) {
      autoSuggestions.clear();
      return;
    }

    if (!isLoading.value) {
      _generateSuggestions(query);
    }
  }

  void _generateSuggestions(String query) async {
    isLoadingSuggestions.value = true;

    try {
      final lowercaseQuery = query.toLowerCase();
      final List<String> suggestions = [];

      _addProductTitleSuggestions(lowercaseQuery, suggestions);
      _addRecentSearchSuggestions(lowercaseQuery, suggestions);
      _sortSuggestionsByRelevance(lowercaseQuery, suggestions);

      autoSuggestions.assignAll(suggestions);
    } catch (e) {
      // Xử lý lỗi nếu cần
    } finally {
      isLoadingSuggestions.value = false;
    }
  }

  void _addProductTitleSuggestions(String query, List<String> suggestions) {
    for (var title in allProductTitles) {
      if (title.toLowerCase().contains(query)) {
        suggestions.add(title);
        if (suggestions.length >= 10) break;
      }
    }
  }

  void _addRecentSearchSuggestions(String query, List<String> suggestions) {
    for (var term in recentSearches) {
      if (term.toLowerCase().contains(query) && !suggestions.contains(term)) {
        suggestions.add(term);
        if (suggestions.length >= 15) break;
      }
    }
  }

  void _sortSuggestionsByRelevance(String query, List<String> suggestions) {
    suggestions.sort((a, b) {
      final aStartsWith = a.toLowerCase().startsWith(query);
      final bStartsWith = b.toLowerCase().startsWith(query);

      if (aStartsWith && !bStartsWith) return -1;
      if (!aStartsWith && bStartsWith) return 1;
      return a.length.compareTo(b.length);
    });
  }

  //-----------------------------------------------------------------------------------
  // FILTER METHODS
  //-----------------------------------------------------------------------------------

  List<ProductModel> applyFilters(List<ProductModel> results) {
    if (results.isEmpty) return [];

    var filtered = _applyCategoryFilter(results);
    filtered = _applyBrandFilter(filtered);
    filtered = _applyPriceFilter(filtered);

    return filtered;
  }

  List<ProductModel> _applyCategoryFilter(List<ProductModel> results) {
    if (results.isEmpty) return [];
    if (selectedCategory.value == 'Tất cả' ||
        selectedCategory.value == 'Tất cả sản phẩm') {
      return [...results];
    }

    final selectedCategoryId = categoryNameToIdMap[selectedCategory.value];

    if (selectedCategoryId != null) {
      return results.where((product) {
        bool match = product.categoryId == selectedCategoryId;

        if (!match) {
          final categoryNameLower = selectedCategory.value.toLowerCase();
          match = product.title.toLowerCase().contains(categoryNameLower) ||
              (product.description != null &&
                  product.description!
                      .toLowerCase()
                      .contains(categoryNameLower));
        }

        return match;
      }).toList();
    } else {
      final categoryNameLower = selectedCategory.value.toLowerCase();
      return results.where((product) {
        return product.title.toLowerCase().contains(categoryNameLower) ||
            (product.description != null &&
                product.description!.toLowerCase().contains(categoryNameLower));
      }).toList();
    }
  }

  List<ProductModel> _applyBrandFilter(List<ProductModel> results) {
    if (results.isEmpty) return [];
    if (selectedBrand.value == 'Tất cả') return [...results];

    return results
        .where((product) => product.brand?.name == selectedBrand.value)
        .toList();
  }

  List<ProductModel> _applyPriceFilter(List<ProductModel> results) {
    if (results.isEmpty) return [];

    return results
        .where((product) =>
            product.price >= minPrice.value && product.price <= maxPrice.value)
        .toList();
  }

  //-----------------------------------------------------------------------------------
  // SORTING METHODS
  //-----------------------------------------------------------------------------------

  Future<List<ProductModel>> applySorting(List<ProductModel> results) async {
    if (results.isEmpty) return [];
    if (selectedSort.value == 0) return results;

    var sorted = [...results];

    switch (selectedSort.value) {
      case 1: // Giá thấp đến cao
        sorted.sort((a, b) => a.price.compareTo(b.price));
        break;

      case 2: // Giá cao đến thấp
        sorted.sort((a, b) => b.price.compareTo(a.price));
        break;

      case 3:
        _sortByBestSelling(sorted);
        break;

      case 4: // Đánh giá cao nhất
        await _sortByHighestRating(sorted);
        break;

      case 5: // Giảm giá cao nhất
        _sortByHighestDiscount(sorted);
        break;
    }

    return sorted;
  }

  Future<void> _sortByHighestRating(List<ProductModel> sorted) async {
    if (sorted.isEmpty) return;

    try {
      // Lấy danh sách ID sản phẩm
      final productIds = sorted.map((p) => p.id).toList();

      // Kiểm tra xem có sản phẩm nào đã có trong cache không
      final List<String> idsToFetch = [];
      final Map<String, double> ratingsFromCache = {};

      // Tách các ID cần lấy từ server và ID đã có trong cache
      for (var id in productIds) {
        if (_ratingsCache.containsKey(id)) {
          ratingsFromCache[id] = _ratingsCache[id]!;
        } else {
          idsToFetch.add(id);
        }
      }

      // Lấy đánh giá cho các sản phẩm chưa có trong cache
      final Map<String, double> newRatings = idsToFetch.isEmpty
          ? {}
          : await _productRepository.getProductsAverageRatings(idsToFetch);

      // Kết hợp kết quả mới và cache
      final Map<String, double> allRatings = {
        ...ratingsFromCache,
        ...newRatings
      };

      // Cập nhật cache với dữ liệu mới
      _ratingsCache.addAll(newRatings);

      // Tối ưu sắp xếp bằng cách không phân chia lại danh sách
      sorted.sort((a, b) {
        final ratingA = allRatings[a.id] ?? 0.0;
        final ratingB = allRatings[b.id] ?? 0.0;

        // Ưu tiên sản phẩm có đánh giá
        if (ratingA > 0 && ratingB == 0) return -1;
        if (ratingA == 0 && ratingB > 0) return 1;

        return ratingB.compareTo(ratingA);
      });
    } catch (e) {
      // Trường hợp lỗi, vẫn giữ nguyên thứ tự
      debugPrint('Lỗi khi sắp xếp theo đánh giá: $e');
    }
  }

  void _sortByHighestDiscount(List<ProductModel> sorted) {
    sorted.sort((a, b) {
      double discountPercentA = _calculateDiscountPercent(a);
      double discountPercentB = _calculateDiscountPercent(b);
      return discountPercentB.compareTo(discountPercentA);
    });
  }

  double _calculateDiscountPercent(ProductModel product) {
    if (product.price > 0 &&
        product.salePrice > 0 &&
        product.salePrice < product.price) {
      return ((product.price - product.salePrice) / product.price) * 100;
    }
    return 0.0;
  }

  void _sortByBestSelling(List<ProductModel> sorted) {
    sorted.sort((a, b) => b.soldQuantity.compareTo(a.soldQuantity));
  }

  //-----------------------------------------------------------------------------------
  // CATEGORY FILTER METHODS
  //-----------------------------------------------------------------------------------

  Future<void> applyFiltersByCategory() async {
    if (selectedCategory.value == 'Tất cả' ||
        selectedCategory.value == 'Tất cả sản phẩm') {
      if (searchTextController.text.isNotEmpty) {
        searchProducts();
      } else if (originalResults.isNotEmpty) {
        await _reapplyFiltersWithoutCategory();
      }
      return;
    }

    isLoading.value = true;

    try {
      final selectedCategoryId = categoryNameToIdMap[selectedCategory.value];
      if (selectedCategoryId == null) {
        searchResults.clear();
        return;
      }

      final searchQuery = searchTextController.text.trim();
      List<ProductModel> categoryProducts = await _productRepository
          .getProductsForCategory(categoryId: selectedCategoryId, limit: -1);

      if (searchQuery.isNotEmpty) {
        final queryLower = searchQuery.toLowerCase();
        categoryProducts = categoryProducts
            .where(
                (product) => product.title.toLowerCase().contains(queryLower))
            .toList();
      }

      originalResults.assignAll(categoryProducts);

      var filtered = _applyBrandFilter(categoryProducts);
      filtered = _applyPriceFilter(filtered);
      final sortedResults = await applySorting(filtered);
      searchResults.assignAll(sortedResults);
    } catch (e) {
      searchResults.clear();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _reapplyFiltersWithoutCategory() async {
    isLoading.value = true;

    try {
      var filtered = originalResults.toList();

      if (selectedBrand.value != 'Tất cả') {
        filtered = _applyBrandFilter(filtered);
      }

      filtered = _applyPriceFilter(filtered);
      final sortedResults = await applySorting(filtered);
      searchResults.assignAll(sortedResults);
    } catch (e) {
      // Xử lý lỗi nếu cần
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> reapplyFilters() async {
    if ((selectedCategory.value == 'Tất cả' ||
            selectedCategory.value == 'Tất cả sản phẩm') &&
        (selectedBrand.value == 'Tất cả') &&
        searchTextController.text.isNotEmpty) {
      searchProducts();
      return;
    }

    if (originalResults.isEmpty) {
      if (searchTextController.text.isNotEmpty) {
        searchProducts();
      }
      return;
    }

    isLoading.value = true;

    try {
      if (selectedCategory.value != 'Tất cả' &&
          selectedCategory.value != 'Tất cả sản phẩm') {
        await applyFiltersByCategory();
        return;
      }

      final filtered = applyFilters(originalResults);
      final sortedResults = await applySorting(filtered);
      searchResults.assignAll(sortedResults);
    } catch (e) {
      // Xử lý lỗi nếu cần
    } finally {
      isLoading.value = false;
    }
  }

  //-----------------------------------------------------------------------------------
  // DATA LOADING METHODS
  //-----------------------------------------------------------------------------------

  void loadCategories() async {
    try {
      // Đảm bảo CategoryRepository được đăng ký
      if (!Get.isRegistered<CategoryRepository>()) {
        Get.put(CategoryRepository(), permanent: true);
      }

      final categoryRepo = Get.find<CategoryRepository>();
      final categories = await categoryRepo.getAllCategories();

      debugPrint('Đã tải được ${categories.length} danh mục');

      // Kiểm tra nếu danh sách trống
      if (categories.isEmpty) {
        debugPrint('Danh sách danh mục trống');
        this.categories.value = ['Tất cả'];
        return;
      }

      categoryNameToIdMap.clear();
      categoryIdToNameMap.clear();

      for (var category in categories) {
        categoryNameToIdMap[category.name] = category.id;
        categoryIdToNameMap[category.id] = category.name;
      }

      final categoryNames =
          categories.map((category) => category.name).toList();
      allCategoryNames.assignAll(categoryNames);

      // Đảm bảo danh sách bắt đầu bằng "Tất cả"
      final updatedCategories = ['Tất cả', ...categoryNames];
      this.categories.assignAll(updatedCategories);

      debugPrint(
          'Đã cập nhật danh sách danh mục: ${this.categories.length} mục');
    } catch (e) {
      debugPrint('Lỗi khi tải danh mục: $e');
      // Đảm bảo luôn có ít nhất "Tất cả" trong danh sách
      this.categories.value = ['Tất cả'];
    }
  }

  void loadBrands() async {
    try {
      final brandRepo = Get.find<BrandRepository>();
      final brandsList = await brandRepo.getAllBrands();
      brands.value = ['Tất cả', ...brandsList.map((brand) => brand.name)];
    } catch (e) {
      // Xử lý lỗi nếu cần
    }
  }

  void loadProductTitles() async {
    try {
      final products = await _productRepository.getAllProducts();
      final titles = products.map((product) => product.title).toList();
      allProductTitles.assignAll(titles);
    } catch (e) {
      // Xử lý lỗi nếu cần
    }
  }

  void loadRecentSearches() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final searches = prefs.getStringList('recent_searches') ?? [];
      recentSearches.assignAll(searches);
    } catch (e) {
      // Xử lý lỗi nếu cần
    }
  }

  //-----------------------------------------------------------------------------------
  // RECENT SEARCHES MANAGEMENT
  //-----------------------------------------------------------------------------------

  void saveRecentSearch(String query) async {
    if (query.trim().isEmpty) return;

    try {
      if (recentSearches.contains(query)) {
        recentSearches.remove(query);
      }
      recentSearches.insert(0, query);
      if (recentSearches.length > 16) {
        recentSearches.removeLast();
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('recent_searches', recentSearches);
    } catch (e) {
      // Xử lý lỗi nếu cần
    }
  }

  void clearRecentSearches() async {
    try {
      recentSearches.clear();
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('recent_searches');
    } catch (e) {
      // Xử lý lỗi nếu cần
    }
  }

  //-----------------------------------------------------------------------------------
  // UTILITY METHODS
  //-----------------------------------------------------------------------------------

  void resetFilters() {
    final currentQuery = searchTextController.text;

    selectedCategory.value = 'Tất cả';
    selectedBrand.value = 'Tất cả';
    selectedCategoryImage.value = '';
    selectedBrandImage.value = '';
    minPrice.value = 0.0;
    maxPrice.value = 5000000.0;
    selectedSort.value = 0;

    if (currentQuery.isNotEmpty && originalResults.isNotEmpty) {
      reapplyFilters();
    }
  }

  void resetAll() {
    searchTextController.clear();
    searchResults.clear();
    originalResults.clear();
    autoSuggestions.clear();
    resetFilters();
    isLoading.value = false;
    isLoadingSuggestions.value = false;
    showFilter.value = false;
  }

  void toggleFilter() {
    showFilter.value = !showFilter.value;
  }
}
