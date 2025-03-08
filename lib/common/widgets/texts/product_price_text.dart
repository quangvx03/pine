import 'package:flutter/material.dart';
import 'package:pine/utils/helpers/helper_functions.dart';

class PProductPriceText extends StatelessWidget {
  const PProductPriceText(
      {super.key,
      required this.price,
      this.isLarge = false,
      this.maxLines = 1,
      this.lineThrough = false});

  final String price;
  final int maxLines;
  final bool isLarge, lineThrough;

  @override
  Widget build(BuildContext context) {
    return Text(
      PHelperFunctions.formatCurrency(price),
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      style: isLarge
          ? Theme.of(context).textTheme.titleLarge!.apply(
              decoration: lineThrough ? TextDecoration.lineThrough : null)
          : Theme.of(context).textTheme.bodyLarge!.apply(
              decoration: lineThrough ? TextDecoration.lineThrough : null),
    );
  }
}
