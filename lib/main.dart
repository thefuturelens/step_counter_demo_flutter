import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:step_counter_demo_flutter/sqflite/sqflite.dart';
import 'model/step_counter_model.dart';
import 'views/pedometer_screen.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';

final SqfliteHelper helper = SqfliteHelper();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Permission.activityRecognition.request();
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

  Timer.periodic(const Duration(minutes: 2), (timer) async {
    if (service is AndroidServiceInstance) {
      if (await service.isForegroundService()) {
        try {
          var stepC = StepCounterModel(
            step: controller.steps.value,
            time: DateTime.now().toString(),
          );
          helper.insertStep(stepC);
        } catch (e) {
          if (kDebugMode) {
            print(e);
          }
        } finally {}
        flutterLocalNotificationsPlugin.show(
          notificationId,
          'Step Counter',
          'Step ${controller.steps.value}, Time ${DateTime.now().toString()}',
          const NotificationDetails(
            android: AndroidNotificationDetails(
              notificationChannelId,
              'MY FOREGROUND SERVICE',
              // icon: 'ic_bg_service_small',
              ongoing: true,
            ),
          ),
        );
      }
    }
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PedometerScreen(),
    );
  }
}
