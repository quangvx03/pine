import 'package:flutter/material.dart';

class PProductPriceText extends StatelessWidget {
  const PProductPriceText(
      {super.key,
      this.currencySign = '₫',
      required this.price,
      this.isLarge = false,
      this.maxLines = 1,
      this.lineThrough = false});

  final String currencySign, price;
  final int maxLines;
  final bool isLarge, lineThrough;

  @override
  Widget build(BuildContext context) {
    return Text(
      price + currencySign,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      style: isLarge
          ? Theme.of(context).textTheme.titleLarge!.apply(
              decoration: lineThrough ? TextDecoration.lineThrough : null)
          : Theme.of(context).textTheme.bodyLarge!.apply(
              decoration: lineThrough ? TextDecoration.lineThrough : null),
      // style: isLarge
      //     ? Theme.of(context).textTheme.headlineMedium!.apply(
      //         decoration: lineThrough ? TextDecoration.lineThrough : null)
      //     : Theme.of(context).textTheme.titleLarge!.apply(
      //         decoration: lineThrough ? TextDecoration.lineThrough : null),
    );
  }
}
