import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../utils/constants/image_strings.dart';

/// A circular loader widget with customizable foreground and background colors.
class PLoaderAnimation extends StatelessWidget {
  const PLoaderAnimation({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(child: Lottie.asset(PImages.defaultLoaderAnimation, height: 200, width: 200));
  }
}