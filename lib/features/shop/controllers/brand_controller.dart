import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:pine/data/repositories/product_repository.dart';
import 'package:pine/features/shop/models/brand_model.dart';
import 'package:pine/features/shop/models/product_model.dart';
import 'package:pine/utils/popups/loaders.dart';

import '../../../data/repositories/brand_repository.dart';

class BrandController extends GetxController {
  /// Lấy instance của controller theo brandId, tạo mới nếu chưa tồn tại
  static BrandController getInstance(String brandId) {
    if (Get.isRegistered<BrandController>(tag: brandId)) {
      return Get.find<BrandController>(tag: brandId);
    } else {
      return Get.put(BrandController(), tag: brandId);
    }
  }

  // Danh sách sản phẩm của thương hiệu
  final RxList<ProductModel> brandProducts = <ProductModel>[].obs;

  // Biến quản lý trạng thái loading
  final RxBool isLoading = true.obs;
  final RxBool isLoadingMore = false.obs;

  // Biến quản lý phân trang
  DocumentSnapshot? lastDocument;
  final RxBool isLastPage = false.obs;
  final int productsPerPage = 10;

  // Biến quản lý sắp xếp
  final RxString selectedSortOption = 'A-Z'.obs;
  final RxInt actualProductCount = 0.obs;
  final Map<String, double> _ratingsCache = <String, double>{}.obs;

  // Danh sách thương hiệu
  final RxList<BrandModel> allBrands = <BrandModel>[].obs;
  final RxList<BrandModel> featuredBrands = <BrandModel>[].obs;

  // Repositories
  final brandRepository = Get.put(BrandRepository());
  final productRepository = ProductRepository.instance;

  @override
  void onInit() {
    getFeaturedBrands();
    super.onInit();
  }

  /// Lấy danh sách thương hiệu nổi bật (isFeatured = true)
  Future<void> getFeaturedBrands() async {
    try {
      isLoading.value = true;
      final brands = await brandRepository.getAllBrands();
      allBrands.assignAll(brands);
      featuredBrands.assignAll(
          allBrands.where((brand) => brand.isFeatured ?? false).take(4));
    } catch (e) {
      PLoaders.errorSnackBar(title: 'Có lỗi xảy ra!', message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// Lấy danh sách thương hiệu thuộc danh mục
  Future<List<BrandModel>> getBrandsForCategory(String categoryId) async {
    try {
      final brands = await brandRepository.getBrandsForCategory(categoryId);
      return brands;
    } catch (e) {
      PLoaders.errorSnackBar(title: 'Có lỗi xảy ra!', message: e.toString());
      return [];
    }
  }

  /// Lấy sản phẩm của thương hiệu với số lượng giới hạn
  /// Mặc định lấy 3 sản phẩm bán chạy nhất
  Future<List<ProductModel>> getBrandProducts(
      {required String brandId, int limit = 3}) async {
    try {
      isLoading.value = true;
      final products = await productRepository
          .getTopSellingProductsForBrand(brandId, limit: limit);
      return products;
    } catch (e) {
      PLoaders.errorSnackBar(title: 'Có lỗi xảy ra!', message: e.toString());
      return [];
    } finally {
      isLoading.value = false;
    }
  }

  /// Lấy số lượng sản phẩm thực tế của thương hiệu
  Future<void> fetchActualProductCount(String brandId) async {
    try {
      final query = FirebaseFirestore.instance
          .collection('Products')
          .where('Brand.Id', isEqualTo: brandId)
          .where('IsFeatured', isEqualTo: true);

      final querySnapshot = await query.get();
      actualProductCount.value = querySnapshot.docs.length;
    } catch (e) {
      print('Lỗi khi đếm sản phẩm: $e');
    }
  }

  /// Tải sản phẩm của thương hiệu với phân trang
  /// Nếu isInitial = true, sẽ tải lại từ đầu và xóa danh sách hiện tại
  Future<void> fetchBrandProductsPaginated({
    required String brandId,
    bool isInitial = false,
  }) async {
    try {
      if ((isLoadingMore.value || isLastPage.value) && !isInitial) return;

      if (isInitial) {
        isLoading.value = true;
        lastDocument = null;
        brandProducts.clear();
        isLastPage.value = false;
      } else {
        isLoadingMore.value = true;
      }

      final result = await productRepository.getPaginatedProducts(
        sortOption: selectedSortOption.value,
        limit: productsPerPage,
        lastDocument: lastDocument,
        brandId: brandId,
      );

      lastDocument = result['lastDocument'];
      isLastPage.value = result['isLastPage'];
      final List<ProductModel> newProducts = result['products'];

      if (isInitial) {
        brandProducts.assignAll(newProducts);
      } else {
        brandProducts.addAll(newProducts);
      }
    } catch (e) {
      PLoaders.errorSnackBar(title: 'Có lỗi xảy ra!', message: e.toString());
    } finally {
      if (isInitial) {
        isLoading.value = false;
      } else {
        isLoadingMore.value = false;
      }
    }
  }

  /// Thay đổi tiêu chí sắp xếp và tải lại dữ liệu
  void changeSortOption(String brandId, String sortOption) {
    if (selectedSortOption.value == sortOption) return;
    selectedSortOption.value = sortOption;
    fetchBrandProductsPaginated(brandId: brandId, isInitial: true);
  }

  /// Sắp xếp danh sách sản phẩm hiện tại theo tiêu chí
  /// Không tải lại dữ liệu từ server
  Future<void> sortProducts(String sortOption) async {
    selectedSortOption.value = sortOption;
    List<ProductModel> products = [...brandProducts];

    try {
      switch (sortOption) {
        case 'A-Z':
          products.sort((a, b) => a.title.compareTo(b.title));
          break;
        case 'Z-A':
          products.sort((a, b) => b.title.compareTo(a.title));
          break;
        case 'Giá cao':
          products.sort((a, b) {
            double displayPriceA = a.salePrice > 0 && a.salePrice < a.price
                ? a.salePrice
                : a.price;
            double displayPriceB = b.salePrice > 0 && b.salePrice < b.price
                ? b.salePrice
                : b.price;
            return displayPriceB.compareTo(displayPriceA);
          });
          break;
        case 'Giá thấp':
          products.sort((a, b) {
            double displayPriceA = a.salePrice > 0 && a.salePrice < a.price
                ? a.salePrice
                : a.price;
            double displayPriceB = b.salePrice > 0 && b.salePrice < b.price
                ? b.salePrice
                : b.price;
            return displayPriceA.compareTo(displayPriceB);
          });
          break;
        case 'Bán chạy':
          products.sort((a, b) => b.soldQuantity.compareTo(a.soldQuantity));
          break;
        case 'Giảm giá':
          products.sort((a, b) {
            double discountPercentA = 0;
            double discountPercentB = 0;

            if (a.price > 0 && a.salePrice > 0 && a.salePrice < a.price) {
              discountPercentA = ((a.price - a.salePrice) / a.price) * 100;
            }
            if (b.price > 0 && b.salePrice > 0 && b.salePrice < b.price) {
              discountPercentB = ((b.price - b.salePrice) / b.price) * 100;
            }

            return discountPercentB.compareTo(discountPercentA);
          });
          break;
        case 'Đánh giá':
          await _sortByRating(products);
          break;
        default:
          products.sort((a, b) => a.title.compareTo(b.title));
      }

      brandProducts.assignAll(products);
    } catch (e) {
      PLoaders.errorSnackBar(
          title: 'Lỗi sắp xếp', message: 'Có lỗi xảy ra khi sắp xếp sản phẩm');
    } finally {
      isLoading.value = false;
    }
  }

  /// Sắp xếp sản phẩm theo đánh giá trung bình
  /// Phương thức private được gọi từ sortProducts khi lựa chọn 'Đánh giá'
  Future<void> _sortByRating(List<ProductModel> products) async {
    try {
      if (products.isEmpty) return;

      final productIds = products.map((p) => p.id).toList();
      final List<String> idsToFetch = [];
      final Map<String, double> ratingsFromCache = {};

      // Tối ưu bằng cách chỉ lấy dữ liệu cho những sản phẩm chưa có trong cache
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
          : await productRepository.getProductsAverageRatings(idsToFetch);

      final Map<String, double> allRatings = {
        ...ratingsFromCache,
        ...newRatings
      };

      _ratingsCache.addAll(newRatings);

      products.sort((a, b) {
        final ratingA = allRatings[a.id] ?? 0.0;
        final ratingB = allRatings[b.id] ?? 0.0;

        // Ưu tiên sản phẩm có đánh giá
        if (ratingA > 0 && ratingB == 0) return -1;
        if (ratingA == 0 && ratingB > 0) return 1;

        return ratingB.compareTo(ratingA);
      });
    } catch (e) {
      print('Lỗi khi sắp xếp theo đánh giá: $e');
    }
  }

  /// Lấy 2 thương hiệu bán chạy nhất thuộc danh mục (cả danh mục con)
  /// Thương hiệu được sắp xếp theo tổng số lượng bán ra cao nhất
  Future<List<BrandModel>> getTopSellingBrandsForCategory(String categoryId,
      {int limit = 2}) async {
    try {
      isLoading.value = true;
      final brands = await brandRepository
          .getTopSellingBrandsForCategory(categoryId, limit: limit);
      return brands;
    } catch (e) {
      PLoaders.errorSnackBar(title: 'Có lỗi xảy ra!', message: e.toString());
      return [];
    } finally {
      isLoading.value = false;
    }
  }

  /// Lấy tất cả thương hiệu thuộc danh mục, được sắp xếp theo tổng số lượng bán ra
  /// Sử dụng trong trang danh mục con để hiển thị danh sách thương hiệu
  Future<List<BrandModel>> getAllBrandsForCategoryWithSales(
      String categoryId) async {
    try {
      isLoading.value = true;
      final brands =
          await brandRepository.getAllBrandsForCategoryWithSales(categoryId);
      return brands;
    } catch (e) {
      PLoaders.errorSnackBar(title: 'Có lỗi xảy ra!', message: e.toString());
      return [];
    } finally {
      isLoading.value = false;
    }
  }
}
