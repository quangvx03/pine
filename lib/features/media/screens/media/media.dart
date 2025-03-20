import 'package:flutter/material.dart';
import 'package:pine_admin_panel/common/widgets/layouts/templates/site_layout.dart';
import 'package:pine_admin_panel/features/media/screens/media/responsive_screens/media_desktop.dart';
import 'package:pine_admin_panel/features/media/screens/media/responsive_screens/media_mobile.dart';
import 'package:pine_admin_panel/features/media/screens/media/responsive_screens/media_tablet.dart';

class MediaScreen extends StatelessWidget {
  const MediaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PSiteTemplate(desktop: MediaDesktopScreen(), tablet: MediaTabletScreen(), mobile: MediaMobileScreen());
  }
}
