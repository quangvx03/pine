import 'package:flutter/material.dart';
import 'package:pine/common/widgets/appbar/appbar.dart';
import 'package:pine/common/widgets/brands/brand_card.dart';
import 'package:pine/common/widgets/products/sortable/sortable_products.dart';
import 'package:pine/utils/constants/sizes.dart';

class BrandProducts extends StatelessWidget {
  const BrandProducts({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: PAppBar(title: Text('Nike'), showBackArrow: true,),
      body: SingleChildScrollView(
        child: Padding(padding: EdgeInsets.all(PSizes.defaultSpace),
        child: Column(
          children: [
            /// Brand Detail
            PBrandCard(showBorder: true),
            SizedBox(height: PSizes.spaceBtwSections),

            PSortableProducts(),
          ],
        ),),
      ),
    );
  }
}
