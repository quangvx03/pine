import 'package:flutter/material.dart';
import 'package:pine_admin_panel/utils/constants/sizes.dart';

class PResponsiveWidget extends StatelessWidget {
  const PResponsiveWidget({super.key, required this.desktop, required this.tablet, required this.mobile});

  final Widget desktop;
  final Widget tablet;
  final Widget mobile;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (_, constrains) {
          if (constrains.maxWidth >= PSizes.desktopScreenSize) {
            return desktop;
          } else if (constrains.maxWidth < PSizes.desktopScreenSize && constrains.maxWidth >= PSizes.tabletScreenSize) {
            return tablet;
          } else {
            return mobile;
          }
    }
    );
  }
}
