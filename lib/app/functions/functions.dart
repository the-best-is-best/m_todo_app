import 'package:flutter/widgets.dart';

import '../constant.dart';

bool isDateSelectionEqualDateNow(TextEditingController datelineController) {
  return Constants.inputFormat.parse(datelineController.text) ==
      Constants.inputFormat.parse(Constants.inputFormat.format(DateTime.now()));
}
