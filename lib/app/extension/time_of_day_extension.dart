import 'package:flutter/material.dart';

extension ExtensionTimeOfDay on TimeOfDay {
  bool isBeforeTimeNow() {
    if (hour < DateTime.now().hour) {
      return true;
    } else if (hour == DateTime.now().hour && minute < DateTime.now().minute) {
      return true;
    } else {
      return false;
    }
  }

  bool isAfterTimeNow() {
    if (hour > DateTime.now().hour) {
      return true;
    } else if (hour == DateTime.now().hour && minute > DateTime.now().minute) {
      return true;
    } else {
      return false;
    }
  }

  bool isBeforeAnotherTime(TimeOfDay time) {
    if (hour < time.hour) {
      return true;
    } else if (hour == time.hour && minute < time.minute) {
      return true;
    } else {
      return false;
    }
  }

  bool isAfterAnotherTime(TimeOfDay time) {
    if (hour > time.hour) {
      return true;
    } else if (hour == time.hour && minute > time.minute) {
      return true;
    } else {
      return false;
    }
  }
}
