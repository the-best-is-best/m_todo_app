import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

bool isDateSelectionEqualDateNow(
    DateFormat inputFormat, TextEditingController datelineController) {
  return DateFormat("dd/MM/yyyy").parse(datelineController.text) ==
      DateFormat("dd/MM/yyyy").parse(inputFormat.format(DateTime.now()));
}
