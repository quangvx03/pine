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

      RxList<ImageModel> targetList = <ImageModel>[].obs;

      if (selectedPath.value == MediaCategory.banners && allBannerImages.isEmpty) {
        targetList = allBannerImages;
      } else if (selectedPath.value == MediaCategory.brands && allBrandImages.isEmpty) {
        targetList = allBrandImages;
      } else if (selectedPath.value == MediaCategory.categories && allCategoryImages.isEmpty) {
        targetList = allCategoryImages;
      } else if (selectedPath.value == MediaCategory.products && allProductImages.isEmpty) {
        targetList = allProductImages;
      } else if (selectedPath.value == MediaCategory.users && allUserImages.isEmpty) {
        targetList = allUserImages;
      }

      final images = await mediaRepository.fetchImagesFromDatabase(selectedPath.value, initialLoadCount);
      targetList.assignAll(images);

      loading.value = false;
    } catch (e) {
      loading.value = false;
      PLoaders.errorSnackBar(title: 'Ôi không', message: 'Không thể lấy hình ảnh, đã xảy ra lỗi. Thử lại');
    }
  }

  /// Load More Images
  loadMoreMediaImages() async {
    try {
      loading.value = true;

      RxList<ImageModel> targetList = <ImageModel>[].obs;

      if (selectedPath.value == MediaCategory.banners && allBannerImages.isEmpty) {
        targetList = allBannerImages;
      } else if (selectedPath.value == MediaCategory.brands && allBrandImages.isEmpty) {
        targetList = allBrandImages;
      } else if (selectedPath.value == MediaCategory.categories && allCategoryImages.isEmpty) {
        targetList = allCategoryImages;
      } else if (selectedPath.value == MediaCategory.products && allProductImages.isEmpty) {
        targetList = allProductImages;
      } else if (selectedPath.value == MediaCategory.users && allUserImages.isEmpty) {
        targetList = allUserImages;
      }

      final images = await mediaRepository.loadMoreImagesFromDatabase(
          selectedPath.value, initialLoadCount, targetList.last.createdAt ?? DateTime.now());
      targetList.assignAll(images);

      loading.value = false;
    } catch (e) {
      loading.value = false;
      PLoaders.errorSnackBar(title: 'Ôi không', message: 'Không thể lấy hình ảnh, đã xảy ra lỗi. Thử lại');
    }
  }

  /// Select Local Images on Button Press
  Future<void> selectLocalImages() async {
    final files = await dropzoneController.pickFiles(multiple: true, mime: ['image/jpeg', 'image/png']);
    if (files.isNotEmpty) {
      for (var file in files) {
        // Retrieve file data as Uint8List
        final bytes = await dropzoneController.getFileData(file);
        // Extract file metadata
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
    if (selectedPath.value == MediaCategory.folders) {
      PLoaders.warningSnackBar(title: 'Chọn tệp', message: 'Vui lòng chọn tệp ảnh để tải lên');
      return;
    }

    PDialogs.defaultDialog(
        context: Get.context!,
      title: 'Tải hình ảnh',
      confirmText: 'Tải',
      onConfirm: () async => await uploadImages(),
      content: 'Bạn có chắc muốn tải tất cả ảnh trong ${selectedPath.value.name.toUpperCase()} thư mục?',
    );
  }

  /// Upload Images
  Future<void> uploadImages() async {
    try {
      // Remove confirmation box
      Get.back();
      // Start Loader
      uploadImagesLoader();
      // Get the selected category
      MediaCategory selectedCategory = selectedPath.value;
      // Get the corresponding list to update
      RxList<ImageModel> targetList;
      // Check the selected category and update the corresponding list
      switch (selectedCategory) {
        case MediaCategory.banners:
          targetList = allBannerImages;
          break;
        case MediaCategory.brands:
          targetList = allBrandImages;
          break;
        case MediaCategory.categories:
          targetList = allCategoryImages;
          break;
        case MediaCategory.products:
          targetList = allProductImages;
          break;
        case MediaCategory.users:
          targetList = allUserImages;
          break;
        default:
          return;
      }
      // Upload and add images to the target list
      // Using a reverse loop to avoid 'Concurrent modification during iteration' error
      for (int i = selectedImagesToUpload.length - 1; i >= 0; i--) {
        var selectedImage = selectedImagesToUpload[i];
        // Upload Image to the Storage
        final ImageModel uploadedImage = await mediaRepository.uploadImageFileInStorage(
          fileData: selectedImage.localImageToDisplay!,
          mimeType: selectedImage.contentType!,
          path: getSelectedPath(),
          imageName: selectedImage.filename,
        );
        // Upload Image to the Firestore
        uploadedImage.mediaCategory = selectedCategory.name;
        final id = await mediaRepository.uploadImageFileInDatabase(uploadedImage);
        uploadedImage.id = id;
        selectedImagesToUpload.removeAt(i);
        targetList.add(uploadedImage);
      }
      // Stop Loader after successful upload
      PFullScreenLoader.stopLoading();
    } catch (e) {
      // Stop Loader in case of an error
      PFullScreenLoader.stopLoading();
      // Show a warning snack-bar for the error
      PLoaders.warningSnackBar(title: 'Error Uploading Images', message: 'Something went wrong while uploading your images.');
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
            )
        )
    );
  }

  String getSelectedPath() {
    String path = '';
    switch (selectedPath.value) {
      case MediaCategory.banners:
        path = PTexts.bannersStoragePath;
        break;
      case MediaCategory.brands:
        path = PTexts.brandsStoragePath;
        break;
      case MediaCategory.categories:
        path = PTexts.categoriesStoragePath;
        break;
      case MediaCategory.products:
        path = PTexts.productsStoragePath;
        break;
      case MediaCategory.users:
        path = PTexts.usersStoragePath;
        break;
      default:
        path = 'Khác';
    }
    return path;
  }

  /// Popup Confirmation to remove cloud image
  void removeCloudImageConfirmation(ImageModel image) {
    // Delete Confirmation
    PDialogs.defaultDialog(
      context: Get.context!,
      content: 'Bạn có chắc muốn xóa ảnh này không?',
      onConfirm: () {
        // Close the previous Dialog Image Popup
        Get.back();

        removeCloudImage(image);
      }
    );
  }

  void removeCloudImage(ImageModel image) async {
    try {
      // Close the removeCloudImageConfirmation() Dialog
      Get.back();

      // Show Loader
      Get.defaultDialog(
        title: '',
        barrierDismissible: false,
        backgroundColor: Colors.transparent,
        content: const PopScope(canPop: false, child: SizedBox(width: 150, height: 150, child: PCircularLoader())),
      );

      // Delete Image
      await mediaRepository.deleteFileFromStorage(image);

      // Get the corresponding list to update
      RxList<ImageModel> targetList;

      // Check the selected category and update the corresponding list
      switch (selectedPath.value) {
        case MediaCategory.banners:
          targetList = allBannerImages;
          break;
        case MediaCategory.brands:
          targetList = allBrandImages;
          break;
        case MediaCategory.categories:
          targetList = allCategoryImages;
          break;
        case MediaCategory.products:
          targetList = allProductImages;
          break;
        case MediaCategory.users:
          targetList = allUserImages;
          break;
        default:
          return;
      }

      // Remove from the list
      targetList.remove(image);
      update();

      PFullScreenLoader.stopLoading();
      PLoaders.successSnackBar(title: 'Đã xóa ảnh', message: 'Hình ảnh đã được xóa thành công khỏi bộ nhớ đám mây của bạn');
    } catch (e) {
      PFullScreenLoader.stopLoading();
      PLoaders.errorSnackBar(title: 'Ôi không', message: e.toString());
    }
  }

  // Images Selection Bottom Sheet
  Future<List<ImageModel>?> selectImagesFromMedia({List<String>? selectedUrls, bool allowSelection = true, bool multipleSelection = false}) async {
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
                )
              ],
            ),
          ),
        ),
      )
    );

    return selectedImages;
  }
}