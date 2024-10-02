import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TransField extends StatelessWidget {
  const TransField({
    super.key,
    required this.label,
    required this.icon,
    required this.controller,
    this.minL,
    this.callBackFunction,
    this.keyBoardType,
    this.autofocus = false,
    this.inputFormatters,
    this.mLen,
  });

  final String label;
  final Icon icon;
  final int? minL;
  final TextEditingController controller;
  final FormFieldValidator? callBackFunction;
  final TextInputType? keyBoardType;
  final bool autofocus;
  final List<TextInputFormatter>? inputFormatters;
  final int? mLen;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      shadowColor: Colors.black,
      child: TextFormField(
        autofocus: autofocus,
        minLines: minL,
        maxLines: null,
        maxLength: mLen,
        keyboardType: keyBoardType,
        controller: controller,
        validator: callBackFunction,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          label: Text(
            label,
            style: const TextStyle(fontSize: 18, color: Colors.black),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(0),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          prefixIcon: icon,
        ),
      ),
    );
  }
}
