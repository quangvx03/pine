import 'package:diacritic/diacritic.dart';
import 'package:get/get.dart';
import 'package:pine_admin_panel/data/abstract/base_data_table_controller.dart';
import 'package:pine_admin_panel/data/repositories/brand_repository.dart';
import 'package:pine_admin_panel/features/shop/controllers/category/category_controller.dart';
import 'package:pine_admin_panel/features/shop/models/brand_model.dart';

class BrandController extends PBaseController<BrandModel> {
  static BrandController get instance => Get.find();

  final _brandRepository = Get.put(BrandRepository());
  final categoryController = Get.put(CategoryController());

  RxList<BrandModel> filteredItems = <BrandModel>[].obs;
  void updateFilteredItems(List<BrandModel> updatedItems) {
    filteredItems.value = updatedItems;
    update();
  }


  @override
  Future<List<BrandModel>> fetchItems() async {
    final fetchedBrands = await _brandRepository.getAllBrands();

    final fetchedBrandCategories = await _brandRepository.getAllBrandCategories();

    if(categoryController.allItems.isEmpty) await categoryController.fetchItems();

    for (var brand in fetchedBrands) {
      List<String> categoryIds = fetchedBrandCategories
          .where((brandCategory) => brandCategory.brandId == brand.id)
          .map((brandCategory) => brandCategory.categoryId)
          .toList();

      brand.brandCategories = categoryController.allItems.where((category) => categoryIds.contains(category.id)).toList();
    }

    return fetchedBrands;
  }

  @override
  bool containsSearchQuery(BrandModel item, String query) {
    final normalizedBrandName = removeDiacritics(item.name.toLowerCase());
    final normalizedQuery = removeDiacritics(query.toLowerCase());

    return normalizedBrandName.contains(normalizedQuery);
  }


  @override
  Future<void> deleteItem(BrandModel item) async {
    await _brandRepository.deleteBrand(item);
  }

  void sortByName(int sortColumnIndex, bool ascending) {
    sortByProperty(sortColumnIndex, ascending, (BrandModel brand) {
      return removeDiacritics(brand.name.toLowerCase());
    });
  }

  void sortByProductCount(int sortColumnIndex, bool ascending) {
    sortByProperty(sortColumnIndex, ascending, (BrandModel brand) {
      return brand.productsCount ?? 0;
    });
  }

  void sortByDate(int sortColumnIndex, bool ascending) {
    sortByProperty(sortColumnIndex, ascending, (BrandModel brand) {
      return brand.createdAt?.millisecondsSinceEpoch ?? 0;
    });
  }

}