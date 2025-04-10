import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:pine/utils/constants/colors.dart';

class PRatingBarIndicator extends StatelessWidget {
  const PRatingBarIndicator({
    super.key,
    required this.rating,
  });

  final double rating;

  @override
  Widget build(BuildContext context) {
    return RatingBarIndicator(
      rating: rating,
      itemSize: 16,
      unratedColor: PColors.grey,
      itemBuilder: (_, __) => const Icon(
        Icons.star_rounded,
        color: Colors.amber,
      ),
    );
  }
}
