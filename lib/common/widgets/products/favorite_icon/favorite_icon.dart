import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pine/common/widgets/icons/circular_icon.dart';
import 'package:pine/features/shop/controllers/product/favorites_controller.dart';

import '../../../../utils/constants/colors.dart';

class PFavoriteIcon extends StatelessWidget {
  const PFavoriteIcon({super.key, required this.productId});

  final String productId;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FavoritesController());
    return Obx(
      () => PCircularIcon(
        width: 32,
        height: 32,
        size: 18,
        icon: controller.isFavorite(productId) ? Iconsax.heart5 : Iconsax.heart,
        color: controller.isFavorite(productId) ? PColors.favorite : null,
        onPressed: () => controller.toggleFavoriteProduct(productId),
      ),
    );
  }
}
