import 'package:flutter/material.dart';
import 'package:m_todo_app/app/extension/context_extension.dart';

import '../../../../app/resources/styles_manger.dart';
import '../../../components/text.dart';

class NoTasksAvailable extends StatelessWidget {
  const NoTasksAvailable({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: MyText(
        title: context.strings().noTasksAvailable,
        style: getRegularStyle(color: Colors.black),
      ),
    );
  }
}
