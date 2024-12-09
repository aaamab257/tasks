class TaskModel {
  String id;
  String title;
  String description;
  DateTime? startDateTime;
  DateTime? stopDateTime;
  bool completed;
  String? startTime ;
  String? endTime ;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.startDateTime,
    required this.stopDateTime,
    required this.startTime,
    required this.endTime,
    this.completed = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'completed': completed,
      'startDateTime': startDateTime?.toIso8601String(),
      'stopDateTime': stopDateTime?.toIso8601String(),
      'startTime': startTime,
      'endTime': endTime,
    };
  }


  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      completed: json['completed'],
      startDateTime: DateTime.parse(json['startDateTime']),
      stopDateTime: DateTime.parse(json['stopDateTime']),
      startTime: json['startTime'],
      endTime: json['endTime'],
    );
  }

  @override
  String toString() {
    return 'TaskModel{id: $id, title: $title, description: $description, '
        'startDateTime: $startDateTime, stopDateTime: $stopDateTime, '
        'completed: $completed , startTime: $startTime, endTime: $endTime}';
  }
}
