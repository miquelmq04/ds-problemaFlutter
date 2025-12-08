import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InputDecorationTextFormField extends StatelessWidget {
  late String name;
  late String exampleInput;
  late String initialValue;
  late TextEditingController controller;
  late int minLines;
  final String? Function(String?)? validator;

  InputDecorationTextFormField({super.key,required this.name,
    required this.exampleInput, required this.controller,this.minLines=1,
    this.initialValue='', this.validator})
  {
    controller.text = initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: null,
      minLines: minLines,
      decoration: InputDecoration(
        labelText: name,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        hintText: exampleInput,
        border: OutlineInputBorder(),
      ),
      controller: controller,
      validator: validator,
    );
  }
}
