import 'package:flutter/material.dart';
import 'package:pine_admin_panel/common/widgets/layouts/headers/header.dart';
import 'package:pine_admin_panel/common/widgets/layouts/sidebars/sidebar.dart';

class TabletLayout extends StatelessWidget {
  TabletLayout({super.key, this.body});

  final Widget? body;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const PSidebar(),
      appBar: PHeader(scaffoldKey: scaffoldKey),
      body: body ?? const SizedBox()
    );
  }
}
