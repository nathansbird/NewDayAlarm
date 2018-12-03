// Copyright 2015 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;

import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter/src/material/button.dart';
import 'package:flutter/src/material/scaffold.dart';
import 'package:flutter/src/material/theme.dart';
import 'package:flutter/src/material/tooltip.dart';

const BoxConstraints _kExtendedSizeConstraints = const BoxConstraints(
  minHeight: 48.0,
  maxHeight: 48.0,
);

class _DefaultHeroTag {
  const _DefaultHeroTag();
  @override
  String toString() => '<default FloatingActionButton tag>';
}

class CustomFloatingActionButton extends StatefulWidget {
  CustomFloatingActionButton.extended({
    Key key,
    this.tooltip,
    this.foregroundColor,
    this.backgroundColor,
    this.splashColor,
    this.heroTag: const _DefaultHeroTag(),
    this.elevation: 6.0,
    this.highlightElevation: 12.0,
    @required this.onPressed,
    this.notchMargin: 4.0,
    this.shape: const StadiumBorder(),
    this.isExtended: true,
    @required Widget icon,
    @required Widget label,
  }) :  assert(elevation != null),
        assert(highlightElevation != null),
        assert(notchMargin != null),
        assert(shape != null),
        assert(isExtended != null),
        _sizeConstraints = _kExtendedSizeConstraints,
        mini = false,
        child = new Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(width: 16.0),
            icon,
            const SizedBox(width: 8.0),
            label,
            const SizedBox(width: 20.0),
          ],
        ),
        super(key: key);

  final Widget child;
  final String tooltip;
  final Color foregroundColor;
  final Color backgroundColor;
  final Color splashColor;
  final Object heroTag;
  final VoidCallback onPressed;
  final double elevation;
  final double highlightElevation;
  final bool mini;
  final double notchMargin;
  final ShapeBorder shape;
  final bool isExtended;
  final BoxConstraints _sizeConstraints;

  @override
  _FloatingActionButtonState createState() => new _FloatingActionButtonState();
}

class _FloatingActionButtonState extends State<CustomFloatingActionButton> {
  bool _highlight = false;
  VoidCallback _clearComputeNotch;

  void _handleHighlightChanged(bool value) {
    setState(() {
      _highlight = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color foregroundColor = widget.foregroundColor ?? theme.accentIconTheme.color;
    Widget result;

    if (widget.child != null) {
      result = IconTheme.merge(
        data: new IconThemeData(
          color: foregroundColor,
        ),
        child: widget.child,
      );
    }

    if (widget.tooltip != null) {
      final Widget tooltip = new Tooltip(
        message: widget.tooltip,
        child: result,
      );
      // The long-pressable area for the tooltip should always be as big as
      // the tooltip even if there is no child.
      result = widget.child != null ? tooltip : new SizedBox.expand(child: tooltip);
    }

    result = new RawMaterialButton(
      onPressed: widget.onPressed,
      onHighlightChanged: _handleHighlightChanged,
      elevation: _highlight ? widget.highlightElevation : widget.elevation,
      constraints: widget._sizeConstraints,
      fillColor: widget.backgroundColor ?? theme.accentColor,
      textStyle: theme.accentTextTheme.button.copyWith(
        color: foregroundColor,
        letterSpacing: 1.2,
      ),
      shape: widget.shape,
      splashColor: widget.splashColor,
      highlightColor: widget.backgroundColor,
      child: result,
    );

    if (widget.heroTag != null) {
      result = new Hero(
        tag: widget.heroTag,
        child: result,
      );
    }

    return result;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    //_clearComputeNotch = Scaffold.setFloatingActionButtonNotchFor(context, _computeNotch);
  }

  @override
  void deactivate() {
    if (_clearComputeNotch != null)
      _clearComputeNotch();
    super.deactivate();
  }

  Path _computeNotch(Rect host, Rect guest, Offset start, Offset end) {
    // The FAB's shape is a circle bounded by the guest rectangle.
    // So the FAB's radius is half the guest width.
    final double fabRadius = guest.width / 2.0;
    final double notchRadius = fabRadius + widget.notchMargin;

    assert(_notchAssertions(host, guest, start, end, fabRadius, notchRadius));

    // If there's no overlap between the guest's margin boundary and the host,
    // don't make a notch, just return a straight line from start to end.
    if (!host.overlaps(guest.inflate(widget.notchMargin)))
      return new Path()..lineTo(end.dx, end.dy);

    // We build a path for the notch from 3 segments:
    // Segment A - a Bezier curve from the host's top edge to segment B.
    // Segment B - an arc with radius notchRadius.
    // Segment C - a Bezier curver from segment B back to the host's top edge.
    //
    // A detailed explanation and the derivation of the formulas below is
    // available at: https://goo.gl/Ufzrqn

    const double s1 = 15.0;
    const double s2 = 1.0;

    final double r = notchRadius;
    final double a = -1.0 * r - s2;
    final double b = host.top - guest.center.dy;

    final double n2 = math.sqrt(b * b * r * r * (a * a + b * b - r * r));
    final double p2xA = ((a * r * r) - n2) / (a * a + b * b);
    final double p2xB = ((a * r * r) + n2) / (a * a + b * b);
    final double p2yA = math.sqrt(r * r - p2xA * p2xA);
    final double p2yB = math.sqrt(r * r - p2xB * p2xB);

    final List<Offset> p = new List<Offset>(6);

    // p0, p1, and p2 are the control points for segment A.
    p[0] = new Offset(a - s1, b);
    p[1] = new Offset(a, b);
    final double cmp = b < 0 ? -1.0 : 1.0;
    p[2] = cmp * p2yA > cmp * p2yB ? new Offset(p2xA, p2yA) : new Offset(p2xB, p2yB);

    // p3, p4, and p5 are the control points for segment B, which is a mirror
    // of segment A around the y axis.
    p[3] = new Offset(-1.0 * p[2].dx, p[2].dy);
    p[4] = new Offset(-1.0 * p[1].dx, p[1].dy);
    p[5] = new Offset(-1.0 * p[0].dx, p[0].dy);

    // translate all points back to the absolute coordinate system.
    for (int i = 0; i < p.length; i += 1)
      p[i] += guest.center;

    return new Path()
      ..lineTo(p[0].dx, p[0].dy)
      ..quadraticBezierTo(p[1].dx, p[1].dy, p[2].dx, p[2].dy)
      ..arcToPoint(
        p[3],
        radius: new Radius.circular(notchRadius),
        clockwise: false,
      )
      ..quadraticBezierTo(p[4].dx, p[4].dy, p[5].dx, p[5].dy)
      ..lineTo(end.dx, end.dy);
  }

  bool _notchAssertions(Rect host, Rect guest, Offset start, Offset end,
      double fabRadius, double notchRadius) {
    if (end.dy != host.top)
      throw new FlutterError(
          'The notch of the floating action button must end at the top edge of the host.\n'
              'The notch\'s path end point: $end is not in the top edge of $host'
      );

    if (start.dy != host.top)
      throw new FlutterError(
          'The notch of the floating action button must start at the top edge of the host.\n'
              'The notch\'s path start point: $start is not in the top edge of $host'
      );

    if (guest.center.dx - notchRadius < start.dx)
      throw new FlutterError(
          'The notch\'s path start point must be to the left of the floating action button.\n'
              'Start point was $start, guest was $guest, notchMargin was ${widget.notchMargin}.'
      );

    if (guest.center.dx + notchRadius > end.dx)
      throw new FlutterError(
          'The notch\'s end point must be to the right of the floating action button.\n'
              'End point was $start, notch was $guest, notchMargin was ${widget.notchMargin}.'
      );

    return true;
  }
}
