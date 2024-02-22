import 'dart:async';

import 'package:flutter/material.dart';
import 'package:heart_bpm/heart_bpm.dart';
import 'package:pedometer/pedometer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:step_counter_demo_flutter/config/app_string.dart';
import 'package:step_counter_demo_flutter/main.dart';

import '../model/step_counter_model.dart';

// class PedometerScreen extends StatelessWidget {
//   PedometerScreen({Key? key}) : super(key: key);
//   PedometerController controller = Get.put(PedometerController());
//
//   @override
//   Widget build(BuildContext context) {
//     Timer.periodic(const Duration(seconds: 10), ((timer) async {
//       controller.getStoreData();
//     }));
//
//     return Scaffold(
//       appBar: AppBar(),
//       body: SingleChildScrollView(
//         child: Obx(
//           () => Center(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 10),
//               child: Column(
//                 children: [
//                   Row(
//                     children: [
//                       Expanded(
//                         child: Column(
//                           children: [
//                             StreamBuilder(
//                               stream: Pedometer.stepCountStream,
//                               builder: (context, snapshot) {
//                                 return Column(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: <Widget>[
//                                     const Text(
//                                       AppString.stepTaken,
//                                       style: TextStyle(fontSize: 20),
//                                     ),
//                                     Text(
//                                       "${snapshot.data?.steps}",
//                                       style: const TextStyle(fontSize: 20),
//                                     ),
//                                   ],
//                                 );
//                                 // Text("${snapshot.data}");
//                               },
//                             ),
//                             const SizedBox(
//                               height: 40,
//                             ),
//                             StreamBuilder(
//                                 stream: Pedometer.pedestrianStatusStream,
//                                 builder: (context, snapshot) {
//                                   return Column(
//                                     children: [
//                                       const Text(
//                                         AppString.pedestrianStatus,
//                                         style: TextStyle(fontSize: 20),
//                                       ),
//                                       Icon(
//                                         snapshot.data?.status == 'walking'
//                                             ? Icons.directions_walk
//                                             : snapshot.data?.status == 'stopped'
//                                                 ? Icons.accessibility_new
//                                                 : Icons.error,
//                                         size: 30,
//                                       ),
//                                       Center(
//                                         child: Text(
//                                           "${snapshot.data?.status}",
//                                           style: snapshot.data?.status ==
//                                                       'walking' ||
//                                                   snapshot.data?.status ==
//                                                       'stopped'
//                                               ? const TextStyle(fontSize: 20)
//                                               : const TextStyle(
//                                                   fontSize: 20,
//                                                   color: Colors.red),
//                                         ),
//                                       )
//                                     ],
//                                   );
//                                 }),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(
//                         width: 20,
//                       ),
//                       Expanded(
//                         child: Column(
//                           children: [
//                             const SizedBox(
//                               height: 30,
//                             ),
//                             controller.isBPMEnabled.value
//                                 ? HeartBPMDialog(
//                                     context: context,
//                                     onRawData: (value) {
//                                       if (controller.data.length == 100) {
//                                         controller.data.removeAt(0);
//                                       }
//                                       controller.data.add(value);
//                                     },
//                                     onBPM: (value) async {
//                                       controller.bpmValue.value = value;
//                                     })
//                                 : const SizedBox(),
//                             const SizedBox(
//                               height: 10,
//                             ),
//                             Center(
//                               child: ElevatedButton.icon(
//                                   icon: const Icon(
//                                     Icons.favorite_rounded,
//                                     color: Colors.blue,
//                                   ),
//                                   label: Text(
//                                     controller.isBPMEnabled.value
//                                         ? AppString.stopMeasurement
//                                         : AppString.measureBPM,
//                                     style: const TextStyle(color: Colors.blue),
//                                   ),
//                                   onPressed: () async {
//                                     controller.isBPMEnabled.value =
//                                         !controller.isBPMEnabled.value;
//                                     if (controller.isBPMEnabled.value ==
//                                         false) {
//                                       SharedPreferences preferences =
//                                           await SharedPreferences.getInstance();
//                                       await preferences.setString("heart_rate",
//                                           controller.bpmValue.value.toString());
//                                     }
//                                   }
//                                   ),
//                             ),
//                             Text(controller.bpmValue.value > 30 &&
//                                     controller.bpmValue.value < 150
//                                 ? "${AppString.estimatedBPM} : ${controller.bpmValue.value}"
//                                 : "--")
//                             // Text(
//                             //     "${AppString.bpmValue} :${controller.bpmValue.value}"),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(
//                     height: 25,
//                   ),
//                   Obx(
//                     () => ListView.builder(
//                         physics: const ScrollPhysics(),
//                         shrinkWrap: true,
//                         itemCount: controller.record.length,
//                         itemBuilder: (context, index) {
//                           return Padding(
//                             padding: const EdgeInsets.only(bottom: 10),
//                             child: Column(
//                               children: [
//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Row(
//                                       children: [
//                                         const Text(AppString.step),
//                                         Text(controller.record[index].step ==
//                                                     "-" ||
//                                                 controller.record[index].step ==
//                                                     "?"
//                                             ? "0"
//                                             : controller.record[index].step),
//                                       ],
//                                     ),
//                                     Row(
//                                       children: [
//                                         const Text(AppString.time),
//                                         Text(controller.record[index].time),
//                                       ],
//                                     )
//                                   ],
//                                 ),
//                                 Row(
//                                   children: [
//                                     const Text(AppString.heartBeat),
//                                     Text(controller.record[index].heartBeat),
//                                   ],
//                                 )
//                               ],
//                             ),
//                           );
//                         }),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

class PedometerScreen extends StatefulWidget {
  const PedometerScreen({Key? key}) : super(key: key);

  @override
  State<PedometerScreen> createState() => _PedometerScreenState();
}

class _PedometerScreenState extends State<PedometerScreen> {
  Stream<StepCount>? _stepCountStream;
  Stream<PedestrianStatus>? _pedestrianStatusStream;
  String _status = '-', _steps = '-';
  List<StepCounterModel> record = <StepCounterModel>[];
  List<SensorValue> data = [];
  bool isBPMEnabled = false;
  int bpmValue = 0;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  void onStepCount(StepCount event) {
    setState(() {
      _steps = event.steps.toString();
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

  getStoreData() async {
    record = await helper.getStep();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    getStoreData();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(AppString.stepCounter),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: <Widget>[
                      const SizedBox(
                        height: 30,
                      ),
                      const Text(
                        AppString.stepTaken,
                        style: TextStyle(fontSize: 20),
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
                        style: TextStyle(fontSize: 20),
                      ),
                      Icon(
                        _status == 'walking'
                            ? Icons.directions_walk
                            : _status == 'stopped'
                                ? Icons.accessibility_new
                                : Icons.error,
                        size: 30,
                      ),
                      Center(
                        child: Text(
                          _status,
                          style: _status == 'walking' || _status == 'stopped'
                              ? const TextStyle(fontSize: 20)
                              : const TextStyle(
                                  fontSize: 20, color: Colors.red),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      isBPMEnabled
                          ? HeartBPMDialog(
                              context: context,
                              onRawData: (value) {
                                setState(() {
                                  if (data.length == 100) {
                                    data.removeAt(0);
                                  }
                                  data.add(value);
                                });
                              },
                              onBPM: (value) async {
                                setState(() {
                                  bpmValue = value;
                                });
                              })
                          : const SizedBox(),
                      const SizedBox(
                        height: 10,
                      ),

                      Center(
                        child: ElevatedButton.icon(
                            icon: const Icon(
                              Icons.favorite_rounded,
                              color: Colors.blue,
                            ),
                            label: Text(
                              isBPMEnabled
                                  ? AppString.stopMeasurement
                                  : AppString.measureBPM,
                              style: const TextStyle(color: Colors.blue),
                            ),
                            onPressed: () async {
                              isBPMEnabled = !isBPMEnabled;
                              if (isBPMEnabled == false) {
                                SharedPreferences preferences =
                                    await SharedPreferences.getInstance();
                                await preferences.setString(
                                    "heart_rate", bpmValue.toString());
                              }
                            }),
                      ),
                      Text(bpmValue > 30 && bpmValue < 150
                          ? "${AppString.estimatedBPM} : $bpmValue"
                          : "--")

                      // Text("${AppString.bpmValue} :$bpmValue"),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 25,
            ),
            Expanded(
              child: ListView.builder(
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: record.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Text(AppString.step),
                                  Text(record[index].step == "-" ||
                                          record[index].step == "?"
                                      ? "0"
                                      : record[index].step),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text(AppString.time),
                                  Text(record[index].time),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Text(AppString.heartBeat),
                              Text(record[index].heartBeat),
                            ],
                          )
                        ],
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
