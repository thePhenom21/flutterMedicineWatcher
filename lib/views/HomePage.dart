import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medicineapp/views/MedicineCard.dart';
import '../model/Medicine.dart';

List<Medicine> medicines = [];
var db = FirebaseFirestore.instance;
var usr = "";

class HomePage extends StatefulWidget {
  String userId = "";
  HomePage({Key? key, required this.userId}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TimeOfDay? time = null;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    usr = widget.userId;
    db.collection("medicines").get().then((value) {
      for (var val in value.docs) {
        try {
          if (usr == val.get("userId")) {
            Medicine med = Medicine(
                val.get("id"),
                val.get("name"),
                val.get("amount"),
                Medicine.getTimeOfDay(val.get("time"))!,
                val.get("userId"));
            setState(() {
              medicines.add(med);
            });
          }
        } catch (err) {
          print(err);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Text("${widget.userId}"),
          Expanded(
            child: ListView.builder(
                itemCount: medicines.length,
                itemBuilder: (BuildContext context, int index) {
                  Medicine med = medicines.elementAt(index);
                  return MedicineCard(
                    med: medicines.elementAt(index),
                    onClick: () {
                      setState(() {
                        removeMedicine(med);
                      });
                    },
                  );
                }),
          ),
          ElevatedButton(
              onPressed: () {
                setState(() async {
                  await showDialog(
                      context: context,
                      builder: (context) {
                        return MedicineDialog(callback: (Medicine med) {
                          setState(() {
                            createMedicine(med);
                          });
                        });
                      });
                });
                print("hey");
              },
              child: Text("Add Medicine"))
        ],
      ),
    );
  }
}

class MedicineDialog extends StatefulWidget {
  Function callback;
  MedicineDialog({super.key, required this.callback});

  @override
  State<MedicineDialog> createState() => _MedicineDialogState();
}

class _MedicineDialogState extends State<MedicineDialog> {
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerAmount = TextEditingController();
  TimeOfDay? time = null;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Add a medicine"),
      content: SizedBox(
        height: 100,
        child: Column(
          children: [
            TextField(
                decoration: InputDecoration(hintText: "Name:"),
                controller: controllerName),
            TextField(
                decoration: InputDecoration(hintText: "Amount:"),
                controller: controllerAmount)
          ],
        ),
      ),
      actions: [
        FloatingActionButton(
          onPressed: () async {
            time = await showDialog(
                context: context,
                builder: (context) {
                  return TimePicker();
                });
          },
          child: Text("Time"),
        ),
        FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pop();
            time ??= TimeOfDay.now();
            widget.callback(Medicine("", controllerName.value.text,
                controllerAmount.value.text, time!, usr));
            controllerName.clear();
            controllerAmount.clear();
            time = null;
          },
          child: Text("Accept"),
        )
      ],
    );
  }
}

class TimePicker extends StatelessWidget {
  const TimePicker({super.key});

  @override
  Widget build(BuildContext context) {
    return TimePickerDialog(initialTime: TimeOfDay.now());
  }
}

createMedicine(Medicine med) async {
  medicines.add(med);
  final medicine = <String, String>{
    "id": "${med.id}",
    "name": "${med.name}",
    "amount": "${med.amount}",
    "time": "${Medicine.getStringTime(med.time!)}",
    "userId": "${med.userId}"
  };

  var autoId = db.collection("medicines").add(medicine);
  med.id = await autoId.then((value) => value.id);
}

removeMedicine(Medicine med) {
  db.collection("medicines").doc(med.id).delete();
  medicines.remove(med);
}
