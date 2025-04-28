import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pine_admin_panel/data/abstract/base_data_table_controller.dart';
import 'package:pine_admin_panel/data/repositories/category_repository.dart';
import 'package:pine_admin_panel/utils/constants/sizes.dart';
import 'package:pine_admin_panel/utils/popups/full_screen_loader.dart';
import 'package:pine_admin_panel/utils/popups/loaders.dart';

import '../../models/category_model.dart';

class CategoryController extends PBaseController<CategoryModel> {
  static CategoryController get instance => Get.find();

  final _categoryRepository = Get.put(CategoryRepository());

  @override
  bool containsSearchQuery(CategoryModel item, String query) {
    return item.name.toLowerCase().contains(query.toLowerCase());
  }

  @override
  Future<void> deleteItem(CategoryModel item) async {
    await _categoryRepository.deleteCategory(item.id);
  }

  @override
  Future<List<CategoryModel>> fetchItems() async {
    return await _categoryRepository.getAllCategories();
  }

  void sortByName(int sortColumnIndex, bool ascending) {
    sortByProperty(sortColumnIndex, ascending, (CategoryModel category) {
      return removeDiacritics(category.name.toLowerCase());
    });
  }

  void sortByDate(int sortColumnIndex, bool ascending) {
    sortByProperty(sortColumnIndex, ascending, (CategoryModel category) {
      return category.createdAt?.millisecondsSinceEpoch ?? 0;
    });
  }

}