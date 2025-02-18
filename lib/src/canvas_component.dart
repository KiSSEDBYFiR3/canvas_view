import 'package:flutter/widgets.dart';

/// Component that contains a [Widget] that should be displayed on canvas,
/// widget's [position], and component's identifier
base class CanvasComponent {
  final String id;
  final Widget widget;

  Offset position;

  CanvasComponent({
    required this.id,
    required this.position,
    required this.widget,
  });
}
