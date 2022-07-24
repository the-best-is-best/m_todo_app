import 'package:flutter/material.dart';
import 'package:m_todo_app/app/resources/styles_manger.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../constant.dart';

extension ExtensionBuildContext on BuildContext {
  AppLocalizations strings() {
    return AppLocalizations.of(this)!;
  }

// how to use
//  context.showMyTimePicker()
  Future<String> showMyTimePicker() async {
    TimeOfDay? time = await showTimePicker(
      context: this,
      initialTime: TimeOfDay.now(),
    );
    return time?.format(this) ?? "";
  }

// how to use
//  context.showMyDatePicker()
  Future<String> showMyDatePicker() async {
    DateTime dateNow = DateTime.now();
    DateTime? date = await showDatePicker(
        context: this,
        initialDate: dateNow,
        firstDate: dateNow,
        lastDate: DateTime.parse(
            DateTime(dateNow.year + 10, dateNow.month - 1, dateNow.day)
                .toIso8601String()));
    // var inputFormat = DateFormat('dd/MM/yyyy');

    return Constants.inputFormat.format(date ?? dateNow);
  }

  void showToast(String message) {
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(
      backgroundColor: Colors.red,
      content: Text(
        message,
        style: getRegularStyle(),
      ),
    ));
  }

  void back() {
    Navigator.pop(this);
  }

  void push(Widget page, {dynamic arguments}) {
    Navigator.push(
      this,
      MaterialPageRoute(
          builder: (context) => page,
          settings: RouteSettings(arguments: arguments)),
    );
  }

  double get width => MediaQuery.of(this).size.width;
  double get height => MediaQuery.of(this).size.height;
}
