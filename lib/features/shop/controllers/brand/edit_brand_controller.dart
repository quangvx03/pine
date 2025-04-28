import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pine_admin_panel/data/repositories/brand_repository.dart';
import 'package:pine_admin_panel/features/shop/models/brand_category_model.dart';
import 'package:pine_admin_panel/features/shop/models/brand_model.dart';

import '../../../../utils/helpers/network_manager.dart';
import '../../../../utils/popups/full_screen_loader.dart';
import '../../../../utils/popups/loaders.dart';
import '../../../media/controllers/media_controller.dart';
import '../../../media/models/image_model.dart';
import '../../models/category_model.dart';
import 'brand_controller.dart';

class EditBrandController extends GetxController {
  static EditBrandController get instance => Get.find();

  final loading = false.obs;
  final isFeatured = false.obs;
  final imageURL = ''.obs;
  final name = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final selectedCategories = <CategoryModel>[].obs;

  final repository = Get.put(BrandRepository());

  void init(BrandModel brand) {
    resetFields();

    name.text = brand.name;
    isFeatured.value = brand.isFeatured;
    imageURL.value = brand.image;

    if (brand.brandCategories != null) {
      selectedCategories.addAll(brand.brandCategories!);
    }
  }

  void toggleSelection(CategoryModel category) {
    selectedCategories.contains(category)
        ? selectedCategories.remove(category)
        : selectedCategories.add(category);
  }

  void pickImage() async {
    final mediaController = Get.put(MediaController());
    final selectedImages = await mediaController.selectImagesFromMedia();

    if (selectedImages != null && selectedImages.isNotEmpty) {
      imageURL.value = selectedImages.first.url;
    }
  }

  Future<void> updateBrand(BrandModel brand) async {
    try {
      PFullScreenLoader.popUpCircular();

      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected || !formKey.currentState!.validate()) {
        PFullScreenLoader.stopLoading();
        return;
      }

      bool isUpdated = false;

      if (brand.image != imageURL.value ||
          brand.name != name.text.trim() ||
          brand.isFeatured != isFeatured.value) {
        brand
          ..image = imageURL.value
          ..name = name.text.trim()
          ..isFeatured = isFeatured.value
          ..updatedAt = DateTime.now();

        await repository.updateBrand(brand);

        isUpdated = true;
      }

      await _updateBrandCategories(brand);

      final index = BrandController.instance.allItems.indexWhere((item) => item.id == brand.id);
      if (index != -1) {
      BrandController.instance.allItems[index] = brand;
      BrandController.instance.update();
    }
      final updatedBrands = await BrandController.instance.fetchItems();
      BrandController.instance.updateFilteredItems(updatedBrands);

    PFullScreenLoader.stopLoading();
      PLoaders.successSnackBar(title: 'Thành công', message: 'Đã cập nhật thương hiệu thành công');
      update();
    } catch (e) {
      PFullScreenLoader.stopLoading();
      PLoaders.errorSnackBar(title: 'Ôi không', message: e.toString());
    }
  }


  Future<void> _updateBrandCategories(BrandModel brand) async {
    final existing = await repository.getCategoriesOfSpecificBrand(brand.id);
    final selectedIds = selectedCategories.map((e) => e.id).toSet();

    if (existing.isNotEmpty) {
      for (var c in existing.where((e) => !selectedIds.contains(e.categoryId))) {
        await repository.deleteBrandCategory(c.id ?? '');
      }
    }

    if (selectedCategories.isNotEmpty) {
      for (var newCat in selectedCategories.where((e) => !existing.any((ex) => ex.categoryId == e.id))) {
        final newEntry = BrandCategoryModel(brandId: brand.id, categoryId: newCat.id);
        newEntry.id = await repository.createBrandCategory(newEntry);
      }
    }

    brand.brandCategories = [...selectedCategories];
  }


  void resetFields() {
    loading.value = false;
    isFeatured.value = false;
    imageURL.value = '';
    name.clear();
    selectedCategories.clear();
  }
}
