import 'dart:typed_data';
import 'package:universal_html/html.dart' as html;

import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:get/get.dart';
import 'package:pine_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:pine_admin_panel/common/widgets/images/p_rounded_image.dart';
import 'package:pine_admin_panel/features/media/controllers/media_controller.dart';
import 'package:pine_admin_panel/features/media/screens/media/widgets/folder_dropdown.dart';
import 'package:pine_admin_panel/utils/constants/enums.dart';
import 'package:pine_admin_panel/utils/constants/image_strings.dart';
import 'package:pine_admin_panel/utils/device/device_utility.dart';

import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../models/image_model.dart';

class MediaUploader extends StatelessWidget {
  const MediaUploader({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = MediaController.instance;
    return Obx(
      () => controller.showImagesUploaderSection.value
          ? Column(
              children: [
                /// Drag and Drop Area
                PRoundedContainer(
                  height: 250,
                  showBorder: true,
                  borderColor: PColors.borderPrimary,
                  backgroundColor: PColors.primaryBackground,
                  padding: EdgeInsets.all(PSizes.defaultSpace),
                  child: Column(
                    children: [
                      Expanded(
                          child: Stack(
                        alignment: Alignment.center,
                        children: [
                          DropzoneView(
                            mime: const ['image/jpeg', 'image/png'],
                            cursor: CursorType.Default,
                            operation: DragOperation.copy,
                            onCreated: (ctrl) => controller.dropzoneController = ctrl,
                            onLoaded: () => print('Zone loaded'),
                            onError: (ev) => print('Zone error: $ev'),
                            onHover: () {print('Zone hovered');},
                            onLeave: () {print('Zone left');},
                            onDropFile: (DropzoneFileInterface ev) async {
                              // Retrieve file data as Uint8List
                              final bytes = await controller.dropzoneController.getFileData(ev);
                              // Extract file metadata
                              final filename = await controller.dropzoneController.getFilename(ev);
                              final mimeType = await controller.dropzoneController.getFileMIME(ev);
                              final image = ImageModel(
                                url: '',
                                folder: '',
                                filename: filename,
                                contentType: mimeType,
                                localImageToDisplay: Uint8List.fromList(bytes),
                              );
                              controller.selectedImagesToUpload.add(image);
                            },
                            onDropInvalid: (ev) => print('Zone invalid MIME: $ev'),
                            onDropFiles: (ev) async {print('Zone drop multiple: $ev');},
                          ),

                          /// Drop Zone Content
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(PImages.defaultMultiImageIcon,
                                  width: 50, height: 50),
                              const SizedBox(height: PSizes.spaceBtwItems),
                              const Text('Kéo thả hình ảnh'),
                              const SizedBox(height: PSizes.spaceBtwItems),
                              OutlinedButton(
                                  onPressed: () => controller.selectLocalImages(),
                                  child: const Text('Chọn hình ảnh')),
                            ],
                          ),
                        ],
                      ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: PSizes.spaceBtwItems),

                /// Locally Selected Images
                if (controller.selectedImagesToUpload.isNotEmpty)
                  PRoundedContainer(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            /// Folders Dropdown
                            Row(
                              children: [
                                Text('Chọn tệp',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall),
                                const SizedBox(width: PSizes.spaceBtwItems),
                                MediaFolderDropdown(
                                    onChanged: (MediaCategory? newValue) {
                                  if (newValue != null) {
                                    controller.selectedPath.value = newValue;
                                  }
                                }),
                              ],
                            ),

                            /// Upload & Remove Buttons
                            Row(
                              children: [
                                TextButton(
                                    onPressed: () => controller.selectedImagesToUpload.clear(), child: const Text('Xóa tất cả')),
                                const SizedBox(width: PSizes.spaceBtwItems),
                                PDeviceUtils.isMobileScreen(context)
                                    ? const SizedBox.shrink()
                                    : SizedBox(
                                        width: PSizes.buttonWidth,
                                        child: ElevatedButton(
                                            onPressed: () => controller.uploadImagesConfirmation(),
                                            child: const Text('Tải ảnh'))),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: PSizes.spaceBtwSections),

                        /// Locally Selected Images
                        Wrap(
                          alignment: WrapAlignment.start,
                          spacing: PSizes.spaceBtwItems / 2,
                          runSpacing: PSizes.spaceBtwItems / 2,
                          children: controller.selectedImagesToUpload
                            .where((image) => image.localImageToDisplay != null)
                            .map((element) => PRoundedImage(
                              width: 90,
                              height: 90,
                              padding: PSizes.sm,
                              imageType: ImageType.memory,
                              memoryImage: element.localImageToDisplay,
                              backgroundColor: PColors.primaryBackground
                          ))
                          .toList(),
                        ),
                        const SizedBox(height: PSizes.spaceBtwSections),

                        /// Upload Button for Mobile
                        PDeviceUtils.isMobileScreen(context)
                            ? SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                    onPressed: () => controller.uploadImagesConfirmation(),
                                    child: const Text('Tải ảnh'),
                                ),
                        )
                            : const SizedBox.shrink()
                      ],
                    ),
                  ),
                const SizedBox(height: PSizes.spaceBtwSections),
              ],
            )
          : const SizedBox.shrink(),
    );
  }
}
