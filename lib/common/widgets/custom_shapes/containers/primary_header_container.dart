import 'package:flutter/material.dart';

import '../../../../utils/constants/colors.dart';
import '../curved_edges/curved_edges_widget.dart';
import 'circular_container.dart';

class PPrimaryHeaderContainer extends StatelessWidget {
  const PPrimaryHeaderContainer({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return PCurvedEdgeWidget(
        child: Container(
      color: PColors.primary,
      child: Stack(
        children: [
          Positioned(
              top: -150,
              right: -250,
              child: PCircularContainer(
                  backgroundColor: PColors.textWhite.withValues(alpha: 0.1))),
          Positioned(
              top: 100,
              right: -300,
              child: PCircularContainer(
                  backgroundColor: PColors.textWhite.withValues(alpha: 0.1))),
          child,
        ],
      ),
    ));
  }
}
