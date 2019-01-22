import 'package:flutter/material.dart';
import 'AlarmBuilder.dart';

class AlarmBuilderWrapper extends StatefulWidget {
  final AnimationController animationController;
  AlarmBuilderWrapper({
    Key key,
    this.animationController
  }) : super(key: key);

  @override
  AlarmBuilderWrapperState createState() => new AlarmBuilderWrapperState();
}

class AlarmBuilderWrapperState extends State<AlarmBuilderWrapper> with TickerProviderStateMixin {

  AlarmBuilder builder;
  Animation<double> heightTween;

  @override
  void initState() {
    builder = new AlarmBuilder(controller: widget.animationController);

    CurvedAnimation curvedAnimation = new CurvedAnimation(parent: widget.animationController, curve: Curves.decelerate);
    heightTween = new Tween(begin: 0.0, end: 400.0).animate(curvedAnimation);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Stack(
      children: <Widget>[
        new Positioned(
          child: new Opacity(
              opacity: (widget.animationController.value * 0.7),
              child: new IgnorePointer(
                child: new Container(color: Color(0xff000000)),
              )
          ),
          bottom: 0.0,
          top: 0.0,
          left: 0.0,
          right: 0.0,
        ),
        new Positioned(
          child: new Transform(
              transform: new Matrix4.translationValues(0.0, 400.0 - heightTween.value, 0.0),
              child: builder
          ),
          bottom: 0,
          left: 0,
          right: 0,
        )
      ]
    );
  }

  dispose() {
    widget.animationController.dispose();
    super.dispose();
  }
}