import 'package:flutter/material.dart';

TextFormField customTextFormField(
    {var key,
    var validate,
    required String name,
    required TextEditingController customController,
    int value = 1,
    TextInputType type = TextInputType.text,
    String tl = "",
    bool obscure = false,
    IconButton? func}) {
  return TextFormField(
    validator: validate,
    autovalidateMode: AutovalidateMode.disabled,
    obscureText: obscure,
    key: key,
    maxLines: value,
    keyboardType: type,
    controller: customController,
    decoration: InputDecoration(
      suffixIcon: func,
      suffixText: tl,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      label: Text(name),
    ),
  );
}
