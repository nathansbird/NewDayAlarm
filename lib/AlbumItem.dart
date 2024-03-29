import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'HelperClasses.dart';
import 'PageTransformer.dart';
import 'main.dart';
import 'package:http/http.dart' as http;

class AlbumItemWidget extends StatefulWidget {
  AlbumItemWidget({
    @required this.item,
    @required this.pageVisibility,
  });

  final CarouselItem item;
  final PageVisibility pageVisibility;

  @override
  State<StatefulWidget> createState() => new AlbumItemWidgetState();
}

class SeeMoreButton extends StatefulWidget {
  SeeMoreButton({
    @required this.pageVisibility,
  });

  final PageVisibility pageVisibility;

  @override
  State<StatefulWidget> createState() => new SeeMoreButtonState();
}

class AlbumItemWidgetState extends State<AlbumItemWidget> {

  Widget _applyTextEffects({@required double translationFactor, @required Widget child,}) {
    final double xTranslation = widget.pageVisibility.pagePosition * translationFactor;
    return new Opacity(
      opacity: widget.pageVisibility.visibleFraction,
      child: new Transform(
        alignment: FractionalOffset.topLeft,
        transform: new Matrix4.translationValues(
          xTranslation,
          0.0,
          0.0,
        ),
        child: child,
      ),
    );
  }

  _buildTextContainer(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final artistText = _applyTextEffects(
        translationFactor: -75.0,
        child: widget.item.icon == null ? new Text(widget.item.artist, style: textTheme.caption.copyWith(color: Colors.white70, fontWeight: FontWeight.bold, letterSpacing: 2.0, fontSize: 14.0), textAlign: TextAlign.center,) : new Icon(Icons.arrow_back, color: Colors.white)
    );

    final titleText = _applyTextEffects(
      translationFactor: -45.0,
      child: new Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: new Text(
          widget.item.title,
          style: textTheme.headline6.copyWith(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.5),
          textAlign: TextAlign.center,
        ),
      ),
    );

    return new Positioned(
      bottom: 24.0,
      left: 16.0,
      right: 16.0,
      child: new Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          artistText,
          titleText,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [];

    var loader = new Align(
        alignment: Alignment.center,
        child: new CircularProgressIndicator(value: null)
    );

    var imageOverlayGradient = new DecoratedBox(
      decoration: new BoxDecoration(
        gradient: new LinearGradient(
          begin: FractionalOffset.bottomCenter,
          end: FractionalOffset.topCenter,
          colors: [
            new Color.fromARGB((widget.pageVisibility.visibleFraction*120).toInt(), 0, 0, 0),
            const Color(0x00000000),
          ],
        ),
      ),
    );

    if(MyApp.cachedImages.containsKey(widget.item.imageURL)){
      widgets.add(MyApp.cachedImages[widget.item.imageURL]);
    }else{
      widget.item.setListener(new ImageDownloadListener(done: (){
        setState(() {});
      }));
    }

    widgets.add(imageOverlayGradient);
    widgets.add(_buildTextContainer(context));

    if(!MyApp.cachedImages.containsKey(widget.item.imageURL)){
      widgets.add(loader);
    }

    final dynamicPadding = new EdgeInsets.symmetric(
      vertical: 30.0 - (widget.pageVisibility.visibleFraction * 10),
      horizontal: 16.0,
    );

    return new Padding(
      padding: dynamicPadding,
      child: Center(
        child: new Container(
          child: new ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            child: new AspectRatio(
              aspectRatio: 1.0,
              child: new Stack(
                fit: StackFit.expand,
                children: widgets,
              ),
            ),
          ),
          decoration: new BoxDecoration(
              boxShadow: <BoxShadow>[new BoxShadow(
                  color: new Color(0x22000000),
                  spreadRadius: 0.1,
                  blurRadius: 20.0
              )]
          ),
        ),
      ),
    );
  }
}

class SeeMoreButtonState extends State<SeeMoreButton> {

  Widget _applyTextEffects({@required double translationFactor, @required Widget child,}) {
    final double xTranslation = widget.pageVisibility.pagePosition * translationFactor;
    return new Opacity(
      opacity: widget.pageVisibility.visibleFraction,
      child: new Transform(
        alignment: FractionalOffset.topLeft,
        transform: new Matrix4.translationValues(
          xTranslation,
          0.0,
          0.0,
        ),
        child: child,
      ),
    );
  }

  _buildTextContainer(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final artistText = _applyTextEffects(
        translationFactor: -75.0,
        child: new Icon(Icons.arrow_back, color: Colors.white)
    );

    final titleText = _applyTextEffects(
      translationFactor: -45.0,
      child: new Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: new Text(
          "See More",
          style: textTheme.headline6.copyWith(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.5),
          textAlign: TextAlign.center,
        ),
      ),
    );

    return new Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        artistText,
        titleText,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [];

    final dynamicPadding = new EdgeInsets.symmetric(
      vertical: 30.0 - (widget.pageVisibility.visibleFraction * 10),
      horizontal: 16.0,
    );

    var imageOverlayGradient = new DecoratedBox(
      decoration: new BoxDecoration(
        gradient: new LinearGradient(
          begin: FractionalOffset.bottomCenter,
          end: FractionalOffset.topCenter,
          colors: [
            new Color.fromARGB((widget.pageVisibility.visibleFraction*80).toInt(), 0, 0, 0),
            const Color(0x00000000),
          ],
        ),
      ),
    );

    widgets.add(new Container(color: const Color(0xffF0C0B2)));
    widgets.add(imageOverlayGradient);
    widgets.add(_buildTextContainer(context));

    return new Padding(
      padding: dynamicPadding,
      child: Center(
        child: new Container(
          child: new ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            child: new AspectRatio(
              aspectRatio: 1.0,
              child: new Stack(
                fit: StackFit.expand,
                children: widgets,
              ),
            ),
          ),
          decoration: new BoxDecoration(
              boxShadow: <BoxShadow>[new BoxShadow(
                  color: new Color(0x22000000),
                  spreadRadius: 0.1,
                  blurRadius: 20.0
              )]
          ),
        ),
      ),
    );
  }
}
