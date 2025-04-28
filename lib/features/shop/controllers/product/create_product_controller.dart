import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pine_admin_panel/data/repositories/product_repository.dart';
import 'package:pine_admin_panel/features/shop/controllers/product/product_attributes_controller.dart';
import 'package:pine_admin_panel/features/shop/controllers/product/product_controller.dart';
import 'package:pine_admin_panel/features/shop/controllers/product/product_images_controller.dart';
import 'package:pine_admin_panel/features/shop/controllers/product/product_variations_controller.dart';
import 'package:pine_admin_panel/features/shop/models/brand_model.dart';
import 'package:pine_admin_panel/features/shop/models/category_model.dart';
import 'package:pine_admin_panel/features/shop/models/product_category_model.dart';
import 'package:pine_admin_panel/features/shop/models/product_model.dart';
import 'package:pine_admin_panel/features/shop/models/product_variation_model.dart';
import 'package:pine_admin_panel/utils/constants/enums.dart';
import 'package:pine_admin_panel/utils/constants/image_strings.dart';
import 'package:pine_admin_panel/utils/helpers/network_manager.dart';
import 'package:pine_admin_panel/utils/popups/full_screen_loader.dart';
import 'package:pine_admin_panel/utils/popups/loaders.dart';
import 'package:universal_html/js.dart';

import '../../../../utils/constants/sizes.dart';

class CreateProductController extends GetxController {
  static CreateProductController get instance => Get.find();

  final isLoading = false.obs;
  final productType = ProductType.single.obs;
  final isFeatured = false.obs;

  final stockPriceFormKey = GlobalKey<FormState>();
  final titleDescriptionFormKey = GlobalKey<FormState>();

  final productRepository = Get.put(ProductRepository());

  TextEditingController title = TextEditingController();
  TextEditingController stock = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController salePrice = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController brandTextField = TextEditingController();

  final Rx<BrandModel?> selectedBrand = Rx<BrandModel?>(null);
  final RxList<CategoryModel> selectedCategories = <CategoryModel>[].obs;

  RxBool thumbnailUploader = false.obs;
  RxBool additionalImagesUploader = false.obs;
  RxBool productDataUploader = false.obs;
  RxBool categoriesRelationshipUploader = false.obs;

  Future<void> createProduct() async {
    if (isLoading.value) return;
    isLoading.value = true;
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

      final imagesController = ProductImagesController.instance;

      thumbnailUploader.value = true;
      if (imagesController.selectedThumbnailImageUrl.value == null) {
        throw 'Chọn ảnh đại diện sản phẩm';
      }

      additionalImagesUploader.value = true;

      double parsedPrice = double.tryParse(price.text.trim()) ?? 0;
      double parsedSalePrice = double.tryParse(salePrice.text.trim()) ?? 0;
      int parsedStock = int.tryParse(stock.text.trim()) ?? 0;

      List<ProductVariationModel> variations = [];

      if (productType.value == ProductType.variable) {
        variations = ProductVariationController.instance.productVariations;

        if (variations.isEmpty) {
          throw 'Không có thể loại nào cho Thể Loại Sản phẩm. Tạo một số thể loại hoặc thay đổi Loại Sản phẩm.';
        }

        final variationCheckFailed = variations.any((element) =>
        element.price.isNaN ||
            element.price < 0 ||
            element.salePrice.isNaN ||
            element.salePrice < 0 ||
            element.stock.isNaN ||
            element.stock < 0 ||
            element.image.value.isEmpty);

        if (variationCheckFailed) {
          throw 'Dữ liệu thể loại không chính xác. Vui lòng kiểm tra lại các thể loại';
        }

        int totalStock = 0;
        double minPrice = double.infinity;
        double maxPrice = -double.infinity;

        for (var variation in variations) {
          totalStock += variation.stock;
          if (variation.price < minPrice) minPrice = variation.price;
          if (variation.price > maxPrice) maxPrice = variation.price;
        }

        parsedStock = totalStock;
        price.text = "${minPrice.toStringAsFixed(2)} - ${maxPrice.toStringAsFixed(2)}";
        parsedPrice = 0;
      }

      final newRecord = ProductModel(
        id: '',
        sku: '',
        isFeatured: isFeatured.value,
        title: title.text.trim(),
        brand: selectedBrand.value,
        productVariations: variations,
        description: description.text.trim(),
        productType: productType.value.toString(),
        stock: parsedStock,
        price: parsedPrice,
        images: imagesController.additionalProductImagesUrls,
        salePrice: parsedSalePrice,
        thumbnail: imagesController.selectedThumbnailImageUrl.value ?? '',
        productAttributes: ProductAttributesController.instance.productAttributes,
        date: DateTime.now(),
      );

      productDataUploader.value = true;
      newRecord.id = await productRepository.createProduct(newRecord);

      if (selectedCategories.isNotEmpty) {
        if (newRecord.id.isEmpty) throw 'Lỗi lưu dữ liệu. Vui lòng thử lại';

        categoriesRelationshipUploader.value = true;
        for (var category in selectedCategories) {
          final productCategory = ProductCategoryModel(productId: newRecord.id, categoryId: category.id);
          await productRepository.createProductCategory(productCategory);
        }
      }

      ProductController.instance.addItemToLists(newRecord);

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
            ),
          ),
        ),
      ),
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
            child: const Text('Tới danh sách sản phẩm'),
          ),
        ],
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(PImages.productsIllustration, height: 200, width: 200),
            const SizedBox(height: PSizes.spaceBtwItems),
            Text('Thành công', style: Theme.of(Get.context!).textTheme.headlineSmall),
            const SizedBox(height: PSizes.spaceBtwItems),
            const Text('Đã thêm sản phẩm'),
          ],
        ),
      ),
    );
  }
}
