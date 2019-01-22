import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'HelperClasses.dart';
import 'package:flutter/foundation.dart';


class AppDataHandler{
  AppDataListener listener;
  AlarmDataParser parser;

  AppDataHandler(AppDataListener listener){
    this.listener = listener;
    this.parser = new AlarmDataParser();
  }

  Future<String> get _localPath async {
    Directory directory = await getApplicationDocumentsDirectory();
    bool exists = await directory.exists();
    if(!exists){directory = await directory.create();}
    return directory.path;
  }

  Future<File> get _alarmDataFile async {
    final path = await _localPath;
    File file = File('$path/alarmdata.txt');
    bool exists = await file.exists();
    if(!exists){file = await file.create();}
    return file;
  }

  void loadAlarms() async {
    final file = await _alarmDataFile;
    final data = await file.readAsString();

    if(data.length > 0){
      List<AlarmData> result = parser.parseAlarmJSON(data);
      listener.onDataLoaded(result);
    }
  }

  void saveAlarms(List<AlarmData> newList) async {
    final file = await _alarmDataFile;
    final data = parser.encodeList(newList);
    file.writeAsString(data);
  }
}

class AppDataListener{
  final ValueChanged<List<AlarmData>> onDataLoaded;
  const AppDataListener({
    this.onDataLoaded
  });
}

class AlarmDataParser{
  List<AlarmData> parseAlarmJSON(String alarmJSON){
    List<AlarmData> newList = [];

    List<dynamic> alarms = json.decode(alarmJSON);
    alarms.forEach((map){
      AlarmData newAlarm = new AlarmData(map['timeString'], map['hour'], map['minute'], map['enabled']);
      newList.add(newAlarm);
    });

    return newList;
  }

  String encodeList(List<AlarmData> alarmList){
    List<dynamic> encodedList = [];
    alarmList.forEach((data){
      encodedList.add({
        'timeString' : data.timeString,
        'hour' : data.hour,
        'minute' : data.minute,
        'enabled' : data.enabled
      });
    });
    var result = json.encode(encodedList);
    return result;
  }
}