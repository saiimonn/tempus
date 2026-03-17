import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tempus/core/theme/app_colors.dart';

class UnderlineTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String hint;
  final bool isDecimal;
  final String? Function(String?)? validator;
  final bool autofocus;
  final ValueChanged<String>? onFieldSubmitted;
  final TextInputAction textInputAction;
  final TextCapitalization textCapitalization;

  const UnderlineTextField({
    super.key,
    required this.label,
    required this.controller,
    required this.hint,
    this.isDecimal = false,
    this.validator,
    this.autofocus = false,
    this.onFieldSubmitted,
    this.textInputAction = TextInputAction.done,
    this.textCapitalization = TextCapitalization.sentences,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.foreground,
            letterSpacing: 0.5,
          ),
        ),

        TextFormField(
          controller: controller,
          autofocus: autofocus,
          keyboardType: isDecimal
              ? const TextInputType.numberWithOptions(decimal: true)
              : TextInputType.text,
          inputFormatters: isDecimal
              ? [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))]
              : null,
          validator: validator,
          textInputAction: textInputAction,
          onFieldSubmitted: onFieldSubmitted,
          textCapitalization: textCapitalization,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.text,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              color: AppColors.foreground,
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),

            filled: false,
            contentPadding: const EdgeInsets.symmetric(vertical: 10),
            border: _underlineBorder(Colors.grey.shade300),
            enabledBorder: _underlineBorder(Colors.grey.shade300),
            focusedBorder: _underlineBorder(AppColors.brandBlue, width: 1.5),
            errorBorder: _underlineBorder(AppColors.destructive),
            focusedErrorBorder: _underlineBorder(AppColors.destructive, width: 1.5),
            isDense: true,
          ),
        ),
      ],
    );
  }

  UnderlineInputBorder _underlineBorder(Color color, {double width = 1.0}) {
    return UnderlineInputBorder(
      borderSide: BorderSide(color: color, width: width),
    );
  }
}
