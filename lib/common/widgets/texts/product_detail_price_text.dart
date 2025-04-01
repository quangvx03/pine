import 'package:flutter/material.dart';
import 'package:pine/utils/helpers/helper_functions.dart';

class PProductDetailPriceText extends StatelessWidget {
  const PProductDetailPriceText(
      {super.key,
      required this.price,
      this.isLarge = false,
      this.maxLines = 1,
      this.lineThrough = false,
      this.textStyle});

  final String price;
  final int maxLines;
  final bool isLarge, lineThrough;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    TextStyle baseStyle = isLarge
        ? Theme.of(context).textTheme.headlineMedium!
        : Theme.of(context).textTheme.titleLarge!;

    if (price.contains('-')) {
      final prices = price.split('-');
      if (prices.length == 2) {
        final minPrice = PHelperFunctions.formatCurrency(prices[0].trim());
        final maxPrice = PHelperFunctions.formatCurrency(prices[1].trim());
        TextStyle finalStyle =
            textStyle != null ? baseStyle.merge(textStyle) : baseStyle;
        return Text(
          '$minPrice - $maxPrice',
          maxLines: maxLines,
          overflow: TextOverflow.ellipsis,
          style: finalStyle.apply(
            decoration: lineThrough ? TextDecoration.lineThrough : null,
          ),
        );
      }
    }

    // Xử lý giá thông thường
    TextStyle finalStyle =
        textStyle != null ? baseStyle.merge(textStyle) : baseStyle;
    return Text(
      PHelperFunctions.formatCurrency(price),
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      style: finalStyle.apply(
        decoration: lineThrough ? TextDecoration.lineThrough : null,
      ),
    );
  }
}
