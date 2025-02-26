import 'package:flutter/material.dart';

import 'curved_edges.dart';

class PCurvedEdgeWidget extends StatelessWidget {
  const PCurvedEdgeWidget({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: PCustomCurvedEdges(),
      child: child,
    );
  }
}
