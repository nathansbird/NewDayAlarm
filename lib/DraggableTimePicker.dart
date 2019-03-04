import 'package:flutter/material.dart';
import 'PageTransformer.dart';
import 'dart:ui';
import 'dart:math' as Math;

class DraggableTimePicker extends StatefulWidget {
  DraggableTimePicker({
    Key key,
    this.indicatorColor = const Color(0xffF0C0B2),
    this.textColor = Colors.white,
    this.darkTextColor = const Color(0xff594955),
    this.controller
  }) : super(key: key);

  final Color indicatorColor;
  final Color darkTextColor;
  final Color textColor;
  final AnimationController controller;

  @override
  DraggableTimePickerState createState(){
    return DraggableTimePickerState();
  }
}

class DraggableTimePickerState extends State<DraggableTimePicker> with TickerProviderStateMixin {
  Animation animation;
  double timePicker = 200.0;

  @override
  void initState() {
    Animation curvedAnimation = CurvedAnimation(parent: widget.controller, curve: Curves.easeInOutQuint);
    animation = new Tween(begin: 1.0, end: 0.0).animate(curvedAnimation);
    super.initState();
  }

  Widget _buildTextView(String text, double visibleFraction, double fontSize){
    return Center(
      child: new Text(
        text,
        style: new TextStyle(
          color: Color.lerp(Colors.white.withOpacity(Math.min(0.35 + visibleFraction/1.4, 1)), widget.darkTextColor, animation.value),
          fontSize: fontSize,
          fontWeight: FontWeight.w700
        )
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    TextStyle colonTextStyle = new TextStyle(
        color: Color.lerp(Colors.white, widget.darkTextColor, animation.value),
        fontSize: 64.0-(animation.value*18),
        fontWeight: FontWeight.w700
    );

    return new Container(
      height: timePicker-(animation.value*100),
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        child: new Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 86.0 - (animation.value*24),
              child: new PageTransformer(
                pageViewBuilder: (context, visibilityResolver){
                  return new PageView.builder(
                    controller: new PageController(viewportFraction: 0.35 + animation.value/2),
                    physics: animation.value < 1.0 ? new BouncingScrollPhysics() : new NeverScrollableScrollPhysics(),
                    itemBuilder: (context, i){
                      var hour = (i % 12.0).toInt();
                      if(hour == 0){hour = 12;}
                      var text = (hour < 10 ? "0"+hour.toString() : hour.toString());
                      return _buildTextView(
                          text,
                          visibilityResolver.resolvePageVisibility(i).visibleFraction,
                          64.0+(visibilityResolver.resolvePageVisibility(i).visibleFraction*6)-(animation.value*18)
                      );
                    },
                    scrollDirection: Axis.vertical,
                  );
                },
              ),
            ),
            Padding(
              padding: new EdgeInsets.only(left: 4.0 - (animation.value*4), right: 4.0 - (animation.value*4)),
              child: new Text(":", style: colonTextStyle),
            ),
            Container(
              width: 86.0 - (animation.value*24),
              child: new PageTransformer(
                pageViewBuilder: (context, visibilityResolver){
                  return new PageView.builder(
                    controller: new PageController(viewportFraction: 0.35 + animation.value/2),
                    physics: animation.value < 1.0 ? new BouncingScrollPhysics() : new NeverScrollableScrollPhysics(),
                    itemBuilder: (context, i){
                      var minute = (i % 60.0).toInt();
                      var text = minute < 10 ? "0"+minute.toString() : minute.toString();
                      return _buildTextView(
                          text,
                          visibilityResolver.resolvePageVisibility(i).visibleFraction,
                          64.0+(visibilityResolver.resolvePageVisibility(i).visibleFraction*6)-(animation.value*18)
                      );
                    },
                    scrollDirection: Axis.vertical,
                  );
                },
              ),
            ),
            Padding(
              padding: new EdgeInsets.only(left: 4.0 - (animation.value*4), right: 4.0 - (animation.value*4)),
            ),
            Container(
              width: 100.0-(animation.value*48),
              child: new PageTransformer(
                pageViewBuilder: (context, visibilityResolver){
                  return new PageView.builder(
                    controller: new PageController(viewportFraction: 0.35 + animation.value/2),
                    physics: animation.value < 1.0 ? new BouncingScrollPhysics() : new NeverScrollableScrollPhysics(),
                    itemBuilder: (context, i){
                      return new Padding(
                        padding: EdgeInsets.only(top: 4.0+animation.value*14, bottom: 4.0),
                        child: _buildTextView(i % 2 == 1 ? "PM" : "AM", visibilityResolver.resolvePageVisibility(i).visibleFraction, 56.0+(visibilityResolver.resolvePageVisibility(i).visibleFraction*6)-(animation.value*36))
                      );
                    },
                    scrollDirection: Axis.vertical,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}