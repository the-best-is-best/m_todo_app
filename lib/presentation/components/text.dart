import 'package:flutter/material.dart';

import '../../app/resources/styles_manger.dart';

class MyText extends StatelessWidget {
  const MyText({
    Key? key,
    required this.title,
    this.style,
  }) : super(key: key);
  final String title;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: style ?? getRegularStyle(),
    );
  }
}
