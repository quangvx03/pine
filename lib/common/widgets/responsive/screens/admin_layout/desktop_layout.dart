import 'package:flutter/material.dart';
import 'package:pine_admin_panel/common/widgets/layouts/headers/header.dart';
import 'package:pine_admin_panel/common/widgets/layouts/sidebars/sidebar.dart';

class DesktopLayout extends StatelessWidget {
  const DesktopLayout({super.key, this.body});

  final Widget? body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const Expanded(child: PSidebar()),
          Expanded(
            flex: 5,
              child: Column(
                children: [
                  //HEADER
                  const PHeader(),
                  //BODY
                  Expanded(child: body ?? const SizedBox())
                ],
              ),
          ),
        ],
      ),
    );
  }
}
