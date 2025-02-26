import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pine/utils/helpers/helper_functions.dart';

import '../../../../../common/widgets/appbar/appbar.dart';
import '../../../../../common/widgets/custom_shapes/curved_edges/curved_edges_widget.dart';
import '../../../../../common/widgets/icons/circular_icon.dart';
import '../../../../../common/widgets/images/rounded_image.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/image_strings.dart';
import '../../../../../utils/constants/sizes.dart';

class PProductImageSlider extends StatelessWidget {
  const PProductImageSlider({
    super.key,
  });


  @override
  Widget build(BuildContext context) {
    final dark = PHelperFunctions.isDarkMode(context);

    return PCurvedEdgeWidget(
        child: Container(
          color: dark ? PColors.darkerGrey : PColors.light,
          child: Stack(
            children: [
              /// Main Large Image
              const SizedBox(
                  height: 400,
                  child: Padding(
                    padding: EdgeInsets.all(PSizes.productImageRadius * 2),
                    child: Center(
                      child:
                      Image(image: AssetImage(PImages.productImage5)),
                    ),
                  )),

              /// Image Slider
              Positioned(
                right: 0,
                bottom: 30,
                left: PSizes.defaultSpace,
                child: SizedBox(
                  height: 80,
                  child: ListView.separated(
                    itemCount: 6,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    physics: const AlwaysScrollableScrollPhysics(),
                    separatorBuilder: (_, __) => const SizedBox(width: PSizes.spaceBtwItems),
                    itemBuilder: (_, index) => PRoundedImage(
                        width: 80,
                        backgroundColor: dark ? PColors.dark : PColors.white,
                        border: Border.all(color: PColors.primary),
                        padding: const EdgeInsets.all(PSizes.sm),
                        imageUrl: PImages.productImage6),
                  ),
                ),
              ),

              const PAppBar(
                showBackArrow: true,
                actions: [
                  PCircularIcon(icon: Iconsax.heart5, color: PColors.favorite,)
                ],
              )
            ],
          ),
        ));
  }
}
