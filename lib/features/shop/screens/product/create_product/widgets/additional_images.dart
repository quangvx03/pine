import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pine_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:pine_admin_panel/common/widgets/images/image_uploader.dart';
import 'package:pine_admin_panel/utils/constants/colors.dart';
import 'package:pine_admin_panel/utils/constants/enums.dart';
import 'package:pine_admin_panel/utils/constants/image_strings.dart';
import 'package:pine_admin_panel/utils/constants/sizes.dart';

class ProductAdditionalImages extends StatelessWidget {
  const ProductAdditionalImages({super.key, required this.additionalProductImagesURLs, this.onTapToAddImages, this.onTapToRemoveImage});

  final RxList<String> additionalProductImagesURLs;
  final void Function()? onTapToAddImages;
  final void Function(int index)? onTapToRemoveImage;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Column(
        children: [
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: onTapToAddImages,
              child: PRoundedContainer(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(PImages.defaultMultiImageIcon, width: 50, height: 50),
                      const Text('Thêm hình ảnh sản phẩm bổ sung')
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: SizedBox(
                    height: 80,
                    child: Obx(() => additionalProductImagesURLs.isEmpty ? emptyList() : _uploadedImages()),
                  ),
                ),
                const SizedBox(width: PSizes.spaceBtwItems / 2),
                PRoundedContainer(
                  width: 80,
                  height: 80,
                  showBorder: true,
                  borderColor: PColors.grey,
                  backgroundColor: PColors.white,
                  onTap: onTapToAddImages,
                  child: const Center(child: Icon(Iconsax.add)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget emptyList() {
    return ListView.separated(
      itemBuilder: (context, index) => const PRoundedContainer(
        backgroundColor: PColors.primaryBackground,
        width: 80,
        height: 80,
      ),
      separatorBuilder: (context, index) => const SizedBox(width: PSizes.spaceBtwItems / 2),
      itemCount: 6,
      scrollDirection: Axis.horizontal,
    );
  }

  Widget _uploadedImages() {
    return ListView.separated(
      separatorBuilder: (context, index) => const SizedBox(width: PSizes.spaceBtwItems / 2),
      itemCount: additionalProductImagesURLs.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        final image = additionalProductImagesURLs[index];
        return PImageUploader(
          top: 0,
          right: 0,
          width: 80,
          height: 80,
          left: null,
          bottom: null,
          image: image,
          icon: Iconsax.trash,
          imageType: ImageType.network,
          onIconButtonPressed: () => onTapToRemoveImage!(index),
        );
      },
    );
  }
}