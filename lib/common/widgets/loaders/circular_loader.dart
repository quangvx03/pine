import 'package:flutter/material.dart';
import 'package:pine/utils/constants/sizes.dart';

import '../../../utils/constants/colors.dart';

class PCircularLoader extends StatelessWidget {
  const PCircularLoader({super.key,
    this.foregroundColor = PColors.white,
    this.backgroundColor = PColors.primary});

  final Color? foregroundColor, backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(PSizes.lg),
      decoration: BoxDecoration(color: backgroundColor, shape: BoxShape.circle),
      child: Center(
        child: CircularProgressIndicator(
            color: foregroundColor, backgroundColor: Colors.transparent),
      ),
    );
  }
}
