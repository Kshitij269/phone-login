import 'package:flutter/material.dart';

class TextFieldInput extends StatelessWidget {
  final TextEditingController textEditingController;
  final bool isPass;

  final TextInputType textInputType;
  const TextFieldInput({
    Key? key,
    required this.textEditingController,
    this.isPass = false,
    required this.textInputType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: Divider.createBorderSide(context));

    final focusBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(
        color: Color.fromRGBO(137, 127, 255, 1), // Default color for "Send OTP"
      ),
    );
    return TextField(

      controller: textEditingController,
      textAlign: TextAlign.center,
      style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.never,
        labelText: "Enter Mobile Number",
        fillColor: Colors.grey.shade100,
        border: inputBorder,
        focusedBorder: focusBorder,
        enabledBorder: inputBorder,
        filled: true,
        contentPadding: const EdgeInsets.all(10),
      ),
      keyboardType: textInputType,
      obscureText: isPass,
    );
  }
}
