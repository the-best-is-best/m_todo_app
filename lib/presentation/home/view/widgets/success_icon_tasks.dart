import 'package:flutter/material.dart';

import '../../../../app/resources/font_manager.dart';
import '../../../../domain/model/tasks_model.dart';

class IconSuccess extends StatelessWidget {
  const IconSuccess({
    Key? key,
    required this.tasks,
  }) : super(key: key);

  final TasksModel tasks;
  @override
  Widget build(BuildContext context) {
    return Icon(
      tasks.status == 0 ? Icons.circle_outlined : Icons.check_circle_outline,
      color: Colors.white,
      size: FontSize.s30,
    );
  }
}
