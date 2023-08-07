import 'package:flutter/material.dart';

enum RequestStatus {
  success,
  failure,
  initial,
  loading,
}

class Response {
  Response({required this.message, required this.status});

  final String message;
  final RequestStatus status;
}

Widget customForm({
  required TextEditingController textEditingController,
  String? hintText,
  String? labelText,
  TextInputType? keyboardType,
  Function(String?)? onChanged,
  FormFieldValidator? validator,
  int? maxLength,
}) {
  return TextFormField(
      controller: textEditingController,
      keyboardType: keyboardType,
      validator: validator,
      onChanged: onChanged,
      maxLength: maxLength,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        counterText: "",

      ));
}

Widget customButton({required VoidCallback function, required Widget child}) {
  return ElevatedButton(
    onPressed: function,
    child: child,
  );
}


class Validators {
  static String? emptyValidator(dynamic str) {
    if (str == null || str.trim().isEmpty){
      return "Field cannot be empty";
    }
    return null;
  }
}