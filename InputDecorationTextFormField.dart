import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InputDecorationTextFormField extends StatelessWidget {
  late String name;
  late String exampleInput;
  late String initialValue;
  late TextEditingController controller;
  late int minLines;

  InputDecorationTextFormField({super.key,required this.name,
    required this.exampleInput, required this.controller,this.minLines=1,
    this.initialValue=''})
  {
    controller.text = initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: null,
      minLines: this.minLines,
      decoration: InputDecoration(
        labelText: this.name,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        hintText: this.exampleInput,
        border: OutlineInputBorder(),
      ),
      controller: this.controller,
    );
  }
}