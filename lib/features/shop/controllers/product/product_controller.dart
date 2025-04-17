import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:pine/features/shop/models/product_model.dart';
import 'package:pine/utils/constants/enums.dart';
import 'package:pine/utils/popups/loaders.dart';

import '../../../../data/repositories/product_repository.dart';

class ProductController extends GetxController {
  static ProductController get instance => Get.find();

  final isLoading = false.obs;
  final isLoadingMore = false.obs;
  final productRepository = Get.put(ProductRepository());
  RxList<ProductModel> suggestProducts = <ProductModel>[].obs;
  RxList<ProductModel> allProducts = <ProductModel>[].obs;
  final RxString selectedSortOption = 'A-Z'.obs;

  // Biến để quản lý phân trang
  DocumentSnapshot? lastDocument;
  final isLastPage = false.obs;
  final int productsPerPage = 10;

  // Biến để lưu trữ id của danh mục hoặc thương hiệu khi cần lọc
  final RxString categoryId = ''.obs;
  final RxString brandId = ''.obs;

  @override
  void onInit() {
    fetchSuggestProducts();
    super.onInit();
  }

  void fetchSuggestProducts() async {
    try {
      isLoading.value = true;
      final products = await productRepository.getSuggestProducts();
      suggestProducts.assignAll(products);
    } catch (e) {
      PLoaders.errorSnackBar(title: 'Có lỗi xảy ra!', message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // Thiết lập lọc theo danh mục và thương hiệu
  void setFilterParameters({String? newCategoryId, String? newBrandId}) {
    if (newCategoryId != null) categoryId.value = newCategoryId;
    if (newBrandId != null) brandId.value = newBrandId;

    // Reset lại trạng thái phân trang khi thay đổi bộ lọc
    lastDocument = null;
    isLastPage.value = false;
    allProducts.clear();
  }

  // Phương thức mới để tải sản phẩm với lazy loading
  Future<void> fetchProductsPaginated({bool isInitial = false}) async {
    try {
      // Nếu đang tải hoặc đã tải hết sản phẩm (trừ khi là tải lại ban đầu)
      if ((isLoadingMore.value || isLastPage.value) && !isInitial) return;

      // Hiển thị loader tùy theo loại tải
      if (isInitial) {
        isLoading.value = true;
        // Reset lại trạng thái phân trang nếu là tải ban đầu
        lastDocument = null;
        allProducts.clear();
        isLastPage.value = false;
      } else {
        isLoadingMore.value = true;
      }

      // Gọi repository để lấy dữ liệu phân trang
      final result = await productRepository.getPaginatedProducts(
        sortOption: selectedSortOption.value,
        limit: productsPerPage,
        lastDocument: lastDocument,
        brandId: brandId.value.isEmpty ? null : brandId.value,
        categoryId: categoryId.value.isEmpty ? null : categoryId.value,
      );

      // Lưu document cuối cùng để phân trang tiếp theo
      lastDocument = result['lastDocument'];
      isLastPage.value = result['isLastPage'];

      // Thêm sản phẩm mới vào danh sách
      final List<ProductModel> newProducts = result['products'];

      if (isInitial) {
        allProducts.assignAll(newProducts);
      } else {
        allProducts.addAll(newProducts);
      }
    } catch (e) {
      PLoaders.errorSnackBar(title: 'Có lỗi xảy ra!', message: e.toString());
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  // Phương thức đổi tiêu chí sắp xếp và tải lại dữ liệu
  void changeSortOption(String sortOption) {
    if (selectedSortOption.value == sortOption) return;
    selectedSortOption.value = sortOption;
    // Tải lại từ đầu với tiêu chí sắp xếp mới
    fetchProductsPaginated(isInitial: true);
  }

  Future<List<ProductModel>> fetchProductsByQuery(Query? query) async {
    try {
      if (query == null) return [];

      final products = await productRepository.fetchProductsByQuery(query);
      return products;
    } catch (e) {
      PLoaders.errorSnackBar(title: 'Có lỗi xảy ra', message: e.toString());
      return [];
    }
  }

  // Phương thức sắp xếp cũ, giữ lại để tương thích với code hiện tại
  // (không dùng cho infinite scrolling)
  void sortProducts(String sortOption) {
    selectedSortOption.value = sortOption;
    List<ProductModel> products = [...allProducts];

    switch (sortOption) {
      case 'A-Z':
        products.sort((a, b) => a.title.compareTo(b.title));
        break;
      case 'Z-A':
        products.sort((a, b) => b.title.compareTo(a.title));
        break;
      case 'Giá cao':
        products.sort((a, b) {
          double displayPriceA =
              a.salePrice > 0 && a.salePrice < a.price ? a.salePrice : a.price;
          double displayPriceB =
              b.salePrice > 0 && b.salePrice < b.price ? b.salePrice : b.price;
          return displayPriceB.compareTo(displayPriceA);
        });
        break;
      case 'Giá thấp':
        products.sort((a, b) {
          double displayPriceA =
              a.salePrice > 0 && a.salePrice < a.price ? a.salePrice : a.price;
          double displayPriceB =
              b.salePrice > 0 && b.salePrice < b.price ? b.salePrice : b.price;
          return displayPriceA.compareTo(displayPriceB);
        });
        break;
      case 'Giảm giá':
        products.sort((a, b) {
          // Tính phần trăm giảm giá cho cả hai sản phẩm
          double discountPercentA = 0;
          double discountPercentB = 0;

          // Chỉ tính khi có giá sale và giá gốc hợp lệ
          if (a.price > 0 && a.salePrice > 0 && a.salePrice < a.price) {
            discountPercentA = ((a.price - a.salePrice) / a.price) * 100;
          }

          if (b.price > 0 && b.salePrice > 0 && b.salePrice < b.price) {
            discountPercentB = ((b.price - b.salePrice) / b.price) * 100;
          }

          // Sắp xếp theo phần trăm giảm giá giảm dần (lớn nhất lên đầu)
          return discountPercentB.compareTo(discountPercentA);
        });
        break;
      default:
        products.sort((a, b) => a.title.compareTo(b.title));
    }

    allProducts.assignAll(products);
  }

  void assignProducts(List<ProductModel> products) {
    allProducts.assignAll(products);
    sortProducts('A-Z');
  }

  // Xóa bộ lọc và thiết lập lại giá trị mặc định
  void clearFilters() {
    categoryId.value = '';
    brandId.value = '';
    selectedSortOption.value = 'A-Z';
    lastDocument = null;
    isLastPage.value = false;
    allProducts.clear();
  }

  /// Get price or price range for variations
  String getProductPrice(ProductModel product) {
    double smallestPrice = double.infinity;
    double largestPrice = 0;

    // If no variations exits, return the simple price or sale price
    if (product.productType == ProductType.single.toString()) {
      return (product.salePrice > 0 ? product.salePrice : product.price)
          .toString();
    } else {
      // Calculate the smallest and largest prices among variations
      for (var variation in product.productVariations!) {
        // Determine the price to consider (sale price if available, otherwise regular price)
        double priceToConsider =
            variation.salePrice > 0 ? variation.salePrice : variation.price;

        // Update smallest and largest prices
        if (priceToConsider < smallestPrice) {
          smallestPrice = priceToConsider;
        }

        if (priceToConsider > largestPrice) {
          largestPrice = priceToConsider;
        }
      }

      // If smallest and largest prices are the same, return a single price
      if (smallestPrice.isEqual(largestPrice)) {
        return largestPrice.toString();
      } else {
        // Otherwise, return a price range
        return '$smallestPrice - $largestPrice';
      }
    }
  }

  /// Calculate Discount Percentage
  String? calculateSalePercentage(double originalPrice, double? salePrice) {
    if (salePrice == null || salePrice <= 0) return null;
    if (originalPrice <= 0 || originalPrice <= salePrice) return null;

    double percentage = ((originalPrice - salePrice) / originalPrice) * 100;
    return percentage.toStringAsFixed(0);
  }

  /// Lấy số lượng tồn kho thực tế của sản phẩm
  int getProductAvailableStock(int stock, int soldQuantity) {
    return stock - (soldQuantity);
  }

  /// Kiểm tra trạng thái tồn kho và trả về chuỗi hiển thị với số lượng
  String getFormattedStockStatus(int stock, int soldQuantity) {
    final availableStock = getProductAvailableStock(stock, soldQuantity);
    return availableStock > 0 ? 'Còn hàng ($availableStock)' : 'Hết hàng';
  }

  /// Kiểm tra sản phẩm còn hàng hay không
  bool isProductInStock(int stock, int soldQuantity) {
    return getProductAvailableStock(stock, soldQuantity) > 0;
  }
}
