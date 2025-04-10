import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pine/common/widgets/products/ratings/ratings_indicator.dart';
import 'package:pine/features/shop/controllers/review_controller.dart';
import 'package:pine/features/shop/models/review_model.dart';
import 'package:pine/utils/constants/colors.dart';
import 'package:pine/utils/constants/image_strings.dart';
import 'package:pine/utils/constants/sizes.dart';
import 'package:pine/utils/helpers/helper_functions.dart';
import 'package:readmore/readmore.dart';

class UserReviewCard extends StatelessWidget {
  const UserReviewCard({super.key, required this.review});

  final ReviewModel review;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');
    final date = dateFormat.format(review.datetime);
    final dark = Theme.of(context).brightness == Brightness.dark;

    // Lấy controller để lọc từ ngữ
    final reviewController = Get.find<ReviewController>();
    final filteredComment = reviewController.filterProfanity(review.comment);

    return Container(
      decoration: BoxDecoration(
        color: dark ? PColors.darkerGrey : Colors.white,
        borderRadius: BorderRadius.circular(PSizes.borderRadiusMd),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 1),
          ),
        ],
        border: Border.all(color: Colors.grey.shade200),
      ),
      padding: const EdgeInsets.all(PSizes.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thông tin người dùng và đánh giá
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar người dùng
              CircleAvatar(
                radius: 20,
                backgroundImage: review.profilePicture.isNotEmpty
                    ? NetworkImage(review.profilePicture)
                    : const AssetImage(PImages.userProfileImage1)
                        as ImageProvider,
              ),

              const SizedBox(width: PSizes.sm),

              // Thông tin người dùng, rating và thời gian
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tên người dùng
                    Text(
                      review.username,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: PSizes.xs / 2),

                    // Đánh giá sao
                    PRatingBarIndicator(rating: review.rating),

                    const SizedBox(height: PSizes.xs / 2),

                    // Thời gian đánh giá
                    Text(
                      date,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: Colors.grey,
                            fontSize: 11,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Hiển thị biến thể nếu có
          if (review.selectedVariation != null &&
              review.selectedVariation!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: PSizes.sm),
              child: _buildVariationInfo(context, review.selectedVariation!),
            ),

          const SizedBox(height: PSizes.sm),

          // Nội dung bình luận
          Container(
            padding: const EdgeInsets.all(PSizes.sm),
            decoration: BoxDecoration(
              color: dark ? PColors.dark : PColors.lightGrey,
              borderRadius: BorderRadius.circular(PSizes.borderRadiusSm),
            ),
            child: ReadMoreText(
              filteredComment,
              trimLines: 3,
              trimMode: TrimMode.Line,
              trimCollapsedText: ' xem thêm',
              trimExpandedText: ' thu gọn',
              moreStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: PColors.primary),
              lessStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: PColors.primary),
              style: TextStyle(
                fontSize: 14,
                color: dark ? PColors.light : PColors.dark,
                height: 1.5,
              ),
              delimiterStyle: TextStyle(
                fontSize: 14,
                color: dark ? PColors.light : PColors.dark,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget hiển thị thông tin biến thể
  Widget _buildVariationInfo(
      BuildContext context, Map<String, String> variations) {
    final dark = PHelperFunctions.isDarkMode(context);
    // Danh sách thứ tự ưu tiên các thuộc tính
    final attributeOrder = ['Thể loại', 'Kích cỡ', 'Màu sắc', 'Chất liệu'];

    // Tạo danh sách các thuộc tính đã được sắp xếp
    final orderedVariations = attributeOrder
        .where((attr) => variations.containsKey(attr))
        .map((key) => MapEntry(key, variations[key]!))
        .toList();

    // Thêm các thuộc tính khác không nằm trong danh sách ưu tiên
    for (final entry in variations.entries) {
      if (!attributeOrder.contains(entry.key)) {
        orderedVariations.add(entry);
      }
    }

    // Thay thế đoạn code hiển thị Wrap với Text.rich
    return Wrap(
      spacing: PSizes.md,
      runSpacing: PSizes.md,
      children: orderedVariations.map((entry) {
        return Container(
          padding: const EdgeInsets.only(bottom: PSizes.xs),
          child: Text.rich(
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
          ),
        );
      }).toList(),
    );
  }
}
