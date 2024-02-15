import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pedometer/pedometer.dart';
import 'package:step_counter_demo_flutter/config/app_string.dart';
import 'package:step_counter_demo_flutter/controller/pedometer_controller.dart';

PedometerController controller = Get.put(PedometerController());

class PedometerScreen extends StatefulWidget {
  const PedometerScreen({Key? key}) : super(key: key);

  @override
  State<PedometerScreen> createState() => _PedometerScreenState();
}

class _PedometerScreenState extends State<PedometerScreen> {
  Stream<StepCount>? _stepCountStream;
  Stream<PedestrianStatus>? _pedestrianStatusStream;
  String _status = '?', _steps = '?';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  void onStepCount(StepCount event) {
    setState(() {
      _steps = event.steps.toString();
      controller.steps.value = _steps;
      controller.timeStamp.value = event.timeStamp.toString();
    });
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    setState(() {
      _status = event.status;
    });
  }

  void onPedestrianStatusError(error) {
    print('onPedestrianStatusError: $error');
    setState(() {
      _status = AppString.pedestrianStatusNotAvailable;
    });
  }

  void onStepCountError(error) {
    print('onStepCountError: $error');
    setState(() {
      _steps = AppString.stepCountNotAvailable;
    });
  }

  void initPlatformState() {
    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
    _pedestrianStatusStream
        ?.listen(onPedestrianStatusChanged)
        .onError(onPedestrianStatusError);

    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream?.listen(onStepCount).onError(onStepCountError);

    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text(AppString.stepCounter),
        ),
        body: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                AppString.pleaseWalk,
                style: TextStyle(fontSize: 20),
              ),
            ),
            Center(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    const SizedBox(
                      height: 30,
                    ),
                    const Text(
                      AppString.stepTaken,
                      style: TextStyle(fontSize: 24),
                    ),
                    Text(
                      _steps,
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    const Text(
                      AppString.pedestrianStatus,
                      style: TextStyle(fontSize: 24),
                    ),
                    Icon(
                      _status == 'walking'
                          ? Icons.directions_walk
                          : _status == 'stopped'
                              ? Icons.accessibility_new
                              : Icons.error,
                      size: 50,
                    ),
                    Center(
                      child: Text(
                        _status,
                        style: _status == 'walking' || _status == 'stopped'
                            ? const TextStyle(fontSize: 20)
                            : const TextStyle(fontSize: 20, color: Colors.red),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
