import 'package:flutter/material.dart';
import 'main.dart';
import 'package:http/http.dart' as http;

class CarouselItem{
  final String imageURL;
  final String title;
  final String artist;
  final IconData icon;
  ImageDownloadListener listener;

  CarouselItem({
    Key key,
    this.imageURL,
    this.title : '',
    this.artist : '',
    this.icon
  });

  void cacheImage(){
    http.readBytes(Uri.parse(imageURL)).then((list){
        MyApp.cachedImages[imageURL] = Image.memory(list, fit: BoxFit.cover);
        if(listener != null){
          listener.done();
        }
    });
  }

  void setListener(ImageDownloadListener listener){
    this.listener = listener;
  }
}

class AlarmData{
  String timeString;
  int hour;
  int minute;
  bool enabled;

  AlarmData(String timeString, int hour, int minute, bool enabled){
    this.timeString = timeString;
    this.hour = hour;
    this.minute = minute;
    this.enabled = enabled;
  }
}

class ImageDownloadListener{
  final Function done;

  const ImageDownloadListener({
    this.done
  });
}