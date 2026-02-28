import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tempus/core/theme/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String hint;
  final bool isDecimal;
  final String? Function(String?)? validator;
  final bool autofocus;
  final ValueChanged<String>? onFieldSubmitted;
  final TextInputAction textInputAction;

  const CustomTextField({
    super.key,
    required this.label,
    required this.controller,
    required this.hint,
    this.isDecimal = false,
    this.validator,
    this.autofocus = false,
    this.onFieldSubmitted,
    this.textInputAction = TextInputAction.done,
  });

  @override
  Widget build(BuildContext build) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),

        const SizedBox(height: 8),

        TextFormField(
          controller: controller,
          autofocus: autofocus,
          keyboardType: isDecimal ? const TextInputType.numberWithOptions(decimal: true) : TextInputType.text,
          inputFormatters: isDecimal ? [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))] : null,
          validator: validator,
          textInputAction: textInputAction,
          onFieldSubmitted: onFieldSubmitted,
          style: const TextStyle(fontSize: 15),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: AppColors.foreground, fontSize: 14),
            filled: false,
            contentPadding: const EdgeInsets.all(14),
            border: _outlineBorder(Colors.transparent),
            enabledBorder: _outlineBorder(Colors.grey.shade300),
            focusedBorder: _outlineBorder(Colors.blue, width: 2),
            errorBorder: _outlineBorder(Colors.red),
            focusedErrorBorder: _outlineBorder(Colors.red, width: 2),
          ),
        ),
      ],
    );
  }

  OutlineInputBorder _outlineBorder(Color color, { double width = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}