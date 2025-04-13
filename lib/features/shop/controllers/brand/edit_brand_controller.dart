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
  RxString imageURL = ''.obs;
  final isFeatured = false.obs;
  final name = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final repository = Get.put(BrandRepository());
  final List<CategoryModel> selectedCategories = <CategoryModel>[].obs;

  void init (BrandModel brand) {
    name.text = brand.name;
    isFeatured.value = brand.isFeatured;
    imageURL.value = brand.image;
    if(brand.brandCategories != null) {
      selectedCategories.addAll(brand.brandCategories ?? []);
    }
  }

  void toggleSelection(CategoryModel category) {
    if (selectedCategories.contains(category)) {
      selectedCategories.remove(category);
    } else {
      selectedCategories.add(category);
    }
  }

  Future<void> updateBrand(BrandModel brand) async {
    try {
      PFullScreenLoader.popUpCircular();
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        PFullScreenLoader.stopLoading();
        return;
      }
      if (!formKey.currentState!.validate()) {
        PFullScreenLoader.stopLoading();
        return;
      }

      bool isBrandUpdated = false;

      if (brand.image != imageURL.value || brand.name != name.text.trim() || brand.isFeatured != isFeatured.value) {
        isBrandUpdated = true;
        brand.image = imageURL.value;
        brand.name = name.text.trim();
        brand.isFeatured = isFeatured.value;
        brand.updatedAt = DateTime.now();
        await repository.updateBrand(brand);
      }

      await updateBrandCategories(brand);

      if (isBrandUpdated) await updateBrandInProducts(brand);

      BrandController.instance.updateItemFromLists(brand);

      PFullScreenLoader.stopLoading();
      PLoaders.successSnackBar(title: 'Thành công', message: 'Đã cập nhật thương hiệu thành công');

      update();
    } catch (e) {
      PFullScreenLoader.stopLoading();
      PLoaders.errorSnackBar(title: 'Ôi không', message: e.toString());
    }
  }


  void pickImage() async {
    final controller = Get.put(MediaController());
    List<ImageModel>? selectedImages = await controller.selectImagesFromMedia();

    if(selectedImages != null && selectedImages.isNotEmpty) {
      ImageModel selectedImage = selectedImages.first;
      imageURL.value = selectedImage.url;
    }
  }

  void resetFields() {
    loading(false);
    isFeatured(false);
    name.clear();
    imageURL.value = '';
    selectedCategories.clear();
  }

  updateBrandCategories(BrandModel brand) async {
    final brandCategories = await repository.getCategoriesOfSpecificBrand(brand.id);

    final selectedCategoryIds = selectedCategories.map((e) => e.id);

    final categoriesToRemove = brandCategories.where((existingCategory) => !selectedCategoryIds.contains(existingCategory.categoryId)).toList();

    for (var categoryToRemove in categoriesToRemove) {
      await BrandRepository.instance.deleteBrandCategory(categoryToRemove.id ?? '');
    }

    final newCategoriesToAdd = selectedCategories
    .where((newCategory) => !brandCategories.any((existingCategory) => existingCategory.categoryId == newCategory.id))
    .toList();

    for (var newCategory in newCategoriesToAdd) {
      var brandCategory = BrandCategoryModel(brandId: brand.id, categoryId: newCategory.id);
      brandCategory.id = await BrandRepository.instance.createBrandCategory(brandCategory);
    }

    brand.brandCategories!.assignAll(selectedCategories);
    BrandController.instance.updateItemFromLists(brand);
  }

  updateBrandInProducts(BrandModel brand) async {

  }
}