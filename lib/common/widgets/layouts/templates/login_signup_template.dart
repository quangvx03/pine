import 'package:flutter/material.dart';
import 'package:pine_admin_panel/utils/helpers/helper_functions.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../styles/spacing_styles.dart';

class PLoginSignupTemplate extends StatelessWidget {
  const PLoginSignupTemplate({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 550,
        child: SingleChildScrollView(
          child: Material(
            child: Container(
              padding: PSpacingStyle.paddingWithAppBarHeight,
              decoration: BoxDecoration(
                color: PHelperFunctions.isDarkMode(context) ? PColors.black : Colors.white,
                borderRadius: BorderRadius.circular(PSizes.cardRadiusLg),
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}