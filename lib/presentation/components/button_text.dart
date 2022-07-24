import 'package:flutter/material.dart';
import '../../app/resources/styles_manger.dart';

class MyTextButton extends StatelessWidget {
  const MyTextButton({
    Key? key,
    required this.title,
    required this.onPressed,
    this.style,
  }) : super(key: key);

  final String title;
  final VoidCallback onPressed;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: TextButton(
          onPressed: onPressed,
          child: Text(
            title,
            style: style ?? getRegularStyle(),
          )),
    );
  }
}
