import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:step_counter_demo_flutter/sqflite/sqflite.dart';
import 'package:workmanager/workmanager.dart';
import 'model/step_counter_model.dart';
import 'views/pedometer_screen.dart';

final SqfliteHelper helper = SqfliteHelper();
const simplePeriodicTask =
    "be.tramckrijte.workmanagerExample.simplePeriodicTask";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Permission.activityRecognition.request();
  helper.initDB();
  await Permission.notification.isDenied.then((value) async {
    if (value) {
      await Permission.notification.request();
    }
  });

  await Workmanager().initialize(
    callbackDispatcher,
  );
  await Workmanager().registerPeriodicTask(
    simplePeriodicTask,
    simplePeriodicTask,
    frequency: const Duration(seconds: 1),
  );
  runApp(const MyApp());
}

@pragma(
    'vm:entry-point') // Mandatory if the App is obfuscated or using Flutter 3.1+
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      var stepC = StepCounterModel(
        step: controller.steps.value,
        time: controller.timeStamp.value,
      );
      helper.insertStep(stepC);
      List<StepCounterModel> record = await helper.getStep();
      for (int i = 0; i < record.length; i++) {
        print("id--->${record[i].id}");
        print("time--->${record[i].time}");
        print("step--->${record[i].step}");
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    } finally {
      print("Finally call-->");
    }
    return Future.value(true);
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PedometerScreen(),
    );
  }
}
