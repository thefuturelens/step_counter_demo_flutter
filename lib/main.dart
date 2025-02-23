import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:step_counter_demo_flutter/config/app_string.dart';
import 'package:step_counter_demo_flutter/controller/home_controller.dart';
import 'package:step_counter_demo_flutter/sqflite/sqflite.dart';
import 'package:step_counter_demo_flutter/views/home_screen.dart';
import 'model/step_counter_model.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';

final SqfliteHelper helper = SqfliteHelper();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Permission.activityRecognition.request();
  await Permission.location.request();
  await Permission.camera.request();
  helper.initDB();
  await Permission.notification.isDenied.then((value) async {
    if (value) {
      await Permission.notification.request();
    }
  });
  await initializeService();
  runApp(const MyApp());
}

const notificationChannelId = 'my_foreground';
const notificationId = 888;

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'my_foreground', // id
    'MY FOREGROUND SERVICE', // title
    description: 'This channel is used for important notifications.',
    importance: Importance.low,
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  if (Platform.isIOS || Platform.isAndroid) {
    await flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        iOS: DarwinInitializationSettings(),
        android: AndroidInitializationSettings('ic_bg_service_small'),
      ),
    );
  }

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: true,
      isForegroundMode: true,
      notificationChannelId: 'my_foreground',
      initialNotificationTitle: 'AWESOME SERVICE',
      initialNotificationContent: 'Initializing',
      foregroundServiceNotificationId: 888,
    ),
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: onStart,
      // onBackground: onIosBackground,
    ),
  );
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  // DartPluginRegistrant.ensureInitialized();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Timer.periodic(const Duration(minutes: 1), (timer) async {
    if (service is AndroidServiceInstance) {
      if (await service.isForegroundService()) {
        try {
          final controller = HomeController();

          controller.getData().whenComplete(() async {
            SharedPreferences preferences =
                await SharedPreferences.getInstance();
            await preferences.reload();
            var totalStepCount = preferences.getInt("total_step_count") ?? 0;
            var totalHeartRate =
                preferences.getString("total_heart_rate") ?? "";
            var stepC = StepCounterModel(
              step: totalStepCount.toString(),
              time: DateTime.now().toString(),
              heartBeat: totalHeartRate.toString(),
            );
            helper.insertStep(stepC);
            flutterLocalNotificationsPlugin.show(
              notificationId,
              AppString.stepCounter,
              'Step ${totalStepCount.toString()}, Time ${DateTime.now().toString()}, HeartBeat ${totalHeartRate.toString()}',
              const NotificationDetails(
                android: AndroidNotificationDetails(
                  notificationChannelId,
                  'MY FOREGROUND SERVICE',
                  // icon: 'ic_bg_service_small',
                  ongoing: true,
                ),
              ),
            );
          });
        } catch (e) {
          if (kDebugMode) {
            print(e);
          }
        } finally {}
      }
    }
  });
}
// @pragma('vm:entry-point')
// void onStart(ServiceInstance service) async {
//   // DartPluginRegistrant.ensureInitialized();
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();
//
//   Timer.periodic(const Duration(seconds: 10), (timer) async {
//     if (service is AndroidServiceInstance) {
//       if (await service.isForegroundService()) {
//         try {
//           SharedPreferences preferences = await SharedPreferences.getInstance();
//           await preferences.reload();
//           final bpmVal = preferences.getString('heart_rate') ?? "";
//
//           Pedometer.stepCountStream.listen((event) {
//             var stepC = StepCounterModel(
//               step: event.steps.toString(),
//               time: DateTime.now().toString(),
//               heartBeat: bpmVal,
//             );
//             helper.insertStep(stepC);
//             flutterLocalNotificationsPlugin.show(
//               notificationId,
//               'Step Counter',
//               'Step ${event.steps.toString()}, Time ${DateTime.now().toString()}, HeartBeat $bpmVal',
//               const NotificationDetails(
//                 android: AndroidNotificationDetails(
//                   notificationChannelId,
//                   'MY FOREGROUND SERVICE',
//                   // icon: 'ic_bg_service_small',
//                   ongoing: true,
//                 ),
//               ),
//             );
//           });
//         } catch (e) {
//           if (kDebugMode) {
//             print(e);
//           }
//         } finally {}
//       }
//     }
//   });
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppString.stepCounterDemo,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}
