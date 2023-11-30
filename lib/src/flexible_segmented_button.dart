import 'package:flutter/material.dart';

const double _kItemSize = 60.0;
// const PageScrollPhysics _kPagePhysics = PageScrollPhysics();

class FlexibleSegment<T> {
  const FlexibleSegment({
    this.top,
    this.center,
    this.bottom,
    this.tooltip,
    this.isCompleted = false,
  }) : assert(top != null || center != null || bottom != null);

  final Widget? top;
  final Widget? center;
  final Widget? bottom;
  final String? tooltip;
  final bool isCompleted; //Change the name to Be Used in General
}

class FlexibleSegmentedButton<T> extends StatefulWidget {
  const FlexibleSegmentedButton({
    super.key,
    required this.segments,
    required this.selectedIndex,
    this.currentIndex = -1,
    this.visibleItems = 4,
    this.constraints,
    this.padding = const EdgeInsets.all(8.0),
    this.borderRadius,
    this.onSegmentTap,
    this.currentColor = Colors.white,
    this.completedColor = Colors.red,
    this.uncompletedColor = Colors.grey,
    this.itemSize = _kItemSize,
    this.selectedSide = BorderSide.none,
    this.textStyle,
    this.currentTextColor = Colors.white10,
    this.completedTextColor = Colors.white,
    this.uncompletedTextColor = Colors.white10,
  });

  final List<FlexibleSegment<T>> segments;
  final int selectedIndex;
  final int visibleItems;
  final BoxConstraints? constraints;
  final EdgeInsets padding;
  final BorderRadius? borderRadius;
  final ValueChanged<int>? onSegmentTap;
  final Color? currentTextColor;
  final Color? completedTextColor;
  final Color? uncompletedTextColor;
  final Color currentColor;
  final Color completedColor;
  final Color uncompletedColor;
  final int currentIndex;
  final BorderSide selectedSide;
  final TextStyle? textStyle;
  final double itemSize;

  @override
  State<FlexibleSegmentedButton<T>> createState() =>
      _FlexibleSegmentedButtonState<T>();
}

class _FlexibleSegmentedButtonState<T>
    extends State<FlexibleSegmentedButton<T>> {
  final ScrollController _controller = ScrollController();
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
  }

  void _animateToIndex(int index) {
    _controller.animateTo(
      index * widget.itemSize,
      duration: const Duration(seconds: 2),
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  void didUpdateWidget(covariant FlexibleSegmentedButton<T> oldWidget) {
    if (_controller.hasClients && widget.currentIndex != -1 && !_isScrolled) {
      _animateToIndex(widget.currentIndex);
      _isScrolled = true;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final BoxConstraints constraints = widget.constraints ??
        BoxConstraints(
          maxHeight: widget.itemSize + widget.padding.vertical, //+ 8.0,
          //  widget.itemSize + widget.padding.vertical + 8.0,
          //maxWidth: (widget.width + widget.padding.horizontal) * widget.visibleItems,
        );
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return ConstrainedBox(
      constraints: constraints,
      child: ClipRRect(
        borderRadius:
            widget.borderRadius ?? BorderRadius.circular(widget.itemSize / 4),
        child: ListView.builder(
          controller: _controller,
          physics: const ClampingScrollPhysics(),
          // physics: SnappingScrollPhysics(itemExtent: _kItemSize + padding.horizontal, parent: const ClampingScrollPhysics()),
          scrollDirection: Axis.horizontal,
          itemCount: widget.segments.length,
          padding: EdgeInsets.zero, //const EdgeInsets.symmetric(vertical: 8.0),
          itemBuilder: (BuildContext context, int index) {
            //left side of square behind selected item.
            Color backgroundActiveColor = colorScheme.onPrimary;

            if (index > 0 && index == widget.selectedIndex) {
              int previousIndex = index - 1;
              if (widget.segments[previousIndex].isCompleted) {
                backgroundActiveColor = widget.completedColor;
              } else if (previousIndex == widget.currentIndex) {
                backgroundActiveColor = widget.currentColor;
              } else {
                backgroundActiveColor = widget.uncompletedColor;
              }
            }

            //right side of box behind selected item.
            Color backgroundInactiveColor = colorScheme.onPrimary;

            if (index < widget.segments.length - 1 &&
                index == widget.selectedIndex) {
              int nextIndex = index + 1;
              if (widget.segments[nextIndex].isCompleted) {
                backgroundInactiveColor = widget.completedColor;
              } else if (nextIndex == widget.currentIndex) {
                backgroundInactiveColor = widget.currentColor;
              } else {
                backgroundInactiveColor = widget.uncompletedColor;
              }
            }

            //item color
            Color backgroundSelectedItemColor = colorScheme.onPrimary;
            // segments[index].isCompleted ?
            // completedColor : index == currentIndex ?
            // currentColor : uncompletedColor;

            TextStyle style = widget.textStyle ?? const TextStyle();

            // index < activeIndex
            //     ? colorScheme.onPrimary
            //     : colorScheme.onPrimaryContainer;

            if (widget.segments[index].isCompleted) {
              backgroundSelectedItemColor = widget.completedColor;
              style = style.copyWith(color: widget.completedTextColor);
            } else if (index == widget.currentIndex) {
              backgroundSelectedItemColor = widget.currentColor;
              style = style.copyWith(color: widget.currentTextColor);
            } else {
              backgroundSelectedItemColor = widget.uncompletedColor;
              style = style.copyWith(color: widget.uncompletedTextColor);
            }

            final TextStyle topTextStyle = style; //TextStyle(color: textColor);
            final TextStyle centerTextStyle = style.copyWith(
                fontWeight: FontWeight
                    .w700); //theme.textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.bold, color: textColor);
            final TextStyle bottomTextStyle =
                style; //TextStyle(color: textColor);

            if (widget.selectedIndex == index) {
              return CustomPaint(
                painter: _ActiveSegmentBackground(
                  activeColor: backgroundActiveColor, // colorScheme.primary,
                  inactiveColor: backgroundInactiveColor,
                  childSize: Size.square(widget.itemSize),
                ),
                child: Material(
                  shape: RoundedRectangleBorder(
                      borderRadius:  widget.borderRadius ?? BorderRadius.circular(widget.itemSize / 4),
                      side: widget.selectedSide //BorderSide(width: 2)
                      ),
                  elevation: 2.0,
                  color: backgroundSelectedItemColor,
                  child: _SegmentWidget(
                    top: widget.segments[index].top,
                    center: widget.segments[index].center,
                    bottom: widget.segments[index].bottom,
                    topTextStyle: topTextStyle,
                    centerTextStyle: centerTextStyle,
                    bottomTextStyle: bottomTextStyle,
                    padding: widget.padding,
                  ),
                ),
              );
            }

            return _SegmentWidget(
              top: widget.segments[index].top,
              center: widget.segments[index].center,
              bottom: widget.segments[index].bottom,
              topTextStyle: topTextStyle,
              centerTextStyle: centerTextStyle,
              bottomTextStyle: bottomTextStyle,
              padding: widget.padding,
              itemSize: widget.itemSize,
              backgroundColor: backgroundSelectedItemColor,
              onTap: () {
                widget.onSegmentTap?.call(index);
              },
            );
          },
        ),
      ),
    );
    // return ScrollConfiguration(
    //   behavior: const ScrollBehavior().copyWith(dragDevices: {
    //     PointerDeviceKind.touch,
    //     PointerDeviceKind.mouse,
    //   }, scrollbars: false),
    //   child: ConstrainedBox(
    //     constraints: const BoxConstraints(
    //         maxHeight: _SegmentSize, maxWidth: _SegmentSize * 5),
    //     child: CustomPaint(
    //       painter: _ActivSegmentBackground(
    //         backgroundColor: colorScheme.primaryContainer,
    //         backgroundRadius: const Radius.circular(_SegmentSize / 4),
    //         childSize: const Size.square(_SegmentSize),
    //       ),
    //       child: ListView.builder(
    //         physics: const SnappingScrollPhysics(
    //             itemExtent: _SegmentItemExtent,
    //             parent: ClampingScrollPhysics()),
    //         scrollDirection: Axis.horizontal,
    //         itemCount: segments.length,
    //         padding: const EdgeInsets.symmetric(vertical: 8.0),
    //         itemBuilder: (BuildContext context, int index) {
    //           final Color textColor = index < activeIndex
    //               ? colorScheme.onPrimary
    //               : colorScheme.onPrimaryContainer;
    //           if (index == activeIndex) {
    //             return CustomPaint(
    //               painter: _SegmentBackgroundPainter(
    //                 activeIndex: activeIndex,
    //                 index: index,
    //                 childSize: const Size.square(_SegmentSize),
    //                 backgroundRadius: const Radius.circular(_SegmentSize / 4),
    //                 completedColor: colorScheme.onPrimaryContainer,
    //               ),
    //               child: Card(
    //                 shape: RoundedRectangleBorder(
    //                     borderRadius: BorderRadius.circular(_SegmentSize / 4)),
    //                 margin: EdgeInsets.zero,
    //                 elevation: 4.0,
    //                 child: _SegmentWidget(
    //                   size: const Size.square(_SegmentSize),
    //                   top: segments[index].top,
    //                   center: segments[index].center,
    //                   bottom: segments[index].bottom,
    //                   textColor: textColor,
    //                 ),
    //               ),
    //             );
    //           }
    //           return CustomPaint(
    //             painter: _SegmentBackgroundPainter(
    //               activeIndex: activeIndex,
    //               index: index,
    //               childSize: const Size.square(_SegmentSize),
    //               backgroundRadius: const Radius.circular(_SegmentSize / 4),
    //               completedColor: colorScheme.onPrimaryContainer,
    //             ),
    //             child: _SegmentWidget(
    //               size: const Size.square(_SegmentSize),
    //               top: segments[index].top,
    //               center: segments[index].center,
    //               bottom: segments[index].bottom,
    //               textColor: textColor,
    //             ),
    //           );
    //         },
    //       ),
    //     ),
    //   ),
    // );
  }
}

class _SegmentWidget extends StatelessWidget {
  const _SegmentWidget({
    required this.top,
    required this.center,
    required this.bottom,
    this.topTextStyle,
    this.centerTextStyle,
    this.bottomTextStyle,
    required this.padding,
    this.backgroundColor,
    this.onTap,
    this.itemSize = _kItemSize,
  });

  final Widget? top;
  final Widget? center;
  final Widget? bottom;
  final TextStyle? topTextStyle;
  final TextStyle? centerTextStyle;
  final TextStyle? bottomTextStyle;
  final EdgeInsets padding;
  final Color? backgroundColor;
  final Function()? onTap;
  final double itemSize;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;

    return GestureDetector(
      onTap: onTap,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: itemSize + padding.horizontal,
          maxWidth: itemSize + padding.horizontal,
          minHeight: itemSize + padding.vertical,
          maxHeight: itemSize + padding.vertical,
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: backgroundColor,
          ),
          child: Padding(
            padding: padding,
            child: Column(
              children: <Widget>[
                if (top != null)
                  DefaultTextStyle(
                    style: textTheme.bodyMedium!.merge(topTextStyle),
                    child: top!,
                  ),
                if (center != null)
                  DefaultTextStyle(
                    style: textTheme.bodyMedium!.merge(centerTextStyle),
                    child: Expanded(child: Center(child: center!)),
                  ),
                if (bottom != null)
                  DefaultTextStyle(
                    style: textTheme.bodyMedium!.merge(bottomTextStyle),
                    child: bottom!,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SnappingScrollPhysics extends ScrollPhysics {
  final double itemExtent;

  const SnappingScrollPhysics({required this.itemExtent, super.parent});

  @override
  SnappingScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return SnappingScrollPhysics(
        itemExtent: itemExtent, parent: buildParent(ancestor));
  }

  double _getTargetPixels(ScrollMetrics position, Tolerance tolerance) {
    var itemIndex = (position.pixels / itemExtent).round();
    return itemIndex * itemExtent;
  }

  @override
  Simulation? createBallisticSimulation(
      ScrollMetrics position, double velocity) {
    if (position.pixels <= position.minScrollExtent ||
        position.pixels >= position.maxScrollExtent) {
      return super.createBallisticSimulation(position, velocity);
    }

    Tolerance tolerance = this.tolerance;
    double target = _getTargetPixels(position, tolerance);

    if (velocity.abs() < tolerance.velocity ||
        (velocity > 0 && target <= position.pixels) ||
        (velocity < 0 && target >= position.pixels)) {
      return ScrollSpringSimulation(spring, position.pixels, target, velocity,
          tolerance: tolerance);
    }

    return null;
  }
}

// class _SegmentBackgroundPainter extends CustomPainter {
//   _SegmentBackgroundPainter({
//     required this.activeIndex,
//     required this.index,
//     required this.childSize,
//     required this.backgroundRadius,
//     required this.completedColor,
//   });

//   final int activeIndex;
//   final int index;
//   final Size childSize;
//   final Radius backgroundRadius;
//   final Color completedColor;

//   @override
//   void paint(Canvas canvas, Size size) {
//     // Paint backgroundPaint = Paint()..color = backgroundColor;
//     // canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, size.width, size.height), backgroundRadius), backgroundPaint); // Example: Blue rectangle for the first 100 pixels in height
//     Paint completedPaint = Paint()..color = completedColor;

//     if (index == 0) {
//       canvas.drawRRect(
//           RRect.fromRectAndCorners(
//             Rect.fromLTWH(0, 0, childSize.width, size.height),
//             topLeft: backgroundRadius,
//             bottomLeft: backgroundRadius,
//           ),
//           completedPaint); // Example: Blue rectangle for the first 100 pixels in height
//     } else if (index < activeIndex) {
//       canvas.drawRect(Rect.fromLTWH(0, 0, childSize.width, size.height),
//           completedPaint); // Example: Blue rectangle for the first 100 pixels in height
//     } else if (index == activeIndex) {
//       canvas.drawRect(Rect.fromLTWH(0, 0, childSize.width / 2, size.height),
//           completedPaint); // Example: Blue rectangle for the first 100 pixels in height
//     }
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) {
//     return false;
//   }
// }

class _ActiveSegmentBackground extends CustomPainter {
  _ActiveSegmentBackground({
    required this.activeColor,
    required this.inactiveColor,
    required this.childSize,
  });
  final Color activeColor;
  final Color inactiveColor;
  final Size childSize;

  @override
  void paint(Canvas canvas, Size size) {
    Paint backgroundPaint = Paint()..color = activeColor;
    canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width / 2, size.height), backgroundPaint);
    backgroundPaint = Paint()..color = inactiveColor;
    canvas.drawRect(
        Rect.fromLTWH(size.width / 2, 0, size.width / 2, size.height),
        backgroundPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
