import 'package:get/get.dart';
import 'package:pine/data/repositories/category_repository.dart';
import 'package:pine/data/repositories/product_repository.dart';
import 'package:pine/features/shop/models/category_model.dart';
import 'package:pine/features/shop/models/product_model.dart';
import 'package:pine/utils/popups/loaders.dart';

class CategoryController extends GetxController {
  static CategoryController get instance => Get.find();

  final isLoading = false.obs;
  final _categoryRepository = Get.put(CategoryRepository());
  RxList<CategoryModel> allCategories = <CategoryModel>[].obs;
  RxList<CategoryModel> featuredCategories = <CategoryModel>[].obs;

  @override
  void onInit() {
    fetchCategories();
    super.onInit();
  }

  /// Load category data
  Future<void> fetchCategories() async {
    try {
      // Show loader while loading categories
      isLoading.value = true;

      // Fetch categories from data source (Firestore, API)
      final categories = await _categoryRepository.getAllCategories();

      // Update the categories list
      allCategories.assignAll(categories);

      // Filter featured categories
      featuredCategories.assignAll(allCategories
          .where((category) => category.isFeatured && category.parentId.isEmpty)
          .take(8)
          .toList());
    } catch (e) {
      PLoaders.errorSnackBar(title: 'Có lỗi xảy ra!', message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// Load selected category data
  Future<List<CategoryModel>> getSubCategories(String categoryId) async {
    try{
      final subCategories = await _categoryRepository.getSubCategories(categoryId);
      return subCategories;
    } catch(e){
      PLoaders.errorSnackBar(title: 'Có lỗi xảy ra!', message: e.toString());
      return [];
    }
  }

  /// Get Category or Sub-Category Products
  Future<List<ProductModel>> getCategoryProducts(
      {required String categoryId, int limit = 4}) async {
   try{
     final products = await ProductRepository.instance
         .getProductsForCategory(categoryId: categoryId, limit: limit);
     return products;
   } catch(e){
     PLoaders.errorSnackBar(title: 'Có lỗi xảy ra!', message: e.toString());
     return [];
   }
  }
}
