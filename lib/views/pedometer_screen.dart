import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:step_counter_demo_flutter/config/app_string.dart';
import 'package:step_counter_demo_flutter/controller/pedometer_controller.dart';

PedometerController controller = Get.put(PedometerController());

class PedometerScreen extends StatelessWidget {
  PedometerScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Obx(
          () => SingleChildScrollView(
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  AppString.stepTaken,
                  style: TextStyle(fontSize: 30),
                ),
                Text(
                  controller.steps.value,
                  style: const TextStyle(fontSize: 60),
                ),
                const Divider(
                  height: 100,
                  thickness: 0,
                  color: Colors.white,
                ),
                const Text(
                  AppString.pedestrianStatus,
                  style: TextStyle(fontSize: 30),
                ),
                Icon(
                  controller.status.value == 'walking'
                      ? Icons.directions_walk
                      : controller.status.value == 'stopped'
                          ? Icons.accessibility_new
                          : Icons.error,
                  size: 100,
                ),
                Center(
                  child: Text(
                    controller.status.value,
                    style: controller.status.value == 'walking' ||
                            controller.status.value == 'stopped'
                        ? const TextStyle(fontSize: 30)
                        : const TextStyle(fontSize: 20, color: Colors.red),
                  ),
                )
              ],
            )),
          ),
        ));
  }
}
