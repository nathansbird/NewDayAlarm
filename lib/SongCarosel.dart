import 'package:flutter/material.dart';
import 'dart:core';
import 'customUIElements.dart';
import 'PageTransformer.dart';
import 'AlbumItem.dart';

class SongCarousel extends StatefulWidget{
  const SongCarousel({
    Key key,
    this.items,
  }) : super(key: key);

  final List<dynamic> items;

  @override
  State<StatefulWidget> createState() {
    return new SongCarouselState();
  }
}

class SongCarouselState extends State<SongCarousel>{

  @override
  Widget build(BuildContext context) {
    return new SizedBox.fromSize(
      size: Size.fromHeight(MediaQuery.of(context).size.width * 0.60 + 16.0),
      child: new PageTransformer(
        pageViewBuilder: (context, visibilityResolver) {
          return new PageView.builder(
            controller: new PageController(viewportFraction: 0.65),
            itemCount: widget.items.length,
            itemBuilder: (context, index) {
              final item = widget.items[index];
              final pageVisibility = visibilityResolver.resolvePageVisibility(index);

              return new AlbumItemWidget(
                item: item,
                pageVisibility: pageVisibility,
              );
            },
            reverse: true,
          );
        },
      )
    );
  }
}