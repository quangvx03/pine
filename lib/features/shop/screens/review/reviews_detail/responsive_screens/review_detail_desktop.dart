import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pine_admin_panel/common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import 'package:pine_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:pine_admin_panel/utils/constants/colors.dart';
import 'package:pine_admin_panel/utils/constants/sizes.dart';
import 'package:pine_admin_panel/features/shop/models/review_model.dart';

class ReviewDetailDesktopScreen extends StatelessWidget {
  const ReviewDetailDesktopScreen({super.key, required this.review});
  final ReviewModel review;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormatted = DateFormat('dd/MM/yyyy – HH:mm').format(review.datetime);

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(PSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PBreadcrumbsWithHeading(
              returnToPreviousScreen: true,
              heading: 'Chi tiết đánh giá',
              breadcrumbItems: [
                {'label': 'Danh sách đánh giá', 'path': '/admin/reviews'},
                'Chi tiết',
              ],
            ),
            const SizedBox(height: PSizes.spaceBtwSections),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: PRoundedContainer(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Thông tin khách hàng & đơn hàng',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 16),

                        // Customer Info
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 28,
                              backgroundImage: NetworkImage(review.profilePicture),
                              backgroundColor: Colors.grey.shade200,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                review.username,
                                style: Theme.of(context).textTheme.titleLarge,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Order Info
                        Row(
                          children: [
                            const Icon(Icons.receipt_long, size: 20, color: PColors.primary),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Mã đơn hàng: #${review.orderId}',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: PSizes.spaceBtwSections),

                /// RIGHT COLUMN – PRODUCT + REVIEW
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Info
                      PRoundedContainer(
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.only(bottom: PSizes.spaceBtwSections),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Thông tin sản phẩm', style: theme.textTheme.titleMedium),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                const Icon(Icons.shopping_bag, size: 20, color: PColors.primary),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Text(
                                    review.productTitle ?? 'Không rõ',
                                    style: theme.textTheme.bodyMedium,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )
                              ],
                            ),
                            if (review.selectedVariation != null &&
                                review.selectedVariation!.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Text(
                                'Phân loại: ${review.selectedVariation!.entries.map((e) => '${e.key}: ${e.value}').join(', ')}',
                                style: theme.textTheme.bodySmall,
                              ),
                            ]
                          ],
                        ),
                      ),

                      // Review Info
                      PRoundedContainer(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Đánh giá sản phẩm', style: theme.textTheme.titleMedium),
                            const SizedBox(height: 12),

                            Row(
                              children: List.generate(
                                review.rating.toInt(),
                                    (index) =>
                                const Icon(Icons.star, color: Colors.amber, size: 20),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(review.comment, style: theme.textTheme.bodyMedium),
                            const SizedBox(height: 12),
                            Text('Ngày đánh giá: $dateFormatted',
                                style: theme.textTheme.bodySmall),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
