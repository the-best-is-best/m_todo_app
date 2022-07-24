import 'package:flutter/cupertino.dart';
import 'package:quick_actions/quick_actions.dart';

class QuickAction {
  QuickActions quickActions = const QuickActions();
  void init(BuildContext context) {
    quickActions.initialize((String shortcutType) {
      print(shortcutType);
    });
  }

  void items() {
    quickActions.setShortcutItems(<ShortcutItem>[
      // NOTE: This first action icon will only work on iOS.
      // In a real world project keep the same file name for both platforms.
      const ShortcutItem(
        type: 'action_one',
        localizedTitle: 'Action one',
        icon: 'AppIcon',
      ),
      // NOTE: This second action icon will only work on Android.
      // In a real world project keep the same file name for both platforms.
      const ShortcutItem(
          type: 'action_two',
          localizedTitle: 'Action two',
          icon: 'ic_launcher'),
    ]).then((void _) {
      // setState(() {
      //   if (shortcut == 'no action set') {
      //     shortcut = 'actions ready';
      //   }
      // });
    });
  }
}
