import 'dart:ffi';
import 'dart:isolate';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';

import '../model/Medicine.dart';

class MedicineCard extends StatefulWidget {
  Medicine? med;
  Function onClick;
  MedicineCard(
      {Key? key, required Medicine this.med, required Function this.onClick})
      : super(key: key);

  @override
  _MedicineCardState createState() => _MedicineCardState();
}

class _MedicineCardState extends State<MedicineCard> {
  bool alarmSet = false;
  int? settings = null;

  @pragma('vm:entry-point')
  static void printHello() {
    final DateTime now = DateTime.now();
    final int isolateId = Isolate.current.hashCode;
    print("[$now] Hello, world! isolate=${isolateId} function='$printHello'");
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Row(
            children: [
              Text("Name: ${widget.med!.name!} "),
              Text("Amount: ${widget.med!.amount!} "),
              Text("Time: ${Medicine.getStringTime(widget.med!.time!)!}"),
            ],
          ),
          ElevatedButton(
              onPressed: () async {
                if (!alarmSet) {
                  settings =
                      await setAlarm(widget.med!.time!, widget.med.hashCode);
                  alarmSet = true;
                } else {
                  cancelAlarm(settings!);
                  alarmSet = false;
                }
              },
              child: Icon(Icons.alarm)),
          ElevatedButton(
              onPressed: () {
                widget.onClick();
                print("inner click");
              },
              child: Text("Took it"))
        ],
      ),
    );
  }

  Future<int?> setAlarm(TimeOfDay dateTime, int id) async {
    //TODO: ALARM SET
    await AndroidAlarmManager.periodic(Duration(days: 1), id, () {
      printHello();
    });
    return id;
  }
}

cancelAlarm(int alarm) {
  try {
    AndroidAlarmManager.cancel(alarm);
  } catch (err) {
    print(err);
  }
  //TODO: ALARM CANCEL
}
