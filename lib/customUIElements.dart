import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'HelperClasses.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({
    Key key,
    this.color,
    this.child,
    @required this.radius,
    this.boxShadow : const <BoxShadow>[const BoxShadow(color: const Color(0x29000000), spreadRadius: 0.1, blurRadius: 20.0,)]
  }) : super(key: key);

  final Widget child;
  final Color color;
  final BorderRadius radius;
  final List<BoxShadow> boxShadow;

  @override
  Widget build(BuildContext context) {
    return new Semantics(
      container: true,
      child: new Container(
        child: new Material(
          shadowColor: new Color(0x66000000),
          color: color,
          type: MaterialType.card,
          elevation: 0.0,
          child: child,
          borderRadius: radius,
        ),
        decoration: new BoxDecoration(
          boxShadow: boxShadow,
          borderRadius: radius
        ),
      ),
    );
  }
}

class GradientCard extends StatelessWidget {
  const GradientCard({
    Key key,
    this.child,
    this.height,
    this.width,
    this.radius : 12.0,
    this.gradient
  }) : super(key: key);

  final Widget child;
  final double height;
  final double width;
  final double radius;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return new Semantics(
      container: true,
      child: new Container(
        child: new Material(
          shadowColor: new Color(0x00000000),
          color: Colors.white,
          type: MaterialType.card,
          elevation: 0.0,
          child: new Container(
            child: child,
            decoration: new BoxDecoration(gradient: gradient),
          ),
          borderRadius: new BorderRadius.circular(radius),
        ),
        height: height,
        width: width,
      )
    );
  }
}

class AlarmListItem extends StatefulWidget{
  final AlarmData from;
  final Function changeListener;

  const AlarmListItem({
    Key key,
    this.changeListener,
    this.from,
  });

  @override
  State<StatefulWidget> createState() => new AlarmListItemState();
}

class AlarmListItemState extends State<AlarmListItem>{

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle style = new TextStyle(color: new Color(0xff666666), fontSize: 24.0, fontFamily: 'ProductSansBold');
    final TextStyle style2 = new TextStyle(color: new Color(0xffaaaaaa), fontSize: 18.0, fontFamily: 'ProductSans');

    return new FractionallySizedBox(
      widthFactor: 1.0,
      child: new GradientCard(
        height: 68.0,
        gradient: new LinearGradient(
            colors: <Color>[Colors.white, Colors.white],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight
        ),
        child: new Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 2.0),
              child: new Text(widget.from.timeString.split(" ")[0], style: style),
            ),
            new Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: new Text(widget.from.timeString.split(" ")[1], style: style2),
              ),
            ),
            _buildNativeSwitch()
          ],
        ),
        radius: 5.0,
      ),
    );
  }

  Widget _buildNativeSwitch(){
    if(Theme.of(context).platform == TargetPlatform.iOS){
      return Padding(
        padding: const EdgeInsets.only(right: 12.0),
        child: new CupertinoSwitch(
          value: widget.from.enabled,
          onChanged: (bool){
            setState(() {
              widget.from.enabled = bool;
              widget.changeListener();
            });
          },
          activeColor: new Color.fromARGB(255, 240, 192, 178),
        ),
      );
    }else {
      return Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: new Switch(
          value: widget.from.enabled,
          onChanged: (bool){
            setState(() {
              widget.from.enabled = bool;
              widget.changeListener();
            });
          },
          activeColor: new Color.fromARGB(255, 240, 192, 178),
          activeTrackColor: new Color.fromARGB(110, 220, 172, 158),
        ),
      );
    }
  }
}