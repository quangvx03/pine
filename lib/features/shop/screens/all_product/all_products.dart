import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pine/common/widgets/appbar/appbar.dart';
import 'package:pine/common/widgets/products/cart/cart_menu_icon.dart';
import 'package:pine/common/widgets/shimmers/vertical_product_shimmer.dart';
import 'package:pine/features/shop/controllers/product/product_controller.dart';
import 'package:pine/utils/constants/sizes.dart';
import 'package:pine/utils/helpers/cloud_helper_functions.dart';

import '../../../../common/widgets/products/sortable/sortable_products.dart';
import '../../models/product_model.dart';

class AllProductsScreen extends StatelessWidget {
  const AllProductsScreen(
      {super.key, required this.title, this.query, this.futureMethod});

  final String title;
  final Query? query;
  final Future<List<ProductModel>>? futureMethod;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductController());

    return Scaffold(
      appBar: PAppBar(
        title: Text(title),
        showBackArrow: true,
        actions: [PCartCounterIcon()],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(PSizes.defaultSpace),
          child: FutureBuilder(
              future: futureMethod ?? controller.fetchProductsByQuery(query),
              builder: (context, snapshot) {
                const loader = PVerticalProductShimmer();
                final widget = PCloudHelperFunctions.checkMultiRecordState(
                    snapshot: snapshot, loader: loader);

                if (widget != null) return widget;

                final products = snapshot.data!;

                return PSortableProducts(
                  products: products,
                );
              }),
        ),
      ),
    );
  }
}
