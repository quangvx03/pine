import 'package:get/get.dart';
import 'package:pine_admin_panel/features/media/controllers/media_controller.dart';
import 'package:pine_admin_panel/features/media/models/image_model.dart';
import 'package:pine_admin_panel/features/shop/models/product_variation_model.dart';

class ProductImagesController extends GetxController {
  static ProductImagesController get instance => Get.find();

  Rx<String?> selectedThumbnailImageUrl = Rx<String?>(null);
  final RxList<String> additionalProductImagesUrls = <String>[].obs;

  void selectThumbnailImage() async {
    final controller = Get.put(MediaController());
    List<ImageModel>? selectedImages = await controller.selectImagesFromMedia();

    if (selectedImages != null && selectedImages.isNotEmpty) {
      ImageModel selectedImage = selectedImages.first;
      selectedThumbnailImageUrl.value = selectedImage.url;
    }
  }

  void selectVariationImage(ProductVariationModel variation) async {
    final controller = Get.put(MediaController());
    List<ImageModel>? selectedImages = await controller.selectImagesFromMedia();

    if (selectedImages != null && selectedImages.isNotEmpty) {
      ImageModel selectedImage = selectedImages.first;
      variation.image.value = selectedImage.url;
    }
  }

  void selectMultipleProductImages() async {
    final controller = Get.put(MediaController());
    List<ImageModel>? selectedImages = await controller.selectImagesFromMedia(multipleSelection: true, selectedUrls: additionalProductImagesUrls);

    if (selectedImages != null && selectedImages.isNotEmpty) {
      additionalProductImagesUrls.assignAll(selectedImages.map((e) => e.url));
    }
  }

  Future<void> removeImage(int index) async {
    additionalProductImagesUrls.removeAt(index);
  }
}