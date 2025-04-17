import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:pine/data/repositories/product_repository.dart';
import 'package:pine/features/shop/models/brand_model.dart';
import 'package:pine/features/shop/models/product_model.dart';
import 'package:pine/utils/popups/loaders.dart';

import '../../../data/repositories/brand_repository.dart';

class BrandController extends GetxController {
  static BrandController getInstance(String brandId) {
    if (Get.isRegistered<BrandController>(tag: brandId)) {
      return Get.find<BrandController>(tag: brandId);
    } else {
      return Get.put(BrandController(), tag: brandId);
    }
  }

  // Thêm biến để lưu trữ sản phẩm của thương hiệu
  final RxList<ProductModel> brandProducts = <ProductModel>[].obs;
  // Biến quản lý trạng thái loading
  final RxBool isLoading = true.obs;
  final RxBool isLoadingMore = false.obs;
  // Biến để quản lý phân trang
  DocumentSnapshot? lastDocument;
  final RxBool isLastPage = false.obs;
  final int productsPerPage = 10; // Số sản phẩm tải mỗi lần
  // Biến để quản lý sắp xếp - Thay đổi từ 'Tên' thành 'A-Z'
  final RxString selectedSortOption = 'A-Z'.obs;
  final RxInt actualProductCount = 0.obs;

  final RxList<BrandModel> allBrands = <BrandModel>[].obs;
  final RxList<BrandModel> featuredBrands = <BrandModel>[].obs;
  final brandRepository = Get.put(BrandRepository());
  final productRepository = ProductRepository.instance;

  @override
  void onInit() {
    getFeaturedBrands();
    super.onInit();
  }

  /// Load Brands
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

  /// Get Brands For Category
  Future<List<BrandModel>> getBrandsForCategory(String categoryId) async {
    try {
      final brands = await brandRepository.getBrandsForCategory(categoryId);
      return brands;
    } catch (e) {
      PLoaders.errorSnackBar(title: 'Có lỗi xảy ra!', message: e.toString());
      return [];
    }
  }

  // Phương thức cũ, giữ lại để tương thích
  Future<List<ProductModel>> getBrandProducts(
      {required String brandId, int limit = -1}) async {
    try {
      isLoading.value = true;
      final products = await productRepository.getProductsForBrand(
          brandId: brandId, limit: limit);

      // Lưu sản phẩm vào danh sách có thể quan sát
      brandProducts.assignAll(products);
      return products;
    } catch (e) {
      PLoaders.errorSnackBar(title: 'Có lỗi xảy ra!', message: e.toString());
      return [];
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchActualProductCount(String brandId) async {
    try {
      // Tạo truy vấn để đếm số sản phẩm thực tế
      final query = FirebaseFirestore.instance
          .collection('Products')
          .where('Brand.Id', isEqualTo: brandId)
          .where('IsFeatured', isEqualTo: true);

      // Lấy kết quả và cập nhật biến đếm
      final querySnapshot = await query.get();
      actualProductCount.value = querySnapshot.docs.length;
    } catch (e) {
      print('Lỗi khi đếm sản phẩm: $e');
    }
  }

  // Phương thức mới hỗ trợ lazy loading
  Future<void> fetchBrandProductsPaginated({
    required String brandId,
    bool isInitial = false,
  }) async {
    try {
      // Nếu đang tải hoặc đã tải hết sản phẩm (trừ khi là tải lại ban đầu)
      if ((isLoadingMore.value || isLastPage.value) && !isInitial) return;

      // Hiển thị loader tùy theo loại tải
      if (isInitial) {
        isLoading.value = true;
        // Reset lại trạng thái phân trang nếu là tải ban đầu
        lastDocument = null;
        brandProducts.clear();
        isLastPage.value = false;
      } else {
        isLoadingMore.value = true;
      }

      // Gọi repository để lấy dữ liệu phân trang
      final result = await productRepository.getPaginatedProducts(
        sortOption: selectedSortOption.value,
        limit: productsPerPage,
        lastDocument: lastDocument,
        brandId: brandId,
      );

      // Lưu document cuối cùng để phân trang tiếp theo
      lastDocument = result['lastDocument'];
      isLastPage.value = result['isLastPage'];

      // Thêm sản phẩm mới vào danh sách
      final List<ProductModel> newProducts = result['products'];

      if (isInitial) {
        brandProducts.assignAll(newProducts);
      } else {
        brandProducts.addAll(newProducts);
      }
    } catch (e) {
      PLoaders.errorSnackBar(title: 'Có lỗi xảy ra!', message: e.toString());
    } finally {
      // Cập nhật trạng thái loading
      if (isInitial) {
        isLoading.value = false;
      } else {
        isLoadingMore.value = false;
      }
    }
  }

  // Phương thức đổi tiêu chí sắp xếp và tải lại dữ liệu
  void changeSortOption(String brandId, String sortOption) {
    if (selectedSortOption.value == sortOption) return;
    selectedSortOption.value = sortOption;
    // Tải lại từ đầu với tiêu chí sắp xếp mới
    fetchBrandProductsPaginated(brandId: brandId, isInitial: true);
  }

  // Thêm phương thức mới để sắp xếp sản phẩm đã được tải về
  void sortProducts(String sortOption) {
    selectedSortOption.value = sortOption;
    List<ProductModel> products = [...brandProducts];

    switch (sortOption) {
      case 'A-Z':
        products.sort((a, b) => a.title.compareTo(b.title)); // Sắp xếp từ A-Z
        break;
      case 'Z-A':
        products.sort((a, b) => b.title.compareTo(a.title)); // Sắp xếp từ Z-A
        break;
      case 'Giá cao':
        products.sort((a, b) {
          // Lấy giá hiển thị (sau giảm giá nếu có)
          double displayPriceA =
              a.salePrice > 0 && a.salePrice < a.price ? a.salePrice : a.price;
          double displayPriceB =
              b.salePrice > 0 && b.salePrice < b.price ? b.salePrice : b.price;
          return displayPriceB
              .compareTo(displayPriceA); // Sắp xếp cao xuống thấp
        });
        break;
      case 'Giá thấp':
        products.sort((a, b) {
          // Lấy giá hiển thị (sau giảm giá nếu có)
          double displayPriceA =
              a.salePrice > 0 && a.salePrice < a.price ? a.salePrice : a.price;
          double displayPriceB =
              b.salePrice > 0 && b.salePrice < b.price ? b.salePrice : b.price;
          return displayPriceA.compareTo(displayPriceB); // Sắp xếp thấp lên cao
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

          // So sánh phần trăm giảm giá
          return discountPercentB.compareTo(discountPercentA);
        });
        break;
      default:
        products.sort((a, b) => a.title.compareTo(b.title));
    }

    // Cập nhật lại danh sách sản phẩm đã sắp xếp
    brandProducts.assignAll(products);
  }
}
