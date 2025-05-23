import 'package:flutter/material.dart';

import '../../../../utils/constants/colors.dart';

class PCircularContainer extends StatelessWidget {
  const PCircularContainer({
    super.key,
    this.child,
    this.width = 375,
    this.height = 375,
    this.radius = 375,
    this.margin,
    this.padding = 0,
    this.backgroundColor = PColors.white,
  });

  final double? width;
  final double? height;
  final double radius;
  final EdgeInsets? margin;
  final double padding;
  final Widget? child;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: backgroundColor,
      ),
      child: child,
    );
  }
}
