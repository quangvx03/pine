import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pine/common/widgets/appbar/appbar.dart';
import 'package:pine/common/widgets/brands/brand_card.dart';
import 'package:pine/common/widgets/layouts/grid_layout.dart';
import 'package:pine/features/shop/controllers/brand_controller.dart';
import 'package:pine/features/shop/screens/brand/brand_products.dart';
import 'package:pine/utils/constants/sizes.dart';

import '../../../../common/widgets/shimmers/brands_shimmer.dart';

class AllBrandsScreen extends StatelessWidget {
  const AllBrandsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final brandController = BrandController.getInstance("all_brands");

    return Scaffold(
      appBar: PAppBar(title: Text('Thương hiệu'), showBackArrow: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(PSizes.defaultSpace),
          child: Obx(
            () {
              if (brandController.isLoading.value) {
                return const PBrandsShimmer();
              }

              if (brandController.allBrands.isEmpty) {
                return Center(
                  child: Text(
                    'Không tìm thấy dữ liệu!',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .apply(color: Colors.white),
                  ),
                );
              }

              return PGridLayout(
                itemCount: brandController.allBrands.length,
                mainAxisExtent: 80,
                itemBuilder: (_, index) {
                  final brand = brandController.allBrands[index];
                  return PBrandCard(
                    showBorder: true,
                    brand: brand,
                    onTap: () => Get.to(
                      () => BrandProducts(brand: brand),
                      preventDuplicates:
                          false, // Quan trọng: cho phép tạo màn hình mới
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
