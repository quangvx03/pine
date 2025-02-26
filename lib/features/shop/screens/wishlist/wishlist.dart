import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pine/common/widgets/appbar/appbar.dart';
import 'package:pine/common/widgets/icons/circular_icon.dart';
import 'package:pine/common/widgets/layouts/grid_layout.dart';
import 'package:pine/common/widgets/products/product_cards/product_card_vertical.dart';
import 'package:pine/features/shop/screens/home/home.dart';
import 'package:pine/navigation_menu.dart';
import 'package:pine/utils/constants/sizes.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NavigationController>();

    return Scaffold(
      appBar: PAppBar(
        title: Text(
          'Yêu thích',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        actions: [
          PCircularIcon(
              icon: Iconsax.add,
              onPressed: () {
                controller.selectedIndex.value = 0;
              }),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(PSizes.defaultSpace),
          child: Column(
            children: [
              PGridLayout(
                  itemCount: 6,
                  itemBuilder: (_, index) => const PProductCardVertical())
            ],
          ),
        ),
      ),
    );
  }
}
