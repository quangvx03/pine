import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pine_admin_panel/common/widgets/loaders/circular_loader.dart';
import 'package:pine_admin_panel/data/repositories/media_repository.dart';
import 'package:pine_admin_panel/features/media/screens/media/widgets/media_content.dart';
import 'package:pine_admin_panel/features/media/screens/media/widgets/media_uploader.dart';
import 'package:pine_admin_panel/utils/constants/image_strings.dart';
import 'package:pine_admin_panel/utils/constants/text_strings.dart';
import 'package:pine_admin_panel/utils/popups/dialogs.dart';
import 'package:pine_admin_panel/utils/popups/loaders.dart';
import 'package:universal_html/html.dart' as html;
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:get/get.dart';
import 'package:pine_admin_panel/utils/constants/enums.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/popups/full_screen_loader.dart';
import '../models/image_model.dart';

class MediaController extends GetxController {
  static MediaController get instance => Get.find();

  final RxBool loading = false.obs;

  final int initialLoadCount = 20;
  final int loadMoreCount = 25;

  late DropzoneViewController dropzoneController;
  final RxBool showImagesUploaderSection = false.obs;
  final Rx<MediaCategory> selectedPath = MediaCategory.folders.obs;
  final RxList<ImageModel> selectedImagesToUpload = <ImageModel>[].obs;

  final RxList<ImageModel> allImages = <ImageModel>[].obs;
  final RxList<ImageModel> allBannerImages = <ImageModel>[].obs;
  final RxList<ImageModel> allProductImages = <ImageModel>[].obs;
  final RxList<ImageModel> allBrandImages = <ImageModel>[].obs;
  final RxList<ImageModel> allCategoryImages = <ImageModel>[].obs;
  final RxList<ImageModel> allUserImages = <ImageModel>[].obs;

  final MediaRepository mediaRepository = MediaRepository();

  /// Get Images
  void getMediaImages() async {
    try {
      loading.value = true;

      RxList<ImageModel> targetList = _getTargetList();
      if (targetList.isEmpty) {
        final images = await mediaRepository.fetchImagesFromDatabase(selectedPath.value, initialLoadCount);
        targetList.addAll(images);
      }

      loading.value = false;
    } catch (e) {
      loading.value = false;
      PLoaders.errorSnackBar(title: 'Ôi không', message: 'Không thể lấy hình ảnh, đã xảy ra lỗi. Thử lại');
    }
  }

  /// Load More Images
  Future<void> loadMoreMediaImages() async {
    try {
      loading.value = true;

      RxList<ImageModel> targetList = _getTargetList();
      if (targetList.isNotEmpty) {
        final images = await mediaRepository.loadMoreImagesFromDatabase(
          selectedPath.value,
          loadMoreCount,
          targetList.last.createdAt ?? DateTime.now(),
        );
        targetList.addAll(images);
      }

      loading.value = false;
    } catch (e) {
      loading.value = false;
      PLoaders.errorSnackBar(title: 'Ôi không', message: 'Không thể tải thêm ảnh. Vui lòng thử lại.');
    }
  }

  /// Select Local Images on Button Press
  Future<void> selectLocalImages() async {
    final files = await dropzoneController.pickFiles(multiple: true, mime: ['image/jpeg', 'image/png']);
    if (files.isNotEmpty) {
      for (var file in files) {
        final bytes = await dropzoneController.getFileData(file);
        final filename = await dropzoneController.getFilename(file);
        final mimeType = await dropzoneController.getFileMIME(file);
        final image = ImageModel(
          url: '',
          folder: '',
          filename: filename,
          contentType: mimeType,
          localImageToDisplay: Uint8List.fromList(bytes),
        );
        selectedImagesToUpload.add(image);
      }
    }
  }

  void uploadImagesConfirmation() {
    if (selectedPath.value == MediaCategory.folders || selectedImagesToUpload.isEmpty) {
      PLoaders.warningSnackBar(title: 'Chọn tệp', message: 'Vui lòng chọn tệp ảnh để tải lên');
      return;
    }

    PDialogs.defaultDialog(
      context: Get.context!,
      title: 'Tải hình ảnh',
      confirmText: 'Tải',
      onConfirm: () async => await uploadImages(),
      content: 'Bạn có chắc muốn tải tất cả ảnh trong thư mục ${selectedPath.value.name.toUpperCase()}?',
    );
  }

  /// Upload Images
  Future<void> uploadImages() async {
    try {
      Get.back(); // close dialog
      uploadImagesLoader();

      MediaCategory selectedCategory = selectedPath.value;
      RxList<ImageModel> targetList = _getTargetList();

      for (int i = selectedImagesToUpload.length - 1; i >= 0; i--) {
        var selectedImage = selectedImagesToUpload[i];
        final ImageModel uploadedImage = await mediaRepository.uploadImageFileInStorage(
          fileData: selectedImage.localImageToDisplay!,
          mimeType: selectedImage.contentType ?? 'image/jpeg',
          path: getSelectedPath(),
          imageName: selectedImage.filename,
        );

        uploadedImage.mediaCategory = selectedCategory.name;
        final id = await mediaRepository.uploadImageFileInDatabase(uploadedImage);
        uploadedImage.id = id;
        selectedImagesToUpload.removeAt(i);
        targetList.add(uploadedImage);
      }

      PFullScreenLoader.stopLoading();
    } catch (e) {
      PFullScreenLoader.stopLoading();
      PLoaders.warningSnackBar(title: 'Lỗi tải ảnh', message: 'Đã xảy ra lỗi khi tải ảnh lên.');
    }
  }

  void uploadImagesLoader() {
    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (context) => PopScope(
        canPop: false,
        child: AlertDialog(
          title: const Text('Đang tải ảnh'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(PImages.uploadingImageIllustration, height: 300, width: 300),
              const SizedBox(height: PSizes.spaceBtwItems),
              const Text('Hãy ngồi yên, hình ảnh của bạn đang được tải lên...'),
            ],
          ),
        ),
      ),
    );
  }

  String getSelectedPath() {
    switch (selectedPath.value) {
      case MediaCategory.banners:
        return PTexts.bannersStoragePath;
      case MediaCategory.brands:
        return PTexts.brandsStoragePath;
      case MediaCategory.categories:
        return PTexts.categoriesStoragePath;
      case MediaCategory.products:
        return PTexts.productsStoragePath;
      case MediaCategory.users:
        return PTexts.usersStoragePath;
      default:
        return 'others';
    }
  }

  /// Popup Confirmation to remove cloud image
  void removeCloudImageConfirmation(ImageModel image) {
    PDialogs.defaultDialog(
      context: Get.context!,
      content: 'Bạn có chắc muốn xóa ảnh này không?',
      onConfirm: () {
        Get.back(); // Close dialog
        removeCloudImage(image);
      },
    );
  }

  void removeCloudImage(ImageModel image) async {
    try {
      Get.back(); // close confirmation
      Get.defaultDialog(
        title: '',
        barrierDismissible: false,
        backgroundColor: Colors.transparent,
        content: const PopScope(
          canPop: false,
          child: SizedBox(width: 150, height: 150, child: PCircularLoader()),
        ),
      );

      await mediaRepository.deleteFileFromStorage(image);
      _getTargetList().remove(image);
      update();

      PFullScreenLoader.stopLoading();
      PLoaders.successSnackBar(title: 'Đã xóa ảnh', message: 'Hình ảnh đã được xóa khỏi đám mây.');
    } catch (e) {
      PFullScreenLoader.stopLoading();
      PLoaders.errorSnackBar(title: 'Lỗi', message: e.toString());
    }
  }

  Future<List<ImageModel>?> selectImagesFromMedia({
    List<String>? selectedUrls,
    bool allowSelection = true,
    bool multipleSelection = false,
  }) async {
    showImagesUploaderSection.value = true;

    List<ImageModel>? selectedImages = await Get.bottomSheet<List<ImageModel>>(
      isScrollControlled: true,
      backgroundColor: PColors.primaryBackground,
      FractionallySizedBox(
        heightFactor: 1,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(PSizes.defaultSpace),
            child: Column(
              children: [
                const MediaUploader(),
                MediaContent(
                  allowSelection: allowSelection,
                  alreadySelectedUrls: selectedUrls ?? [],
                  allowMultipleSelection: multipleSelection,
                ),
              ],
            ),
          ),
        ),
      ),
    );

    return selectedImages;
  }

  /// Get correct RxList based on selected path
  RxList<ImageModel> _getTargetList() {
    switch (selectedPath.value) {
      case MediaCategory.banners:
        return allBannerImages;
      case MediaCategory.brands:
        return allBrandImages;
      case MediaCategory.categories:
        return allCategoryImages;
      case MediaCategory.products:
        return allProductImages;
      case MediaCategory.users:
        return allUserImages;
      default:
        return allImages;
    }
  }
}
