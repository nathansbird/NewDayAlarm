import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'HelperClasses.dart';
import 'PageTransformer.dart';

class AlbumItemWidget extends StatelessWidget {
  AlbumItemWidget({
    @required this.item,
    @required this.pageVisibility,
  });

  final CarouselItem item;
  final PageVisibility pageVisibility;

  Widget _applyTextEffects({@required double translationFactor, @required Widget child,}) {
    final double xTranslation = pageVisibility.pagePosition * translationFactor;
    return new Opacity(
      opacity: pageVisibility.visibleFraction,
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
      child: item.icon == null ? new Text(item.artist, style: textTheme.caption.copyWith(color: Colors.white70, fontWeight: FontWeight.bold, letterSpacing: 2.0, fontSize: 14.0), textAlign: TextAlign.center,) : new Icon(Icons.arrow_back, color: Colors.white)
    );

    final titleText = _applyTextEffects(
      translationFactor: -45.0,
      child: new Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: new Text(
          item.title,
          style: textTheme.title.copyWith(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.5),
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
    var image = new Image.network(
      item.imageURL,
      fit: BoxFit.cover,
    );

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
            new Color.fromARGB((pageVisibility.visibleFraction*120).toInt(), 0, 0, 0),
            const Color(0x00000000),
          ],
        ),
      ),
    );

    var textContainer = _buildTextContainer(context);

    final dynamicPadding = new EdgeInsets.symmetric(
      vertical: 30.0 - (pageVisibility.visibleFraction * 10),
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
                children: [
                  loader,
                  image,
                  imageOverlayGradient,
                  textContainer
                ],
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