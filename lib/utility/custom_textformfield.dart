import 'package:flutter/material.dart';

TextFormField customTextFormField(
    {var key,
    var validate,
    required String name,
    required TextEditingController customController,
    int value = 1,
    TextInputType type = TextInputType.text,
    String tl = ""}) {
  return TextFormField(
    autovalidateMode: AutovalidateMode.always,
    validator: validate,
    key: key,
    maxLines: value,
    keyboardType: type,
    controller: customController,
    decoration: InputDecoration(
      suffixText: tl,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      label: Text(name),
    ),
  );
}
