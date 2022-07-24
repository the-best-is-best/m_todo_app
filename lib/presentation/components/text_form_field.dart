import 'package:flutter/material.dart';
import 'package:m_todo_app/app/extension/context_extension.dart';

import '../../app/resources/styles_manger.dart';
import '../../app/resources/value_manger.dart';

class MyTextFormField extends StatelessWidget {
  const MyTextFormField({
    Key? key,
    required this.title,
    required this.onSaved,
    this.controller,
    this.onTap,
    this.keyboardType,
    required this.validator,
    this.suffixIcon,
    this.multiline = false,
    this.enable = true,
  }) : super(key: key);
  final bool multiline;

  final bool enable;
  final String title;
  final FormFieldSetter<String> onSaved;
  final TextEditingController? controller;
  final GestureTapCallback? onTap;
  final TextInputType? keyboardType;
  final FormFieldValidator<String> validator;
  final Widget? suffixIcon;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: getMediumStyle(),
        ),
        const SizedBox(height: AppSize.ap4),
        TextFormField(
          enabled: enable,
          minLines: multiline ? (context.height * .003).toInt() : null,
          maxLines: multiline ? (context.height * .007).toInt() : null,
          controller: controller,
          onTap: onTap,
          keyboardType: onTap == null ? keyboardType : TextInputType.none,
          decoration: InputDecoration(
            fillColor: Colors.grey[200],
            filled: true,
            errorStyle: getLightStyle(color: Colors.red),
            suffixIcon: suffixIcon,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.transparent,
              ),
            ),
          ),
          validator: validator,
          onSaved: onSaved,
        ),
      ],
    );
  }
}
