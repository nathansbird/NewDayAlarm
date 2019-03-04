import 'package:flutter/material.dart';
import 'dart:core';
import 'PageTransformer.dart';
import 'AlbumItem.dart';
import 'package:http/http.dart' as http;

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
            itemCount: widget.items.length+1,
            itemBuilder: (context, index) {
              final pageVisibility = visibilityResolver.resolvePageVisibility(index);

              if(index == widget.items.length){
                return new SeeMoreButton(
                  pageVisibility: pageVisibility,
                );
              }else{
                final item = widget.items[index];
                return new AlbumItemWidget(
                  item: item,
                  pageVisibility: pageVisibility,
                );
              }
            },
            reverse: true,
          );
        },
      )
    );
  }
}