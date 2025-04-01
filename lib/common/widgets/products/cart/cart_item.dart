import 'package:flutter/material.dart';
import 'package:pine/features/shop/models/cart_model.dart';
import 'package:pine/features/shop/screens/product_details/product_detail.dart';
import 'package:pine/data/repositories/product_repository.dart';
import 'package:pine/common/widgets/shimmers/product_detail_shimmer.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/helpers/helper_functions.dart';
import '../../images/rounded_image.dart';
import '../../texts/brand_title_text_with_verified_icon.dart';
import '../../texts/product_title_text.dart';

class PCartItem extends StatelessWidget {
  const PCartItem({
    super.key,
    required this.cartItem,
  });

  final CartModel cartItem;

  @override
  Widget build(BuildContext context) {
    // Danh sách thứ tự ưu tiên các thuộc tính
    final attributeOrder = ['Thể loại', 'Kích cỡ', 'Màu sắc', 'Chất liệu'];

    // Tạo danh sách các thuộc tính đã được sắp xếp
    final Map<String, String> variations = cartItem.selectedVariation ?? {};
    final orderedVariations = attributeOrder
        .where((attr) => variations.containsKey(attr))
        .map((key) => MapEntry(key, variations[key]!))
        .toList();

    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ProductDetailShimmer(),
            ));
        _loadProductDetails(context);
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(PSizes.productImageRadius),
        ),
        child: Row(
          children: [
            /// Image
            PRoundedImage(
              imageUrl: cartItem.image ?? '',
              width: 65,
              height: 65,
              isNetworkImage: true,
              padding: const EdgeInsets.all(PSizes.xs + 2),
              backgroundColor: PHelperFunctions.isDarkMode(context)
                  ? PColors.darkerGrey
                  : PColors.light,
            ),

            const SizedBox(width: PSizes.spaceBtwItems),

            /// Title, Size
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                      child: PProductTitleText(
                    title: cartItem.title,
                    maxLines: 1,
                  )),
                  PBrandTitleWithVerifiedIcon(title: cartItem.brandName ?? ''),

                  /// Attributes đã được sắp xếp
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: orderedVariations
                        .map((e) => Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: '${e.key}: ',
                                    style:
                                        Theme.of(context).textTheme.labelMedium,
                                  ),
                                  TextSpan(
                                      text: e.value,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium),
                                ],
                              ),
                            ))
                        .toList(),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _loadProductDetails(BuildContext context) async {
    try {
      final productRepository = ProductRepository.instance;
      final product =
          await productRepository.getProductById(cartItem.productId);

      if (!context.mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ProductDetailScreen(product: product),
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Không thể tải thông tin sản phẩm: $e'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red.shade700,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(PSizes.borderRadiusSm),
          ),
        ),
      );
      Navigator.pop(context);
    }
  }
}
