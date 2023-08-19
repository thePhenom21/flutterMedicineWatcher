import 'package:flutter/material.dart';

class Medicine {
  String? id;
  String? name;
  String? amount;
  TimeOfDay? time;
  String? userId;
  Medicine(String this.id, String this.name, String this.amount,
      TimeOfDay this.time, String this.userId) {}

  static String? getStringTime(TimeOfDay time) {
    return "${time!.hour > 9 ? time!.hour : "0${time!.hour}"}:${time!.minute > 9 ? time!.minute : "0${time!.minute}"}";
  }

  static TimeOfDay? getTimeOfDay(String time) {
    final now = DateTime.now();
    DateTime n = DateTime(now.year, now.month, now.day,
        int.parse(time.substring(0, 2)), int.parse(time.substring(3, 5)));
    TimeOfDay k = TimeOfDay.fromDateTime(n);
    return k;
  }
}
