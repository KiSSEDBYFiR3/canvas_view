import 'package:canvas_view/src/canvas_component.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// A [CanvasView] child's ParentData, used to determine child's position on Canvas
class CanvasParentData extends TwoDimensionalViewportParentData {
  Offset offset;

  CanvasParentData({required this.offset});
}

/// A wrapper for [CanvasParentData]
/// Applied automaticly by passing a list of children to [CanvasChildDelegate]
class CanvasChildComponent extends ParentDataWidget<CanvasParentData> {
  final Offset offset;
  final Size size;

  const CanvasChildComponent({
    super.key,
    required super.child,
    required this.offset,
    this.size = Size.zero,
  });

  @override
  void applyParentData(RenderObject renderObject) {
    assert(renderObject.parentData is CanvasParentData);
    final CanvasParentData parentData =
        renderObject.parentData! as CanvasParentData;

    bool needsLayout = false;

    if (parentData.offset != offset) {
      parentData.offset = offset;
      needsLayout = true;
    }

    if (needsLayout) {
      renderObject.parent?.markNeedsLayout();
    }
  }

  @override
  Type get debugTypicalAncestorWidgetClass => CanvasView;
}

class CanvasChildDelegate<T extends CanvasComponent>
    extends TwoDimensionalChildDelegate {
  /// A list of children that should be layed out on Canvas
  final List<T> children;

  int get childrenCount => children.length;

  CanvasChildDelegate({required this.children});

  @override
  Widget? build(BuildContext context, SingleIndexVicinity vicinity) {
    final child = children[vicinity.realIndex];
    return CanvasChildComponent(offset: child.position, child: child.widget);
  }

  @override
  bool shouldRebuild(covariant TwoDimensionalChildDelegate oldDelegate) {
    return true;
  }
}

class CanvasView extends TwoDimensionalScrollView {
  const CanvasView({
    super.key,
    super.primary,
    super.mainAxis = Axis.vertical,
    super.verticalDetails = const ScrollableDetails.vertical(),
    super.horizontalDetails = const ScrollableDetails.horizontal(),
    required CanvasChildDelegate delegate,
    super.cacheExtent,
    super.diagonalDragBehavior = DiagonalDragBehavior.none,
    super.dragStartBehavior = DragStartBehavior.start,
    super.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    super.clipBehavior = Clip.hardEdge,
  }) : super(delegate: delegate);

  @override
  Widget buildViewport(
    BuildContext context,
    ViewportOffset verticalOffset,
    ViewportOffset horizontalOffset,
  ) {
    return TwoDimensionalCanvasViewport(
      horizontalOffset: horizontalOffset,
      horizontalAxisDirection: horizontalDetails.direction,
      verticalOffset: verticalOffset,
      verticalAxisDirection: verticalDetails.direction,
      mainAxis: mainAxis,
      delegate: delegate as CanvasChildDelegate,
      cacheExtent: cacheExtent,
      clipBehavior: clipBehavior,
    );
  }
}

class TwoDimensionalCanvasViewport extends TwoDimensionalViewport {
  const TwoDimensionalCanvasViewport({
    super.key,
    required super.verticalOffset,
    required super.verticalAxisDirection,
    required super.horizontalOffset,
    required super.horizontalAxisDirection,
    required CanvasChildDelegate super.delegate,
    required super.mainAxis,
    super.cacheExtent,
    super.clipBehavior = Clip.hardEdge,
  });

  @override
  RenderTwoDimensionalViewport createRenderObject(BuildContext context) {
    return RenderTwoDimensionalCanvasViewport(
      horizontalOffset: horizontalOffset,
      horizontalAxisDirection: horizontalAxisDirection,
      verticalOffset: verticalOffset,
      verticalAxisDirection: verticalAxisDirection,
      mainAxis: mainAxis,
      delegate: delegate as CanvasChildDelegate,
      childManager: context as TwoDimensionalChildManager,
      cacheExtent: cacheExtent,
      clipBehavior: clipBehavior,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    RenderTwoDimensionalCanvasViewport renderObject,
  ) {
    renderObject
      ..horizontalOffset = horizontalOffset
      ..horizontalAxisDirection = horizontalAxisDirection
      ..verticalOffset = verticalOffset
      ..verticalAxisDirection = verticalAxisDirection
      ..mainAxis = mainAxis
      ..delegate = delegate
      ..cacheExtent = cacheExtent
      ..clipBehavior = clipBehavior;
  }
}

/// Vicinity that defines a real index, used to identify [CanvasChildDelegate.children]
class SingleIndexVicinity extends ChildVicinity {
  final int realIndex;
  const SingleIndexVicinity({
    required super.xIndex,
    required super.yIndex,
    required this.realIndex,
  });
}

class RenderTwoDimensionalCanvasViewport extends RenderTwoDimensionalViewport {
  @override
  void setupParentData(covariant RenderBox child) {
    if (child.parentData is! CanvasParentData) {
      child.parentData = CanvasParentData(offset: Offset.zero);
    }
  }

  RenderTwoDimensionalCanvasViewport({
    required super.horizontalOffset,
    required super.horizontalAxisDirection,
    required super.verticalOffset,
    required super.verticalAxisDirection,
    required CanvasChildDelegate delegate,
    required super.mainAxis,
    required super.childManager,
    super.cacheExtent,
    super.clipBehavior = Clip.hardEdge,
  }) : super(delegate: delegate);

  @override
  void layoutChildSequence() {
    final double horizontalPixels = horizontalOffset.pixels;
    final double verticalPixels = verticalOffset.pixels;

    final CanvasChildDelegate builderDelegate = delegate as CanvasChildDelegate;
    final childrenCount = builderDelegate.childrenCount;

    for (int index = 0; index < childrenCount; index++) {
      /// Set the [SingleIndexVicinity] index
      final SingleIndexVicinity vicinity = SingleIndexVicinity(
        xIndex: index,
        yIndex: index + 1,
        realIndex: index,
      );

      /// Builds child using delegate and obtains its RenderBox
      final RenderBox child = buildOrObtainChildFor(vicinity)!;
      child.layout(constraints.loosen());

      /// Obtains child's [ParentData] and sets child position on canvas
      /// Also "scrolls" children accoreing to viewport offset changes
      final parentData = child.parentData as CanvasParentData;
      parentData.layoutOffset =
          parentData.offset - Offset(horizontalPixels, verticalPixels);
    }

    // Set the min and max scroll extents for each axis.
    verticalOffset.applyContentDimensions(-double.infinity, double.infinity);
    horizontalOffset.applyContentDimensions(-double.infinity, double.infinity);
  }
}
