import 'package:flutter/material.dart';
import 'package:pine_admin_panel/common/widgets/responsive/screens/admin_layout/desktop_layout.dart';

import '../../responsive/responsive_design.dart';
import '../../responsive/screens/admin_layout/mobile_layout.dart';
import '../../responsive/screens/admin_layout/tablet_layout.dart';

class PSiteTemplate extends StatelessWidget {
  const PSiteTemplate({super.key, this.desktop, this.tablet, this.mobile, this.useLayout = true});

  final Widget? desktop;
  final Widget? tablet;
  final Widget? mobile;
  final bool useLayout;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PResponsiveWidget(
        desktop: useLayout ? DesktopLayout(body: desktop) : desktop ?? Container(),
        tablet: useLayout ? TabletLayout(body: tablet ?? desktop) : tablet ?? desktop ?? Container(),
        mobile: useLayout ? MobileLayout(body: mobile ?? desktop) : mobile ?? desktop ?? Container(),
      ),
    );
  }
}
