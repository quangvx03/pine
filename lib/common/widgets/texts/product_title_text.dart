import 'package:flutter/material.dart';

class PProductTitleText extends StatelessWidget {
  const PProductTitleText({
    super.key,
    required this.title,
    this.smallSize = false,
    this.isDetail = false,
    this.maxLines = 2,
    this.textAlign = TextAlign.left,
  });

  final String title;
  final bool smallSize;
  final bool isDetail;
  final int maxLines;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
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
}
