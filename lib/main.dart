import 'package:flutter/material.dart';
import 'customUIElements.dart';
import 'CustomFAB.dart';
import 'SongCarosel.dart';
import 'HelperClasses.dart';
import 'AppDataHandler.dart';
import 'AlarmBuilderWrapper.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  static final Map<String, Image> cachedImages = new Map();

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Alarm App',
      home: new MyHomePage(title: 'Alarm App'),
      theme: new ThemeData(
        accentColor: new Color.fromARGB(255, 240, 192, 178),
        primaryColor: Colors.white,
        indicatorColor: new Color.fromARGB(255, 240, 192, 178)
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin{
  List<CarouselItem> carouselItems = [];
  List<AlarmData> alarms = [];
  AppDataHandler dataHandler;
  AnimationController animationController;

  @override
  void initState() {
    animationController = new AnimationController(duration: const Duration(milliseconds: 300), vsync: this)
      ..addListener((){setState((){});});

    loadLast7Songs();
    dataHandler = new AppDataHandler(
      new AppDataListener(
        onDataLoaded: (List<AlarmData> result){
          setState(() {
            alarms = result;
          });
        }
      )
    )..loadAlarms();
    super.initState();
  }

  void loadLast7Songs() async {
    List<CarouselItem> items = [
      new CarouselItem(title: "State Lines", artist: "Novo Amor", imageURL: "https://t2.genius.com/unsafe/576x576/https%3A%2F%2Fimages.genius.com%2F7a0421f23d2788c796a61e7030a4f6c1.640x640x1.jpg"),
      new CarouselItem(title: "Doria", artist: "Olafur Arnalds", imageURL: "https://i1.sndcdn.com/artworks-04Z42PgrtyHq-0-t500x500.jpg"),
      new CarouselItem(title: "Insight III", artist: "Julien Marchal", imageURL: "https://m.media-amazon.com/images/I/51aG6IPteKL._SS500_.jpg"),
      new CarouselItem(title: "Asos Model Crush", artist: "dné", imageURL: "https://f4.bcbits.com/img/a0610617275_16.jpg"),
      new CarouselItem(title: "Brot", artist: "Olafur Arnalds", imageURL: "https://i1.sndcdn.com/artworks-9QqAXgDwgFzA-0-t500x500.jpg"),
      new CarouselItem(title: "Palemote", artist: "Slow Meadow", imageURL: "https://m.media-amazon.com/images/I/71pZ2vdl3PL._SS500_.jpg"),
      new CarouselItem(title: "Small Memory", artist: "Jon Hopkins", imageURL: "https://t2.genius.com/unsafe/576x576/https%3A%2F%2Fimages.genius.com%2F2a0c89d4499bb8587d22f997ab1564cc.700x700x1.jpg")
    ];

    items.forEach((item){
      item.cacheImage();
    });

    setState((){carouselItems = items;});
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.black,
      body: new CustomCard(
        color: new Color(0xfff8f8f8),
        radius: new BorderRadius.all(Radius.circular(14.0)),
        child: new Stack(
          children: <Widget>[
            new Positioned(
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new Container(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 48.0, bottom: 16.0),
                      child: new Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 24.0),
                            child: new Icon(Icons.playlist_play, color: new Color(0xffaaaaaa), size: 28.0),
                          ),
                          new Flexible(
                            child: Center(child: new Text("Recent Songs", style: TextStyle(fontFamily: 'ProductSansBold', fontSize: 24.0, color: new Color.fromARGB(255, 180, 132, 118)))),
                            fit: FlexFit.tight,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 24.0),
                            child: new Icon(Icons.favorite_border, color: new Color(0xffaaaaaa)),
                          ),
                        ],
                        crossAxisAlignment: CrossAxisAlignment.center,
                      ),
                    ),
                    decoration: new BoxDecoration(
                      boxShadow: <BoxShadow>[new BoxShadow(
                          color: new Color(0x0a000000),
                          spreadRadius: 0.1,
                          blurRadius: 10.0
                      )],
                      color: new Color(0xffffffff),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0, bottom: 12.0),
                    child: new SongCarousel(
                      items: carouselItems
                    ),
                  ),
                  new Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 0.0),
                      child: new Container(
                        child: new Stack(
                          children: <Widget>[
                            _buildListView(),
                          ],
                        ),
                        decoration: new BoxDecoration(
                          boxShadow: <BoxShadow>[new BoxShadow(
                              color: new Color(0x0a000000),
                              spreadRadius: 0.1,
                              blurRadius: 10.0
                          )],
                          color: new Color(0xffffffff),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              top: 0.0,
              left: 0.0,
              right: 0.0,
              bottom: 0.0,
            ),
            new Positioned(
              child: new IgnorePointer(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: new LinearGradient(
                      colors: <Color>[new Color(0xfff8f8f8), new Color(0x00f8f8f8)],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter
                    )
                  ),
                  height: 128.0,
                ),
              ),
              bottom: 0.0,
              left: 0.0,
              right: 0.0,
            ),
            new Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 32.0),
                  child: new Container(
                    child: new CustomFloatingActionButton.extended(
                        onPressed: (){
                          setState((){
                            animationController.forward();
                          });
                        },
                        icon: new Icon(Icons.add, color: Colors.white),
                        label: new Text('Add a new alarm', style: TextStyle(letterSpacing: 0.5, fontFamily: 'ProductSans', fontSize: 16.0, color: Colors.white)),
                        backgroundColor: new Color.fromARGB(255, 240, 192, 178),
                        highlightElevation: 4.0,
                        elevation: 2.0,
                        splashColor: new Color.fromARGB(100, 255, 255, 255)
                    ),
                  ),
                )
            ),
            new AlarmBuilderWrapper(animationController: animationController)
          ],
        )
      )
    );
  }

  Widget _buildListView(){
    if(alarms.length > 0){
      return new ListView.builder(
        itemCount: (alarms.length*2)-1,
        itemBuilder: (context, i){
          return _buildAlarm(alarms[i ~/ 2], i);
        },
        padding: EdgeInsets.only(bottom: 96.0),
      );
    }else{
      return new Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.only(top: 32.0),
          child: new Text(
            "Create an alarm to get started",
            style: new TextStyle(fontFamily: "ProductSans", fontSize: 18.0, color: new Color(0xff888888))
          ),
        ),
      );
    }
  }

  Widget _buildAlarm(AlarmData data, int i){
    return i.isOdd ? Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
      child: new Divider(height: 0.0, color: new Color(0xffbbbbbb)),
    ) : new AlarmListItem(from: data, changeListener: onAlarmChanged);
  }

  void onAlarmChanged(){
    dataHandler.saveAlarms(alarms);
  }
}
