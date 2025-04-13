import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../../common/widgets/icons/p_circular_icon.dart';
import 'p_circular_image.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/enums.dart';
import '../../../../../../utils/constants/sizes.dart';
import 'p_rounded_image.dart';

/// Widget for uploading images with optional editing functionality
class PImageUploader extends StatelessWidget {
  const PImageUploader({
    super.key,
    this.image,
    this.onIconButtonPressed,
    this.memoryImage,
    this.width = 100,
    this.height = 100,
    required this.imageType,
    this.circular = false,
    this.icon = Iconsax.edit_2,
    this.top,
    this.bottom = 0,
    this.right,
    this.left = 0,
  });

  /// Whether to display the image in a circular shape
  final bool circular;

  /// URL or path of the image to display
  final String? image;

  /// Type of image (network, asset, memory, etc.)
  final ImageType imageType;

  /// Width of the image uploader widget
  final double width;

  /// Height of the image uploader widget
  final double height;

  /// Byte data of the image (for memory images)
  final Uint8List? memoryImage;

  /// Icon to display on the image uploader widget
  final IconData icon;

  /// Offset from the top edge of the widget
  final double? top;

  /// Offset from the bottom edge of the widget
  final double? bottom;

  /// Offset from the right edge of the widget
  final double? right;

  /// Offset from the left edge of the widget
  final double? left;

  /// Callback function for when the icon button is pressed
  final void Function()? onIconButtonPressed;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Display the image in either circular or rounded shape
        circular
            ? PCircularImage(
                image: image,
                width: width,
                height: height,
                imageType: imageType,
                memoryImage: memoryImage,
                backgroundColor: PColors.primaryBackground,
              )
            : PRoundedImage(
                image: image,
                width: width,
                height: height,
                imageType: imageType,
                memoryImage: memoryImage,
                backgroundColor: PColors.primaryBackground,
              ),
        // Display the edit icon button on top of the image
        Positioned(
          top: top,
          left: left,
          right: right,
          bottom: bottom,
          child: PCircularIcon(
            icon: icon,
            size: PSizes.md,
            color: Colors.white,
            onPressed: onIconButtonPressed,
            backgroundColor: PColors.primary.withValues(alpha: 0.9),
          ),
        )
      ],
    );
  }
}
