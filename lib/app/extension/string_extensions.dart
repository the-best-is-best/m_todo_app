import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../constant.dart';

extension ExtensionString on String {
  TimeOfDay convertTimeStringToTimeOfDay() {
    print(this);

    DateTime dateTime = DateFormat(
      "hh:mm a",
    ).parse(replaceAll('م', 'PM').replaceAll('ص', 'AM'));

    return TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
  }

  Color convertToColor() {
    String valueString = split('(0x')[1].split(')')[0]; // kind of hacky..
    int value = int.parse(valueString, radix: 16);
    return Color(value);
  }

  DateTime toDate() {
    DateTime outputDate =
        Constants.inputFormat.parse(this); // <-- dd/MM 24H format
    return outputDate;
  }

  DateTime toDateTime() {
    DateTime outputDate = DateFormat('yyyy/MM/dd hh:mm a')
        .parse(replaceAll('م', 'PM').replaceAll('ص', 'AM'));
    return outputDate;
  }
}
