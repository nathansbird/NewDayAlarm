import 'package:flutter/material.dart';
import 'customUIElements.dart';
import 'DraggableTimePicker.dart';
import 'dart:math' as Math;

class AlarmBuilder extends StatefulWidget {
  final AnimationController controller;

  AlarmBuilder({
    Key key,
    this.controller
  }) : super(key: key);

  @override
  AlarmBuilderState createState() => new AlarmBuilderState();
}

class AlarmBuilderState extends State<AlarmBuilder> with TickerProviderStateMixin{
  Animation<double> heightTween;
  AnimationController timePickerAnimator;
  Animation<double> circleRevealAnimation;
  CurvedAnimation curvedAnimation;

  double headerHeight = 28.0;
  double cardPadding = 24.0;
  double builderHeight = 400.0;

  @override
  void initState() {
    timePickerAnimator = new AnimationController(duration: const Duration(milliseconds: 300), vsync: this);
    curvedAnimation = new CurvedAnimation(parent: timePickerAnimator, curve: Curves.easeInOutQuint);
    circleRevealAnimation = new Tween(begin: 0.0, end: 1.0).animate(curvedAnimation)..addListener((){
      setState((){});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var radius = Math.sqrt((MediaQuery.of(context).size.width*MediaQuery.of(context).size.width)+((builderHeight-cardPadding)*(builderHeight-cardPadding)))/1.99;

    return _buildPositioningWrapper(
      child: new Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: _buildHeader(),
          ),
          new Align(
            alignment: Alignment.center,
            child: new CustomPaint(
              painter: new CircleRevealPainter(circleColor: const Color(0xffF0C0B2), radius: (circleRevealAnimation.value*radius)),
            )
          ),
          new Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: new EdgeInsets.only(bottom: cardPadding),
              child: Container(
                child: new RoundOutlineButton(
                  onTap: (){
                    timePickerAnimator.reverse();
                  },
                  iconSize: 36.0,
                ),
              ),
            ),
          ),
          _buildAlarmPicker()
        ],
      )
    );
  }

  Widget _buildPositioningWrapper({child}){
    return Padding(
      padding: new EdgeInsets.only(top: cardPadding),
      child: new ClipRRect(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(12.0), topRight: Radius.circular(12.0),),
        child: new Container(
          child: new CustomCard(
            radius: new BorderRadius.only(topLeft: Radius.circular(12.0), topRight: Radius.circular(12.0)),
            child: new Padding(
              padding: EdgeInsets.only(left: 8.0, right: 10.0, top: 8.0),
              child: child,
            ),
          ),
          height: builderHeight - cardPadding,
        ),
      ),
    );
  }

  Widget _buildAlarmPicker(){
    return Padding(
      padding: new EdgeInsets.only(top: headerHeight),
      child: new Column(
        children: <Widget>[
          new GestureDetector(
            onTap: (){
              timePickerAnimator.forward();
            },
            child: new Container(
              alignment: Alignment.lerp(Alignment.topLeft, Alignment.center, curvedAnimation.value),
              child: new DraggableTimePicker(controller: timePickerAnimator),
            )
          )
        ],
      ),
    );
  }

  Widget _buildRepeatDayPicker(){
    return new Container(
      child: Center(
        child: new Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            new Text("4", style: new TextStyle(fontSize: 56.0, fontFamily: "ProductSansBold", color: Color(0xaa202020))),
            new Text(":", style: new TextStyle(fontSize: 56.0, fontFamily: "ProductSansBold", color: Color(0xaa202020))),
            new Text("30", style: new TextStyle(fontSize: 56.0, fontFamily: "ProductSansBold", color: Color(0xaa202020))),
            Padding(
              padding: const EdgeInsets.only(left: 2.0, bottom: 9.0),
              child: new Text("AM", style: new TextStyle(fontSize: 18.0, fontFamily: "ProductSansBold", color: Color(0xaa202020))),
            ),
          ]
        ),
      ),
      width: double.maxFinite,
    );
  }

  Widget _buildPickerContent(){
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: new Container(
        child: new Row(
          children: _buildDayOfWeekButtons(),
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        ),
      ),
    );
  }
  List<String> list = ["Sn", "M", "Tu", "W", "Th", "F", "St"];
  List<Widget> _buildDayOfWeekButtons(){
    List<Widget> buttonList = [];
    for(int i = 0; i < 7; i++){
      buttonList.add(new DayButton(text: list[i]));
    }
    return buttonList;
  }

  Widget _buildHeader(){
    return new Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        new Text("New Alarm", style: new TextStyle(color: new Color(0xff333333), fontFamily: 'ProductSansBold', fontSize: 24.0)),
        new IconButton(
          icon: new Icon(Icons.close, color: new Color(0xff888888), size: headerHeight),
          onPressed: (){widget.controller.reverse();}
        )
      ],
    );
  }
}

class CircleRevealPainter extends CustomPainter{
  Color circleColor;
  double radius;

  CircleRevealPainter({this.circleColor, this.radius});

  @override
  void paint(Canvas canvas, Size size) {
    Paint circle = new Paint()
      ..color = circleColor
      ..style = PaintingStyle.fill;

    Offset center  = new Offset(size.width/2, size.height/2);
    canvas.drawCircle(
        center,
        radius,
        circle
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}


class DayButton extends StatefulWidget{
  String text;
  bool enabled;
  DayButton({
    Key key,
    this.text,
    this.enabled : false
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => new DayButtonState();
}
class DayButtonState extends State<DayButton> with TickerProviderStateMixin{
  AnimationController animationController;
  CurvedAnimation curvedAnimation;

  @override
  void initState() {
    animationController = new AnimationController(duration: const Duration(milliseconds: 100), vsync: this);
    curvedAnimation = new CurvedAnimation(parent: animationController, curve: Curves.ease)
    ..addListener((){
      setState((){});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: new Container(
        child: new CustomCard(
          color: new Color.fromARGB(255, 210 + (curvedAnimation.value * 30).toInt(), 210 + (curvedAnimation.value * -18).toInt(), 210 + (curvedAnimation.value * -32).toInt()), //240,192,178 to 210,210,210
          child: Center(child: new Text(widget.text, style: new TextStyle(color: Colors.white, fontFamily: "ProductSansBold", fontSize: 18.0))),
          radius: new BorderRadius.circular(21.0),
          boxShadow: <BoxShadow>[
            new BoxShadow(
              color: new Color.fromARGB((curvedAnimation.value * 187).toInt(), 240, 192, 178),
              spreadRadius: 0.1 + curvedAnimation.value * 0.4,
              blurRadius: 1.0 + curvedAnimation.value * 4.0,
              offset: Offset(0.0, 1.0 + curvedAnimation.value * 2.0)
            )
          ],
        ),
        height: 42.0,
        width: 42.0,
      ),
      onTap: (){
        widget.enabled = !widget.enabled;

        if(widget.enabled){
          animationController.forward();
        }else{
          animationController.reverse();
        }
      },
    );
  }
}