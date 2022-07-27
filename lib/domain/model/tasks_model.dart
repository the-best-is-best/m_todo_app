class TasksModel {
  final int id;
  final String title;
  final String description;
  final String date;
  final String startTime;
  final String endTime;
  final int status;
  final int fav;
  final int remind;
  final String color;

  TasksModel(
      {required this.id,
      required this.title,
      required this.description,
      required this.date,
      required this.startTime,
      required this.endTime,
      required this.status,
      required this.fav,
      required this.remind,
      required this.color});

  static TasksModel fromJson(Map json) {
    return TasksModel(
        id: json['id'],
        title: json['title'],
        description: json['description'] ?? "",
        date: json['date'],
        status: json['status'],
        startTime: json['startTime'],
        endTime: json['endTime'],
        fav: json['fav'],
        remind: json['remind'],
        color: json['color']);
  }

  static TasksModel fromJsonString(Map<String, String> json) {
    return TasksModel(
        id: int.parse(json['id'] ?? '0'),
        title: json['title'].toString(),
        description: json['description'] ?? "",
        date: json['date'].toString(),
        status: int.parse(json['status'] ?? "0"),
        startTime: json['startTime'].toString(),
        endTime: json['endTime'].toString(),
        fav: int.parse(json['fav'] ?? "0"),
        remind: int.parse(json['remind'] ?? "0"),
        color: json['color'].toString());
  }

  static Map<String, String> toJsonString(TasksModel taskData) {
    return {
      'id': taskData.id.toString(),
      'title': taskData.title,
      'description': taskData.description,
      'date': taskData.date,
      'status': taskData.status.toString(),
      'startTime': taskData.startTime,
      'endTime': taskData.endTime,
      'fav': taskData.fav.toString(),
      'remind': taskData.remind.toString(),
      'color': taskData.color
    };
  }
}
