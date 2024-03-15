// import 'package:get/get.dart';
// import 'package:heart_bpm/heart_bpm.dart';
// import 'package:pedometer/pedometer.dart';
// import 'package:step_counter_demo_flutter/config/app_string.dart';
// import '../model/step_counter_model.dart';
//
// class PedometerController extends GetxController {
//   Rx<Stream<StepCount>>? stepCountStream;
//   Rx<Stream<PedestrianStatus>>? pedestrianStatusStream;
//   RxString status = '-'.obs, steps = '-'.obs;
//   RxList<StepCounterModel> record = <StepCounterModel>[].obs;
//   RxList<SensorValue> data = <SensorValue>[].obs;
//   RxBool isBPMEnabled = false.obs;
//   RxInt bpmValue = 0.obs;
//
//   @override
//   void onInit() {
//     // initPlatformState();
//     super.onInit();
//   }
//
//   void onStepCount(StepCount event) async {
//     steps.value = event.steps.toString();
//
//     update();
//   }
//
//   void onPedestrianStatusChanged(PedestrianStatus event) {
//     print(event);
//
//     status.value = event.status;
//     update();
//   }
//
//   void onPedestrianStatusError(error) {
//     print('onPedestrianStatusError: $error');
//
//     status.value = AppString.pedestrianStatusNotAvailable;
//     update();
//   }
//
//   void onStepCountError(error) {
//     print('onStepCountError: $error');
//
//     steps.value = AppString.stepCountNotAvailable;
//     update();
//   }
//
//   void initPlatformState() {
//     pedestrianStatusStream?.value = Pedometer.pedestrianStatusStream;
//     pedestrianStatusStream?.value
//         .listen(onPedestrianStatusChanged)
//         .onError(onPedestrianStatusError);
//
//     stepCountStream?.value = Pedometer.stepCountStream;
//     stepCountStream?.value.listen(onStepCount).onError(onStepCountError);
//
//     // if (!mounted) return;
//   }
//
//   updateMethod() {
//     update();
//   }
// }

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:step_counter_demo_flutter/model/step_counter_model.dart';
import 'package:health/health.dart';
import '../main.dart';

class HomeController extends GetxController {
  RxBool requestedPermission = false.obs;
  RxList<StepCounterModel> record = <StepCounterModel>[].obs;
  HealthFactory health = HealthFactory(useHealthConnectIfAvailable: true);
  RxInt totalStepCount = 0.obs;
  RxString totalHeartRate = "".obs;

  getData() async {
    await getFootSteep();
    await getHeartRate();
  }

  getFootSteep() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    // if (requestedPermission.value == true) {
    int record = await health.getTotalStepsInInterval(
            DateTime.now().subtract(const Duration(days: 1)), DateTime.now()) ??
        0;
    await preferences.setInt("total_step_count", record);
  }

  getHeartRate() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    // if (requestedPermission.value == true) {
    List<HealthDataPoint> healthData = await health.getHealthDataFromTypes(
        DateTime.now().subtract(const Duration(days: 1)),
        DateTime.now(),
        [HealthDataType.HEART_RATE]);
    if (healthData.isNotEmpty) {
      await preferences.setString(
          "total_heart_rate", healthData.last.value.toString());
    }
  }

  requestPermission() async {
    var record = await health.requestAuthorization([
      HealthDataType.STEPS,
      HealthDataType.HEART_RATE
    ], permissions: [
      HealthDataAccess.READ_WRITE,
      HealthDataAccess.READ_WRITE
    ]);
    getData();
  }

  getStoreData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.reload();
    record.value = await helper.getStep();
    totalStepCount.value = preferences.getInt("total_step_count") ?? 0;
    totalHeartRate.value = preferences.getString("total_heart_rate") ?? "";
    update();
  }
}
