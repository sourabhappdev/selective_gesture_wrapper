import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// A wrapper that conditionally absorbs or passes gestures to its child.
///
/// Useful for selectively disabling gesture interactions, e.g., in editors.
class SelectiveGestureWrapper extends SingleChildRenderObjectWidget {
  final bool absorbGestures;

  const SelectiveGestureWrapper({
    super.key,
    required this.absorbGestures,
    required Widget child,
  }) : super(child: child);

  @override
  RenderObject createRenderObject(BuildContext context) => SelectiveGestureRenderBox(absorbGestures);

  @override
  void updateRenderObject(
      BuildContext context,
      covariant SelectiveGestureRenderBox renderObject,
      ) => renderObject.absorbGestures = absorbGestures;
}

class SelectiveGestureRenderBox extends RenderProxyBox {
  bool _absorbGestures;

  SelectiveGestureRenderBox(this._absorbGestures);

  set absorbGestures(bool value) {
    if (value != _absorbGestures) {
      _absorbGestures = value;
      markNeedsPaint();
    }
  }

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    if (_absorbGestures) {
      return false; // Don't allow child to receive gestures
    }
    return super.hitTest(result, position: position);
  }
}
