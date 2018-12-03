import 'package:flutter/material.dart';
import 'customUIElements.dart';

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
  Animation<double> fractionTween;
  CurvedAnimation curvedAnimation2;

  @override
  void initState() {
    CurvedAnimation curvedAnimation = new CurvedAnimation(parent: widget.controller, curve: Curves.ease);
    heightTween = new Tween(begin: 0.0, end: 400.0).animate(curvedAnimation);
    // No need to set a listener, there's already one in the main file
    // This just interpolates the value of the animation along a curve

    timePickerAnimator = new AnimationController(duration: const Duration(milliseconds: 250), vsync: this);
    curvedAnimation2 = new CurvedAnimation(parent: timePickerAnimator, curve: Curves.ease);
    fractionTween = new Tween(begin: 0.0, end: 200.0).animate(curvedAnimation2)
    ..addListener((){
      setState((){});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildPositioningWrapper(
      child: new Column(
        children: <Widget>[
          _buildHeader(),
          _buildAlarmPicker()
        ],
      ),
    );
  }

  Widget _buildPositioningWrapper({child}){
    return new Positioned(
      child: Padding(
        padding: const EdgeInsets.only(top: 24.0),
        child: new Transform(
          transform: new Matrix4.translationValues(0.0, 400.0 - heightTween.value, 0.0),
          child: new Container(
            child: new CustomCard(
              radius: new BorderRadius.only(topLeft: Radius.circular(24.0), topRight: Radius.circular(24.0)),
              child: child
            ),
            height: 384.0,
          ),
        ),
      ),
      bottom: 0.0,
      left: 0.0,
      right: 0.0,
    );
  }

  Widget _buildAlarmPicker(){
    return new Expanded(
      child: new Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new Expanded(
            child: _buildRepeatDayPicker(),
            flex: 200,
          ),
          new Expanded(
            child: _buildPickerContent(),
            flex: 200 - fractionTween.value.toInt(),
          ),
        ],
      )
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
    return new Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 14.0, bottom: 8.0),
      child: new Row(
        children: <Widget>[
          new Flexible(
            fit: FlexFit.tight,
            child: Padding(
              padding: const EdgeInsets.only(left: 14.0),
              child: new Text("New alarm", style: new TextStyle(color: new Color(0xff333333), fontFamily: 'ProductSansBold', fontSize: 24.0)),
            ),
          ),
          new IconButton(
              icon: new Icon(Icons.close, color: new Color(0xffaaaaaa), size: 28.0),
              onPressed: (){widget.controller.reverse();}
          )
        ],
      ),
    );
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