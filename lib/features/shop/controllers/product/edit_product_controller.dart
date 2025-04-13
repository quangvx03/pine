import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pine_admin_panel/data/repositories/product_repository.dart';
import 'package:pine_admin_panel/features/shop/controllers/category/category_controller.dart';
import 'package:pine_admin_panel/features/shop/controllers/product/product_attributes_controller.dart';
import 'package:pine_admin_panel/features/shop/controllers/product/product_controller.dart';
import 'package:pine_admin_panel/features/shop/controllers/product/product_images_controller.dart';
import 'package:pine_admin_panel/features/shop/controllers/product/product_variations_controller.dart';
import 'package:pine_admin_panel/features/shop/models/brand_model.dart';
import 'package:pine_admin_panel/features/shop/models/category_model.dart';
import 'package:pine_admin_panel/features/shop/models/product_category_model.dart';
import 'package:pine_admin_panel/features/shop/models/product_model.dart';
import 'package:pine_admin_panel/utils/constants/enums.dart';
import 'package:pine_admin_panel/utils/constants/image_strings.dart';
import 'package:pine_admin_panel/utils/helpers/network_manager.dart';
import 'package:pine_admin_panel/utils/popups/full_screen_loader.dart';
import 'package:pine_admin_panel/utils/popups/loaders.dart';

import '../../../../utils/constants/sizes.dart';

class EditProductController extends GetxController {
  static EditProductController get instance => Get.find();

  final isLoading = false.obs;
  final selectedCategoriesLoader = false.obs;
  final productType = ProductType.single.obs;
  final isFeatured = false.obs;

  final variationsController = Get.put(ProductVariationController());
  final attributesController = Get.put(ProductAttributesController());
  final imagesController = Get.put(ProductImagesController());
  final stockPriceFormKey = GlobalKey<FormState>();
  final productRepository = Get.put(ProductRepository());
  final titleDescriptionFormKey = GlobalKey<FormState>();

  TextEditingController title = TextEditingController();
  TextEditingController stock = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController salePrice = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController brandTextField = TextEditingController();

  final Rx<BrandModel?> selectedBrand = Rx<BrandModel?>(null);
  final RxList<CategoryModel> selectedCategories = <CategoryModel>[].obs;
  final List<CategoryModel> alreadyAddedCategories = <CategoryModel>[];

  RxBool thumbnailUploader = true.obs;
  RxBool additionalImagesUploader = true.obs;
  RxBool productDataUploader = false.obs;
  RxBool categoriesRelationshipUploader = false.obs;

  void initProductData(ProductModel product) {
    try {
      isLoading.value = true;
      title.text = product.title;
      description.text = product.description ?? '';
      productType.value = product.productType == ProductType.single.toString() ? ProductType.single : ProductType.variable;
      isFeatured.value = product.isFeatured;

      if (product.productType == ProductType.single.toString()) {
        stock.text = product.stock.toString();
        price.text = product.price.toString();
        salePrice.text = product.salePrice.toString();
      }

      selectedBrand.value = product.brand;
      brandTextField.text = product.brand?.name ?? '';

      if (product.images != null) {
        imagesController.selectedThumbnailImageUrl.value = product.thumbnail;
        imagesController.additionalProductImagesUrls.assignAll(product.images ?? []);
      }

      attributesController.productAttributes.assignAll(product.productAttributes ?? []);
      variationsController.productVariations.assignAll(product.productVariations ?? []);
      variationsController.initializeVariationControllers(product.productVariations ?? []);

      isLoading.value = false;
      update();

    } catch (e) {
      if (kDebugMode) print(e);
    }
  }

  // Chọn nhiều ảnh bổ sung
  void selectAdditionalImages(List<String> images) {
    final imagesController = ProductImagesController.instance;
    imagesController.additionalProductImagesUrls.addAll(images);
    update();
  }

// Xoá ảnh bổ sung theo index
  void removeAdditionalImage(int index) {
    final imagesController = ProductImagesController.instance;
    if (index >= 0 && index < imagesController.additionalProductImagesUrls.length) {
      imagesController.additionalProductImagesUrls.removeAt(index);
      update();
    }
  }

  Future<void> pickAdditionalImages() async {
    final imagesController = ProductImagesController.instance;
    // 👉 Giả sử bạn đã có logic chọn ảnh (ví dụ FilePicker hoặc imageUploader riêng)
    // Dưới đây là mô phỏng thêm ảnh URL (giả lập)
    List<String> newImages = [
      'https://via.placeholder.com/150', // Thay bằng ảnh thực tế khi chọn
      'https://via.placeholder.com/200'
    ];

    imagesController.additionalProductImagesUrls.addAll(newImages);
    update(); // để UI cập nhật
  }

  Future<List<CategoryModel>> loadSelectedCategories(String productId) async {
    selectedCategoriesLoader.value = true;
    final productCategories = await productRepository.getProductCategories(productId);
    final categoriesController = Get.put(CategoryController());
    if (categoriesController.allItems.isEmpty) await categoriesController.fetchItems();

    final categoriesIds = productCategories.map((e) => e.categoryId).toList();
    final categories = categoriesController.allItems.where((element) => categoriesIds.contains(element.id)).toList();
    selectedCategories.assignAll(categories);
    alreadyAddedCategories.assignAll(categories);
    selectedCategoriesLoader.value = false;
    return categories;
  }

  Future<void> editProduct(ProductModel product) async {
    try {
      showProgressDialog();

      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        PFullScreenLoader.stopLoading();
        return;
      }

      if (!titleDescriptionFormKey.currentState!.validate()) {
        PFullScreenLoader.stopLoading();
        return;
      }

      if (productType.value == ProductType.single && !stockPriceFormKey.currentState!.validate()) {
        PFullScreenLoader.stopLoading();
        return;
      }

      if (selectedBrand.value == null) throw 'Chọn thương hiệu cho sản phẩm';

      if (productType.value == ProductType.variable && ProductVariationController.instance.productVariations.isEmpty) {
        throw 'Không có thể loại nào cho Thể Loại Sản phẩm. Tạo một số thể loại hoặc thay đổi Loại Sản phẩm.';
      }
      if (productType.value == ProductType.variable) {
        final variationCheckFailed = ProductVariationController.instance.productVariations.any((element) =>
        element.price.isNaN ||
            element.price < 0 ||
            element.salePrice.isNaN ||
            element.salePrice < 0 ||
            element.stock.isNaN ||
            element.stock < 0,
        );
        if (variationCheckFailed) throw 'Dữ liệu thể loại không chính xác. Vui lòng kiểm tra lại các thể loại';
      }

      final imagesController = ProductImagesController.instance;
      if (imagesController.selectedThumbnailImageUrl.value == null || imagesController.selectedThumbnailImageUrl.value!.isEmpty) {
        throw 'Chọn ảnh đại diện sản phẩm';
      }

        var variations = ProductVariationController.instance.productVariations;
        if (productType.value == ProductType.single && variations.isNotEmpty) {
          ProductVariationController.instance.resetAllValues();
          variations.value = [];
        }

          product.sku = '';
          product.isFeatured = isFeatured.value;
          product.title = title.text.trim();
          product.brand = selectedBrand.value;
          product.productVariations = variations;
          product.description = description.text.trim();
          product.productType = productType.value.toString();
          product.stock = int.tryParse(stock.text.trim()) ?? 0;
          product.price = double.tryParse(price.text.trim()) ?? 0;
          product.images = imagesController.additionalProductImagesUrls;
          product.salePrice = double.tryParse(salePrice.text.trim()) ?? 0;
          product.thumbnail = imagesController.selectedThumbnailImageUrl.value ?? '';
          product.productAttributes = ProductAttributesController.instance.productAttributes;

          productDataUploader.value = true;
          await ProductRepository.instance.updateProduct(product);

          if (selectedCategories.isNotEmpty) {
            categoriesRelationshipUploader.value = true;
            List<String> existingCategoryIds = alreadyAddedCategories.map((
                category) => category.id).toList();

            for (var category in selectedCategories) {
              if (!existingCategoryIds.contains(category.id)) {
                final productCategory = ProductCategoryModel(
                    productId: product.id, categoryId: category.id);
                await ProductRepository.instance.createProductCategory(productCategory);
              }
            }

            for (var existingCategoryId in existingCategoryIds) {
              if (!selectedCategories.any((category) =>
              category.id == existingCategoryId)) {
                await ProductRepository.instance.removeProductCategory(
                    product.id, existingCategoryId);
              }
            }
          }
        ProductController.instance.updateItemFromLists(product);

        PFullScreenLoader.stopLoading();

        showCompletionDialog();

    } catch (e) {
      PFullScreenLoader.stopLoading();
      PLoaders.errorSnackBar(title: 'Ôi không', message: e.toString());
    }
  }

  void resetValues() {
    isLoading.value = false;
    productType.value = ProductType.single;
    isFeatured(false);
    stockPriceFormKey.currentState?.reset();
    titleDescriptionFormKey.currentState?.reset();
    title.clear();
    description.clear();
    stock.clear();
    price.clear();
    salePrice.clear();
    brandTextField.clear();
    selectedBrand.value = null;
    selectedCategories.clear();
    ProductVariationController.instance.resetAllValues();
    ProductAttributesController.instance.resetProductAttributes();

    thumbnailUploader.value = false;
    additionalImagesUploader.value = false;
    productDataUploader.value = false;
    categoriesRelationshipUploader.value = false;
  }

  void showProgressDialog() {
    showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (context) => PopScope(
          canPop: false,
          child: AlertDialog(
            title: const Text('Đang thêm sản phẩm'),
            content: Obx(
                    () => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(PImages.creatingProductIllustration, height: 200, width: 200),
                    const SizedBox(height: PSizes.spaceBtwItems),
                    buildCheckbox('Ảnh đại diện', thumbnailUploader),
                    buildCheckbox('Ảnh sản phẩm', additionalImagesUploader),
                    buildCheckbox('Thông tin sản phẩm', productDataUploader),
                    buildCheckbox('Danh mục sản phẩm', categoriesRelationshipUploader),
                    const SizedBox(height: PSizes.spaceBtwItems),
                    const Text('Đang thêm sản phẩm...'),
                  ],
                )
            ),
          ),
        )
    );
  }

  Widget buildCheckbox(String label, RxBool value) {
    return Row(
      children: [
        AnimatedSwitcher(
          duration: const Duration(seconds: 2),
          child: value.value
              ? const Icon(CupertinoIcons.checkmark_alt_circle_fill, color: Colors.green)
              : const Icon(CupertinoIcons.checkmark_alt_circle),
        ),
        const SizedBox(width: PSizes.spaceBtwItems),
        Text(label),
      ],
    );
  }

  void showCompletionDialog() {
    Get.dialog(
        AlertDialog(
          title: const Text('Thành công'),
          actions: [
            TextButton(
                onPressed: () {
                  Get.back();
                  Get.back();
                },
                child: const Text('Tới danh sách sản phẩm')
            )
          ],
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(PImages.productsIllustration, height: 200, width: 200),
              const SizedBox(height: PSizes.spaceBtwItems),
              Text('Thành công', style: Theme.of(Get.context!).textTheme.headlineSmall),
              const SizedBox(height: PSizes.spaceBtwItems),
              const Text('Đã cập nhật sản phẩm'),
            ],
          ),
        )
    );
  }

}