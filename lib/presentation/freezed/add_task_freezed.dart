import 'package:freezed_annotation/freezed_annotation.dart';

part 'add_task_freezed.freezed.dart';

@freezed
class AddTaskFreezed with _$AddTaskFreezed {
  const factory AddTaskFreezed({
    int? id,
    required String title,
    required String description,
    required String date,
    required String startTime,
    required String endTime,
    required int status,
    required int fav,
    required int remind,
    required String color,
  }) = _AddTaskFreezed;
}
