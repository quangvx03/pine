import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:pine/features/shop/models/product_model.dart';
import 'package:pine/utils/constants/enums.dart';
import 'package:pine/utils/popups/loaders.dart';

import '../../../../data/repositories/product_repository.dart';

class ProductController extends GetxController {
  static ProductController get instance => Get.find();

  final isLoading = false.obs;
  final productRepository = Get.put(ProductRepository());
  RxList<ProductModel> featuredProducts = <ProductModel>[].obs;
  RxList<ProductModel> allProducts = <ProductModel>[].obs;
  final RxString selectedSortOption = 'Tên'.obs;

  @override
  void onInit() {
    fetchFeaturedProducts();
    super.onInit();
  }

  void fetchFeaturedProducts() async {
    try {
      // Show loader while loading Products
      isLoading.value = true;

      // Fetch Products
      final products = await productRepository.getFeaturedProducts();

      // Assign Products
      featuredProducts.assignAll(products);
    } catch (e) {
      PLoaders.errorSnackBar(title: 'Có lỗi xảy ra!', message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<List<ProductModel>> fetchAllFeaturedProducts() async {
    try {
      // Fetch Products
      final products = await productRepository.getAllFeaturedProducts();

      return products;
    } catch (e) {
      PLoaders.errorSnackBar(title: 'Có lỗi xảy ra!', message: e.toString());
      return [];
    }
  }

  Future<List<ProductModel>> fetchAllProducts() async {
    try {
      isLoading.value = true;
      final products = await productRepository.getAllProducts();
      allProducts.assignAll(products);
      sortProducts(selectedSortOption.value);
      return products;
    } catch (e) {
      PLoaders.errorSnackBar(title: 'Có lỗi xảy ra!', message: e.toString());
      return [];
    } finally {
      isLoading.value = false;
    }
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

  void sortProducts(String sortOption) {
    selectedSortOption.value = sortOption;
    List<ProductModel> products = [...allProducts];

    switch (sortOption) {
      case 'Tên':
        products.sort((a, b) => a.title.compareTo(b.title));
        break;
      case 'Giá cao':
        products.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'Giá thấp':
        products.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'Mới nhất':
        products.sort((a, b) => a.date!.compareTo(b.date!));
        break;
      case 'Giảm giá':
        products.sort((a, b) {
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
        products.sort((a, b) => a.title.compareTo(b.title));
    }

    allProducts.assignAll(products);
  }

  void assignProducts(List<ProductModel> products) {
    allProducts.assignAll(products);
    sortProducts('Tên');
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
