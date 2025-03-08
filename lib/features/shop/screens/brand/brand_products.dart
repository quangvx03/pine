import 'package:flutter/material.dart';
import 'package:pine/common/widgets/appbar/appbar.dart';
import 'package:pine/common/widgets/brands/brand_card.dart';
import 'package:pine/common/widgets/products/sortable/sortable_products.dart';
import 'package:pine/common/widgets/shimmers/vertical_product_shimmer.dart';
import 'package:pine/features/shop/controllers/brand_controller.dart';
import 'package:pine/utils/constants/sizes.dart';
import 'package:pine/utils/helpers/cloud_helper_functions.dart';

import '../../models/brand_model.dart';

class BrandProducts extends StatelessWidget {
  const BrandProducts({super.key, required this.brand});

  final BrandModel brand;

  @override
  Widget build(BuildContext context) {
    final controller = BrandController.instance;
    return Scaffold(
      appBar: PAppBar(
        title: Text(brand.name),
        showBackArrow: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(PSizes.defaultSpace),
          child: Column(
            children: [
              /// Brand Detail
              PBrandCard(
                showBorder: true,
                brand: brand,
              ),
              const SizedBox(height: PSizes.spaceBtwSections),

              FutureBuilder(
                  future: controller.getBrandProducts(brandId:  brand.id),
                  builder: (context, snapshot) {

                    /// Handle Loader, No Record or Error Message
                    const loader = PVerticalProductShimmer();
                    final widget = PCloudHelperFunctions.checkMultiRecordState(snapshot: snapshot, loader: loader);
                    if(widget != null) return widget;

                    /// Record found
                    final brandProducts = snapshot.data!;
                    return  PSortableProducts(products: brandProducts);
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
