class StepCounterModel {
  final int? id;
  final String step;
  final String time;

  StepCounterModel({
    this.id,
    required this.step,
    required this.time,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'step': step,
      'time': time,
    };
  }

  @override
  String toString() {
    return 'Step{id: $id, step: $step, time: $time}';
  }
}
