import 'package:get/get.dart';
import 'package:pedometer/pedometer.dart';
import 'package:step_counter_demo_flutter/config/app_string.dart';

class PedometerController extends GetxController {
  Rx<Stream<StepCount>>? stepCountStream;
  Rx<Stream<PedestrianStatus>>? pedestrianStatusStream;
  RxString status = '?'.obs,
      steps = '?'.obs,
      timeStamp = DateTime.now().toString().obs;

  @override
  void onInit() {
    // initPlatformState();
    super.onInit();
  }

  void onStepCount(StepCount event) async {
    steps.value = event.steps.toString();
    timeStamp.value = event.timeStamp.toString();
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    print(event);

    status.value = event.status;
  }

  void onPedestrianStatusError(error) {
    print('onPedestrianStatusError: $error');

    status.value = AppString.pedestrianStatusNotAvailable;
  }

  void onStepCountError(error) {
    print('onStepCountError: $error');

    steps.value = AppString.stepCountNotAvailable;
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
}
