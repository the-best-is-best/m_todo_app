import 'package:flutter/cupertino.dart';
import 'package:m_todo_app/app/extension/context_extension.dart';
import 'package:m_todo_app/presentation/add_task/view/add_task_view.dart';
import 'package:quick_actions/quick_actions.dart';
import '../app/extension/context_extension.dart';

class QuickAction {
  QuickActions quickActions = const QuickActions();
  void init(BuildContext context) {
    quickActions.initialize((String? shortcutType) {
      if (shortcutType == null) return;
      if (shortcutType == QuickAction._actionAddNewTask(context).type) {
        context.push(const AddTaskView());
      }
    });
  }

  static List<ShortcutItem> items = [];
  static _actionAddNewTask(BuildContext context) => ShortcutItem(
      type: 'add_new_task',
      localizedTitle: context.strings().addATask,
      icon: 'add_new_task');

  void addItems(BuildContext context) {
    items.add(_actionAddNewTask(context));
    quickActions.setShortcutItems(items).then((void _) {
      // setState(() {
      //   if (shortcut == 'no action set') {
      //     shortcut = 'actions ready';
      //   }
      // });
    });
  }
}
