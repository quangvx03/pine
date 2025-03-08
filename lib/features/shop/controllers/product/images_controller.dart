

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pine/features/shop/models/product_model.dart';
import 'package:pine/utils/constants/sizes.dart';

class ImagesController extends GetxController{
  static ImagesController get instance => Get.find();

  RxString selectedProductImage = ''.obs;

  /// Get all Image from product and variations
  List<String> getAllProductImages(ProductModel product){
    // Use set to add unique images only
    Set<String> images = {};

    // Load thumbnail image
    images.add(product.thumbnail);

    // Assign thumbnail as selected image
    selectedProductImage.value = product.thumbnail;

    // Get all images from the product model if not null
    if(product.images != null){
      images.addAll(product.images!);
    }

    // Get all image from the product variations if not null
    if (product.productVariations != null || product.productVariations!.isNotEmpty){
      images.addAll(product.productVariations!.map((variation) => variation.image));
    }

    return images.toList();
  }

  /// Show image popup
  void showEnlargedImage(String image){
    Get.to(
      fullscreenDialog: true,
        () => Dialog.fullscreen(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(padding: const EdgeInsets.symmetric(vertical: PSizes.defaultSpace * 2, horizontal: PSizes.defaultSpace),
            child: CachedNetworkImage(imageUrl: image),),
            const SizedBox(height: PSizes.spaceBtwSections),
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: 150,
                child: OutlinedButton(onPressed: () => Get.back(), child: const Text('Đóng')),
              ),
            )
          ],
        ),
        )
    );
  }
}