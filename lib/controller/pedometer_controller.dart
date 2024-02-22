import 'package:get/get.dart';
import 'package:heart_bpm/heart_bpm.dart';
import 'package:pedometer/pedometer.dart';
import 'package:step_counter_demo_flutter/config/app_string.dart';
import '../model/step_counter_model.dart';

class PedometerController extends GetxController {
  Rx<Stream<StepCount>>? stepCountStream;
  Rx<Stream<PedestrianStatus>>? pedestrianStatusStream;
  RxString status = '-'.obs, steps = '-'.obs;
  RxList<StepCounterModel> record = <StepCounterModel>[].obs;
  RxList<SensorValue> data = <SensorValue>[].obs;
  RxBool isBPMEnabled = false.obs;
  RxInt bpmValue = 0.obs;

  @override
  void onInit() {
    // initPlatformState();
    super.onInit();
  }

  void onStepCount(StepCount event) async {
    steps.value = event.steps.toString();

    update();
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    print(event);

    status.value = event.status;
    update();
  }

  void onPedestrianStatusError(error) {
    print('onPedestrianStatusError: $error');

    status.value = AppString.pedestrianStatusNotAvailable;
    update();
  }

  void onStepCountError(error) {
    print('onStepCountError: $error');

    steps.value = AppString.stepCountNotAvailable;
    update();
  }

  void initPlatformState() {
    pedestrianStatusStream?.value = Pedometer.pedestrianStatusStream;
    pedestrianStatusStream?.value
        .listen(onPedestrianStatusChanged)
        .onError(onPedestrianStatusError);

    stepCountStream?.value = Pedometer.stepCountStream;
    stepCountStream?.value.listen(onStepCount).onError(onStepCountError);

    // if (!mounted) return;
  }

  updateMethod() {
    update();
  }
}
