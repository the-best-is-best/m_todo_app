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

  static Map toJsonString(TasksModel taskData) {
    return {
      'id': taskData.id,
      'title': taskData.title,
      'description': taskData.description,
      'date': taskData.date,
      'status': taskData.status,
      'startTime': taskData.startTime,
      'endTime': taskData.endTime,
      'fav': taskData.fav,
      'remind': taskData.remind,
      'color': taskData.color
    };
  }
}
