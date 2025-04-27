import 'package:flutter/material.dart';
import 'package:pine/data/repositories/review_repository.dart';
import 'package:pine/utils/constants/colors.dart';
import 'package:pine/utils/constants/sizes.dart';

class PProductTitleText extends StatelessWidget {
  const PProductTitleText({
    super.key,
    required this.title,
    this.smallSize = false,
    this.isDetail = false,
    this.maxLines = 2,
    this.textAlign = TextAlign.left,
    this.showRating = false,
    this.productId,
  });

  final String title;
  final bool smallSize;
  final bool isDetail;
  final int maxLines;
  final TextAlign? textAlign;
  final bool showRating;
  final String? productId;

  @override
  Widget build(BuildContext context) {
    // Nếu không hiển thị đánh giá, sử dụng code cũ
    if (!showRating || productId == null) {
      return Text(
        title,
        style: isDetail
            ? Theme.of(context).textTheme.titleMedium
            : smallSize
                ? Theme.of(context).textTheme.bodyMedium
                : Theme.of(context).textTheme.titleSmall,
        overflow: TextOverflow.ellipsis,
        maxLines: maxLines,
        textAlign: textAlign,
      );
    }

    // Nếu hiển thị đánh giá, sử dụng FutureBuilder để lấy đánh giá và hiển thị
    return FutureBuilder<double>(
      future: ReviewRepository.instance.getAverageRating(productId!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            !snapshot.hasData ||
            (snapshot.data ?? 0) <= 0) {
          return Text(
            title,
            style: isDetail
                ? Theme.of(context).textTheme.titleMedium
                : smallSize
                    ? Theme.of(context).textTheme.bodyMedium
                    : Theme.of(context).textTheme.titleSmall,
            overflow: TextOverflow.ellipsis,
            maxLines: maxLines,
            textAlign: textAlign,
          );
        }

        final rating = snapshot.data!;

        return RichText(
          textAlign: textAlign ?? TextAlign.left,
          maxLines: maxLines,
          overflow: TextOverflow.ellipsis,
          text: TextSpan(
            children: [
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 2,
                    vertical: 1,
                  ),
                  margin: const EdgeInsets.only(right: 6),
                  decoration: BoxDecoration(
                    color: Colors.yellow[100],
                    borderRadius: BorderRadius.circular(PSizes.sm / 2),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        color: Colors.amber,
                        size: 12,
                      ),
                      Text(
                        rating.toStringAsFixed(1),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: PColors.black),
                      ),
                    ],
                  ),
                ),
              ),
              TextSpan(
                text: title,
                style: isDetail
                    ? Theme.of(context).textTheme.titleMedium
                    : smallSize
                        ? Theme.of(context).textTheme.bodyMedium
                        : Theme.of(context).textTheme.titleSmall,
              ),
            ],
          ),
        );
      },
    );
  }
}
