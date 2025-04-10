import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pine/common/widgets/appbar/appbar.dart';
import 'package:pine/features/shop/controllers/review_controller.dart';
import 'package:pine/features/shop/models/review_model.dart';
import 'package:pine/features/shop/screens/product_reviews/widgets/rating_progress_indicator.dart';
import 'package:pine/features/shop/screens/product_reviews/widgets/user_review_card.dart';
import 'package:pine/utils/constants/sizes.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pine/common/widgets/products/ratings/ratings_indicator.dart';
import 'package:pine/utils/constants/colors.dart';
import 'package:pine/utils/helpers/helper_functions.dart';

class ProductReviewsScreen extends StatelessWidget {
  const ProductReviewsScreen({super.key, required this.productId});

  final String productId;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ReviewController());
    final dark = PHelperFunctions.isDarkMode(context);

    return Scaffold(
      appBar: PAppBar(
        title: Text('Đánh giá & xếp hạng',
            style: Theme.of(context)
                .textTheme
                .headlineSmall!
                .apply(color: dark ? PColors.white : PColors.black)),
        showBackArrow: true,
      ),

      /// Body
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Phần tổng quan về đánh giá với thiết kế mới
            Container(
              padding: const EdgeInsets.all(PSizes.defaultSpace),
              decoration: BoxDecoration(
                color: dark ? PColors.darkerGrey : Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: FutureBuilder<double>(
                future: controller.getAverageRating(productId),
                builder: (context, ratingSnapshot) {
                  final rating = ratingSnapshot.data ?? 0.0;

                  return FutureBuilder<int>(
                    future: controller.getReviewCount(productId),
                    builder: (context, countSnapshot) {
                      final count = countSnapshot.data ?? 0;

                      // Thiết kế mới cho phần tổng quan
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Tiêu đề và mô tả
                          Row(
                            children: [
                              const Icon(Icons.star_rounded,
                                  color: Colors.amber, size: 24),
                              const SizedBox(width: PSizes.sm),
                              Text(
                                'Đánh giá sản phẩm',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),

                          const SizedBox(height: PSizes.spaceBtwItems / 2),

                          const Padding(
                            padding:
                                EdgeInsets.only(left: PSizes.md + PSizes.sm),
                            child: Text(
                              'Đánh giá và nhận xét được xác minh từ người dùng thực',
                              style:
                                  TextStyle(fontSize: 13, color: Colors.grey),
                            ),
                          ),

                          const SizedBox(height: PSizes.spaceBtwItems),

                          // Card chứa thông tin đánh giá
                          // Phần Container chứa thông tin đánh giá
                          Container(
                            padding: const EdgeInsets.all(PSizes.md),
                            decoration: BoxDecoration(
                              color: dark ? PColors.dark : Colors.grey.shade50,
                              borderRadius:
                                  BorderRadius.circular(PSizes.borderRadiusMd),
                              border: Border.all(color: Colors.grey.shade200),
                            ),
                            child: IntrinsicHeight(
                              child: Row(
                                children: [
                                  // Bên trái: Điểm đánh giá và rating bar - MỞ RỘNG
                                  Expanded(
                                    flex: 4,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          rating.toStringAsFixed(1),
                                          style: Theme.of(context)
                                              .textTheme
                                              .displaySmall!
                                              .copyWith(
                                                // Sử dụng displaySmall thay vì headlineLarge
                                                fontWeight: FontWeight.bold,
                                                color: PColors.primary,
                                              ),
                                        ),
                                        const SizedBox(
                                            height:
                                                PSizes.sm), // Tăng khoảng cách
                                        // Đảm bảo hiển thị đúng số sao
                                        SizedBox(
                                          height:
                                              24, // Tăng kích thước hiển thị rating bar
                                          child: PRatingBarIndicator(
                                              rating: rating),
                                        ),
                                        const SizedBox(height: PSizes.sm),
                                        Text(
                                          '$count đánh giá',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .copyWith(
                                                color: Colors.grey,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Đường phân cách
                                  VerticalDivider(
                                    width: 24, // Tăng khoảng cách
                                    thickness: 1,
                                    color: Colors.grey.shade300,
                                  ),

                                  // Bên phải: Các thanh tiến trình đánh giá
                                  Expanded(
                                    flex:
                                        7, // Giảm từ 8 xuống 7 vì đã loại bỏ phần %
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: PSizes.sm),
                                      child: POverallProductRating(
                                        productId: productId,
                                        averageRating: rating,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),

            // Phần tiêu đề danh sách đánh giá
            Container(
              padding: const EdgeInsets.fromLTRB(
                PSizes.defaultSpace,
                PSizes.defaultSpace,
                PSizes.defaultSpace,
                PSizes.sm,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tiêu đề và nút sắp xếp
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Tiêu đề bên trái
                      Row(
                        children: [
                          const Icon(Iconsax.message_text,
                              size: 22, color: PColors.primary),
                          const SizedBox(width: PSizes.sm),
                          Text(
                            'Nhận xét từ người dùng',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),

                      // Nút sắp xếp bên phải
                      Obx(() {
                        final isNewest =
                            controller.sortOption.value == 'newest';
                        return InkWell(
                          onTap: () {
                            controller.toggleSortOption();
                          },
                          borderRadius:
                              BorderRadius.circular(PSizes.borderRadiusSm),
                          child: Padding(
                            padding: const EdgeInsets.all(PSizes.sm),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  isNewest
                                      ? Iconsax.arrow_down_1
                                      : Iconsax.arrow_up_2,
                                  size: 16,
                                  color: PColors.primary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  isNewest ? 'Mới nhất' : 'Cũ nhất',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .copyWith(
                                        color: PColors.primary,
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ],
                  ),

                  // Phần lọc theo sao - đặt xuống dòng mới
                  const SizedBox(height: PSizes.spaceBtwItems),
                  FutureBuilder<Map<int, int>>(
                    future: controller.getStarCounts(productId),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return const SizedBox.shrink();

                      final starCounts = snapshot.data!;
                      final totalReviews = starCounts.values
                          .fold(0, (sum, count) => sum + count);

                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        child: Obx(() {
                          final selectedStar =
                              controller.selectedStarFilter.value;

                          return Row(
                            children: [
                              // Nút "Tất cả"
                              _buildStarFilterChip(
                                context: context,
                                label: 'Tất cả',
                                count: totalReviews,
                                isSelected: selectedStar == 0,
                                onTap: () => controller.filterByStar(0),
                              ),

                              // Các nút lọc theo sao từ cao đến thấp
                              for (int star = 5; star >= 1; star--)
                                Padding(
                                  padding: EdgeInsets.only(left: PSizes.sm),
                                  child: _buildStarFilterChip(
                                    context: context,
                                    starCount: star,
                                    count: starCounts[star] ?? 0,
                                    isSelected: selectedStar == star,
                                    onTap: () => controller.filterByStar(star),
                                  ),
                                ),
                            ],
                          );
                        }),
                      );
                    },
                  ),
                ],
              ),
            ),

            // Danh sách đánh giá người dùng
            Obx(() {
              final sortOptionValue = controller.sortOption.value;
              final selectedStar = controller.selectedStarFilter.value;

              return FutureBuilder<List<ReviewModel>>(
                // Sử dụng phương thức getSortedProductReviews để lấy đánh giá đã sắp xếp
                future: controller.getSortedProductReviews(productId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(PSizes.defaultSpace),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(PSizes.defaultSpace),
                        child: Column(
                          children: [
                            const Icon(Iconsax.warning_2,
                                size: 50, color: Colors.orange),
                            const SizedBox(height: PSizes.spaceBtwItems),
                            Text(
                              'Có lỗi xảy ra: ${snapshot.error}',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  final reviews = snapshot.data ?? [];
                  if (reviews.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(PSizes.defaultSpace),
                        child: Column(
                          children: [
                            const Icon(Iconsax.message_question,
                                size: 50, color: Colors.grey),
                            const SizedBox(height: PSizes.spaceBtwItems),
                            Text(
                              'Chưa có đánh giá nào',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: reviews.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: PSizes.defaultSpace,
                          vertical: PSizes.sm,
                        ),
                        child: UserReviewCard(review: reviews[index]),
                      );
                    },
                  );
                },
              );
            }),

            // Padding dưới cùng
            const SizedBox(height: PSizes.defaultSpace),
          ],
        ),
      ),
    );
  }
}

// Widget chip lọc theo sao
Widget _buildStarFilterChip({
  required BuildContext context,
  required int count,
  required bool isSelected,
  required VoidCallback onTap,
  String? label,
  int? starCount,
}) {
  final dark = PHelperFunctions.isDarkMode(context);

  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isSelected
            ? PColors.primary
            : dark
                ? PColors.darkerGrey
                : PColors.lightGrey,
        borderRadius: BorderRadius.circular(PSizes.borderRadiusMd),
        border: Border.all(
          color: isSelected ? PColors.primary : Colors.grey.shade300,
        ),
      ),
      child: Row(
        children: [
          // Hiển thị label hoặc sao + số
          if (label != null)
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? Colors.white : null,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            )
          else if (starCount != null) ...[
            Text(
              '$starCount',
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? Colors.white : null,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            const SizedBox(width: 2),
            Icon(
              Icons.star_rounded,
              size: 12,
              color: isSelected ? Colors.white : Colors.amber,
            ),
          ],

          const SizedBox(width: 4),

          // Hiển thị số lượng trong ngoặc
          Text(
            '($count)',
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? PColors.light : PColors.darkGrey,
            ),
          ),
        ],
      ),
    ),
  );
}
