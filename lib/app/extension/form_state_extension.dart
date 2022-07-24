import 'package:flutter/material.dart';

extension ExtensionFormState on GlobalKey<FormState> {
  void save() {
    currentState?.save();
  }

  bool isValid() {
    return currentState?.validate() ?? false;
  }
}
