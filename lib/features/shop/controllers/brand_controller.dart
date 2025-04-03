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

  RxBool isLoading = true.obs;
  final RxList<BrandModel> allBrands = <BrandModel>[].obs;
  final RxList<BrandModel> featuredBrands = <BrandModel>[].obs;
  final brandRepository = Get.put(BrandRepository());

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

  Future<List<ProductModel>> getBrandProducts(
      {required String brandId, int limit = -1}) async {
    try {
      isLoading.value = true;
      final products = await ProductRepository.instance
          .getProductsForBrand(brandId: brandId, limit: limit);

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
}
