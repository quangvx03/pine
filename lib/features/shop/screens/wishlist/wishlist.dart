import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pine/common/widgets/appbar/appbar.dart';
import 'package:pine/common/widgets/layouts/grid_layout.dart';
import 'package:pine/common/widgets/loaders/animation_loader.dart';
import 'package:pine/common/widgets/products/cart/cart_menu_icon.dart';
import 'package:pine/common/widgets/products/product_cards/product_card_vertical.dart';
import 'package:pine/common/widgets/shimmers/vertical_product_shimmer.dart';
import 'package:pine/features/shop/controllers/product/favorites_controller.dart';
import 'package:pine/navigation_menu.dart';
import 'package:pine/utils/constants/image_strings.dart';
import 'package:pine/utils/constants/sizes.dart';
import 'package:pine/utils/helpers/cloud_helper_functions.dart';
import 'package:pine/utils/helpers/helper_functions.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = FavoritesController.instance;

    return Scaffold(
      appBar: PAppBar(
        showBackArrow: true,
        title:
            Text('Yêu thích', style: Theme.of(context).textTheme.headlineSmall),
        actions: [PCartCounterIcon()],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(PSizes.defaultSpace),

          /// Product Grid
          child: Obx(
            () => FutureBuilder(
                future: controller.favoriteProducts(),
                builder: (context, snapshot) {
                  /// Nothing Found Widget
                  final emptyWidget = SizedBox(
                    height: PHelperFunctions.screenHeight() * 0.7,
                    child: Center(
                      child: PAnimationLoaderWidget(
                        text: 'Danh sách yêu thích đang trống...',
                        animation: PImages.empty,
                        showAction: true,
                        actionText: 'Khám phá ngay',
                        onActionPressed: () {
                          final navController =
                              Get.find<NavigationController>();
                          Get.back();
                          navController.navigateToTab(0);
                        },
                      ),
                    ),
                  );

                  const loader = PVerticalProductShimmer(itemCount: 6);
                  final widget = PCloudHelperFunctions.checkMultiRecordState(
                      snapshot: snapshot,
                      loader: loader,
                      nothingFound: emptyWidget);
                  if (widget != null) return widget;

                  final products = snapshot.data!;
                  return PGridLayout(
                      itemCount: products.length,
                      itemBuilder: (_, index) =>
                          PProductCardVertical(product: products[index]));
                }),
          ),
        ),
      ),
    );
  }
}
