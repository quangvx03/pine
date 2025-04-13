import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pine_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:pine_admin_panel/common/widgets/loaders/animation_loader.dart';
import 'package:pine_admin_panel/common/widgets/loaders/loader_animation.dart';
import 'package:pine_admin_panel/features/media/controllers/media_controller.dart';
import 'package:pine_admin_panel/features/media/models/image_model.dart';
import 'package:pine_admin_panel/features/media/screens/media/widgets/view_image_details.dart';

import '../../../../../common/widgets/images/p_rounded_image.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/enums.dart';
import '../../../../../utils/constants/image_strings.dart';
import '../../../../../utils/constants/sizes.dart';
import 'folder_dropdown.dart';

class MediaContent extends StatelessWidget {
  MediaContent({
    super.key,
    required this.allowSelection,
    required this.allowMultipleSelection,
    this.alreadySelectedUrls,
    this.onImagesSelected
  });

  final bool allowSelection;
  final bool allowMultipleSelection;
  final List<String>? alreadySelectedUrls;
  final List<ImageModel> selectedImages = [];
  final Function(List<ImageModel> selectedImages)? onImagesSelected;

  @override
  Widget build(BuildContext context) {
    bool loadedPreviousSelection = false;
    final controller = MediaController.instance;
    return PRoundedContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Media Images Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text('Chọn tệp', style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(width: PSizes.spaceBtwItems),
                  MediaFolderDropdown(onChanged: (MediaCategory? newValue) {
                    if (newValue != null) {
                      controller.selectedPath.value = newValue;
                      controller.getMediaImages();
                    }
                  },
                  ),
                ],
              ),
              
              if(allowSelection) buildAddSelectedImagesButton(),
            ],
          ),
          const SizedBox(height: PSizes.spaceBtwSections),

          /// Show Media
          Obx(
            () {
              // Get Selected Folder Images
              List<ImageModel> images = _getSelectedFolderImages(controller);

              // Load Selected Images from the Already Selected Images only once otherwise
              // on Obx() rebuild UI first images will be selected then will auto un check
              if (!loadedPreviousSelection) {
                if (alreadySelectedUrls != null && alreadySelectedUrls!.isNotEmpty) {
                  // Convert alreadySelectedUrls to a Set for faster lookup
                  final selectedUrlsSet = Set<String>.from(alreadySelectedUrls!);

                  for (var image in images) {
                    image.isSelected.value = selectedUrlsSet.contains(image.url);
                    if (image.isSelected.value) {
                      selectedImages.add(image);
                    }
                  }
                } else {
                  // If alreadySelectedUrls is null or empty, set all images to not selected
                  for (var image in images) {
                    image.isSelected.value = false;
                  }
                }
                loadedPreviousSelection = true;
              }

              // Loader
              if (controller.loading.value && images.isEmpty) return const PLoaderAnimation();

              // Empty Widget
              if (images.isEmpty) return _buildEmptyAnimationWidget(context);
              
              return
               Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    alignment: WrapAlignment.start,
                    crossAxisAlignment: WrapCrossAlignment.start,
                    children: images
                      .map((image) => GestureDetector(
                        onTap: () => Get.dialog(ImagePopup(image: image)),
                        child: SizedBox(
                          width: 140,
                          height: 180,
                          child: Column(
                            children: [
                              allowSelection ? _buildListWithCheckbox(image) : _buildSimpleList(image),
                              Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: PSizes.sm),
                                    child: Text(image.filename, maxLines: 1, overflow: TextOverflow.ellipsis),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      )
                    )
                    .toList(),
                  ),

                  /// Load More Media Button -> Show when all images loaded
                  if (!controller.loading.value)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: PSizes.spaceBtwSections),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: PSizes.buttonWidth,
                            child: ElevatedButton.icon(
                              onPressed: () => controller.loadMoreMediaImages(),
                              label: const Text('Tải thêm'),
                              icon: const Icon(Iconsax.arrow_down),
                            ),
                          )
                        ],
                      ),
                    )
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  List<ImageModel> _getSelectedFolderImages(MediaController controller) {
    List<ImageModel> images = [];
    if (controller.selectedPath.value == MediaCategory.banners) {
      images = controller.allBannerImages.where((image) => image.url.isNotEmpty).toList();
    } else if (controller.selectedPath.value == MediaCategory.brands) {
      images = controller.allBrandImages.where((image) => image.url.isNotEmpty).toList();
    } else if (controller.selectedPath.value == MediaCategory.categories) {
      images = controller.allCategoryImages.where((image) => image.url.isNotEmpty).toList();
    } else if (controller.selectedPath.value == MediaCategory.products) {
      images = controller.allProductImages.where((image) => image.url.isNotEmpty).toList();
    } else if (controller.selectedPath.value == MediaCategory.users) {
      images = controller.allUserImages.where((image) => image.url.isNotEmpty).toList();
    }
    return images;
  }

  Widget _buildEmptyAnimationWidget(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: PSizes.lg * 3),
      child: PAnimationLoaderWidget(
          width: 300,
          height: 300,
          text: 'Chọn thư mục mong muốn của bạn',
          animation: PImages.packageAnimation,
          style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }

  _buildSimpleList(ImageModel image) {
    return PRoundedImage(
      width: 140,
      height: 140,
      padding: PSizes.sm,
      image: image.url,
      imageType: ImageType.network,
      margin: PSizes.spaceBtwItems / 2,
      backgroundColor: PColors.primaryBackground,
    );
  }

  Widget _buildListWithCheckbox(ImageModel image) {
    return Stack(
      children: [
        PRoundedImage(
          width: 140,
            height: 140,
            padding: PSizes.sm,
            image: image.url,
            imageType: ImageType.network,
          margin: PSizes.spaceBtwItems / 2,
          backgroundColor: PColors.primaryBackground,
        ),
        Positioned(
          top: PSizes.md,
            right: PSizes.md,
            child: Obx(
                () => Checkbox(
                    value: image.isSelected.value,
                    onChanged: (selected) {
                      if (selected != null) {
                        image.isSelected.value = selected;

                        if (selected) {
                          if (!allowMultipleSelection) {
                            // If multiple selection is not allowed, uncheck other checkboxes
                            for (var otherImage in selectedImages) {
                              if(otherImage != image) {
                                otherImage.isSelected.value = false;
                              }
                            }
                            selectedImages.clear();
                          }
                          selectedImages.add(image);
                        } else {
                          selectedImages.remove(image);
                        }
                      }
                    },
                )
            )
        )
      ],
    );
  }

  Widget buildAddSelectedImagesButton() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Close Button
        SizedBox(
          width: 120,
          child: OutlinedButton.icon(onPressed: () => Get.back(), label: const Text('Đóng'), icon: const Icon(Iconsax.close_circle)),
        ),
        const SizedBox(width: PSizes.spaceBtwItems),
        SizedBox(
          width: 120,
          child: ElevatedButton.icon(
              onPressed: () => Get.back(result: selectedImages),
              label: const Text('Thêm'),
            icon: const Icon(Iconsax.image),
          ),
        )
      ],
    );
  }
}
