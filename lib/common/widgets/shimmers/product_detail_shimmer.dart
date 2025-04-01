import 'package:flutter/material.dart';
import 'package:pine/common/widgets/shimmers/shimmer.dart';
import 'package:pine/utils/constants/colors.dart';
import 'package:pine/utils/constants/sizes.dart';
import 'package:pine/utils/helpers/helper_functions.dart';

class ProductDetailShimmer extends StatelessWidget {
  const ProductDetailShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = PHelperFunctions.isDarkMode(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 350,
                    decoration: BoxDecoration(
                      color: dark ? PColors.dark : PColors.light,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                  Positioned.fill(
                    child: Center(
                      child: Container(
                        width: 310,
                        height: 250,
                        decoration: BoxDecoration(
                          color: dark ? PColors.darkerGrey : Colors.grey[300],
                          borderRadius:
                              BorderRadius.circular(PSizes.productImageRadius),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // Phần content shimmer đơn giản hóa
              Padding(
                padding: const EdgeInsets.all(PSizes.defaultSpace),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const PShimmerEffect(width: 100, height: 35),
                    const SizedBox(height: PSizes.spaceBtwItems),
                    const PShimmerEffect(width: 170, height: 35),
                    const SizedBox(height: PSizes.spaceBtwItems),
                    const PShimmerEffect(width: double.infinity, height: 60),
                    const SizedBox(height: PSizes.spaceBtwItems * 1.5),
                    const PShimmerEffect(width: 170, height: 35),
                    const SizedBox(height: PSizes.spaceBtwItems),
                    const PShimmerEffect(width: double.infinity, height: 60),
                    const SizedBox(height: PSizes.spaceBtwItems * 1.5),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 70,
        padding: const EdgeInsets.symmetric(
            horizontal: PSizes.defaultSpace, vertical: PSizes.defaultSpace / 2),
        decoration: BoxDecoration(
          color: dark ? PColors.darkerGrey : PColors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
            ),
          ],
        ),
        child: const Center(
          child: PShimmerEffect(
            width: double.infinity,
            height: 45,
            radius: 100,
          ),
        ),
      ),
    );
  }
}
