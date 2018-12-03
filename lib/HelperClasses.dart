import 'package:flutter/material.dart';

class CarouselItem{
  final String imageURL;
  final String title;
  final String artist;
  final IconData icon;

  const CarouselItem({
    Key key,
    this.imageURL,
    this.title : '',
    this.artist : '',
    this.icon
  });
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