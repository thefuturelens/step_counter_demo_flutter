class StepCounterModel {
  final int? id;
  final String step;
  final String time;
  final String heartBeat;

  StepCounterModel({
    this.id,
    required this.step,
    required this.time,
    required this.heartBeat,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'step': step,
      'time': time,
      'heartBeat': heartBeat,
    };
  }

  @override
  String toString() {
    return 'Step{id: $id, step: $step, time: $time, heartBeat : $heartBeat}';
  }
}
