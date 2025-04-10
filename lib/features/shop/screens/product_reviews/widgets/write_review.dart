import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pine/common/widgets/appbar/appbar.dart';
import 'package:pine/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:pine/features/shop/controllers/review_controller.dart';
import 'package:pine/features/shop/models/cart_model.dart';
import 'package:pine/utils/constants/colors.dart';
import 'package:pine/utils/constants/sizes.dart';
import 'package:pine/utils/helpers/helper_functions.dart';

class WriteReviewScreen extends StatelessWidget {
  const WriteReviewScreen(
      {super.key, required this.product, required this.orderId});

  final CartModel product;
  final String orderId;

  @override
  Widget build(BuildContext context) {
    final dark = PHelperFunctions.isDarkMode(context);
    final controller = Get.find<ReviewController>();

    // Reset form khi màn hình được mở
    controller.resetForm();

    return Scaffold(
      appBar: PAppBar(
        title: Text('Viết đánh giá',
            style: Theme.of(context).textTheme.headlineSmall),
        showBackArrow: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(PSizes.defaultSpace),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thông tin sản phẩm
              PRoundedContainer(
                padding: const EdgeInsets.all(PSizes.md),
                backgroundColor: dark ? PColors.darkerGrey : PColors.light,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hình ảnh sản phẩm
                    ClipRRect(
                      borderRadius: BorderRadius.circular(PSizes.sm),
                      child: Image.network(
                        product.image ?? '',
                        width: 80,
                        height: 80,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => Container(
                          width: 80,
                          height: 80,
                          color: Colors.grey.shade200,
                          child: const Icon(Iconsax.image, color: Colors.grey),
                        ),
                      ),
                    ),
                    const SizedBox(width: PSizes.spaceBtwItems),

                    // Thông tin sản phẩm
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Tên sản phẩm
                          Text(
                            product.title,
                            style: Theme.of(context).textTheme.titleMedium,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: PSizes.xs),

                          // Biến thể (nếu có)
                          if (product.selectedVariation != null &&
                              product.selectedVariation!.isNotEmpty) ...[
                            const SizedBox(height: PSizes.xs),
                            _buildVariationInfo(
                                context, product.selectedVariation!),
                          ]
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: PSizes.spaceBtwSections),

              // Đánh giá sao
              Text(
                'Đánh giá của bạn',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: PSizes.spaceBtwItems),
              Center(
                child: Obx(() => RatingBar.builder(
                      initialRating: controller.rating.value,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: false,
                      itemCount: 5,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => const Icon(
                        Icons.star_rounded,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        controller.rating.value = rating;
                      },
                    )),
              ),

              const SizedBox(height: PSizes.spaceBtwSections),

              // Nhận xét
              Text(
                'Nhận xét của bạn',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: PSizes.spaceBtwItems),
              TextFormField(
                controller: controller.commentController,
                maxLines: 5,
                maxLength: 500,
                buildCounter: (BuildContext context,
                    {required int currentLength,
                    required bool isFocused,
                    required int? maxLength}) {
                  return Text(
                    '$currentLength/$maxLength',
                    style: TextStyle(
                      fontSize: 12,
                      color: currentLength >= maxLength!
                          ? PColors.error
                          : PColors.grey,
                    ),
                  );
                },
                decoration: const InputDecoration(
                  hintText: 'Chia sẻ trải nghiệm của bạn với sản phẩm này...',
                  hintStyle: TextStyle(color: PColors.darkGrey),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Vui lòng nhập nhận xét của bạn';
                  }
                  if (value.length < 10) {
                    return 'Nhận xét phải có ít nhất 10 ký tự';
                  }
                  if (value.length > 500) {
                    return 'Nhận xét không được quá 500 ký tự';
                  }
                  return null;
                },
              ),

              const SizedBox(height: PSizes.spaceBtwSections),

              // Nút gửi đánh giá
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    controller.submitReview(product, orderId);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: PSizes.md),
                    backgroundColor: PColors.primary,
                  ),
                  child: Text(
                    'Gửi đánh giá',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: PColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildVariationInfo(
    BuildContext context, Map<String, String> variations) {
  final attributeOrder = ['Thể loại', 'Kích cỡ', 'Màu sắc', 'Chất liệu'];
  final dark = PHelperFunctions.isDarkMode(context);

  final orderedVariations = attributeOrder
      .where((attr) => variations.containsKey(attr))
      .map((key) => MapEntry(key, variations[key]!))
      .toList();

  for (final entry in variations.entries) {
    if (!attributeOrder.contains(entry.key)) {
      orderedVariations.add(entry);
    }
  }

  return Wrap(
    spacing: 4,
    runSpacing: 4,
    children: orderedVariations.map((entry) {
      return Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: '${entry.key}: ',
              style: Theme.of(context).textTheme.labelMedium!.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
            TextSpan(
              text: entry.value,
              style: Theme.of(context).textTheme.labelMedium!.copyWith(
                  fontWeight: FontWeight.w500,
                  color: dark ? PColors.grey : PColors.darkerGrey),
            ),
          ],
        ),
      );
    }).toList(),
  );
}
