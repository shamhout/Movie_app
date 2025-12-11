import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_color.dart';
import 'app_style.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    this.controller,
    this.initialValue,
    this.label,
    this.hint,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.readOnly = false,
    this.enabled = true,
    this.maxLines = 1,
    this.minLines,
    this.prefixIcon,
    this.suffixIcon,
    this.showClearButton = false,
    this.validator,
    this.onSaved,
    this.onChanged,
    this.inputFormatters,
    this.textInputAction,
    this.autovalidateMode,
    this.focusNode,
    this.borderRadius = 15,
    this.contentPadding,
    this.hintStyle = AppStyle.bold16White,
    this.labelStyle,
    this.errorStyle,
    this.borderColor = Colors.transparent,
    this.focusedBorderColor = Colors.transparent,
    this.errorBorderColor = Colors.redAccent,
    this.textColor = Colors.white,
    this.iconColor = Colors.white70,
    this.cursorColor = AppColor.yellow,
    this.fillColor = AppColor.grayColor,
  });

  final TextEditingController? controller;
  final String? initialValue;
  final String? label;
  final String? hint;
  final TextInputType keyboardType;
  final bool obscureText;
  final bool readOnly;
  final bool enabled;
  final int? maxLines;
  final int? minLines;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool showClearButton;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final void Function(String)? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputAction? textInputAction;
  final AutovalidateMode? autovalidateMode;
  final FocusNode? focusNode;
  final double borderRadius;

  final EdgeInsetsGeometry? contentPadding;
  final TextStyle? hintStyle;
  final TextStyle? labelStyle;
  final TextStyle? errorStyle;
  final Color borderColor;
  final Color focusedBorderColor;
  final Color errorBorderColor;
  final Color textColor;
  final Color iconColor;
  final Color cursorColor;
  final Color fillColor;

  InputBorder _buildBorder(Color color) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(borderRadius),
    borderSide: BorderSide(color: color, width: 1.2),
  );

  @override
  Widget build(BuildContext context) {
    final effectiveContentPadding = contentPadding ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 14);

    return TextFormField(
      controller: controller,
      initialValue: controller == null ? initialValue : null,
      keyboardType: keyboardType,
      obscureText: obscureText,
      readOnly: readOnly,
      enabled: enabled,
      maxLines: obscureText ? 1 : maxLines,
      minLines: minLines,
      inputFormatters: inputFormatters,
      textInputAction: textInputAction,
      autovalidateMode: autovalidateMode,
      focusNode: focusNode,
      onSaved: onSaved,
      onChanged: onChanged,
      validator: validator,
      cursorColor: cursorColor,
      style: TextStyle(color: textColor),
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: fillColor,
        contentPadding: effectiveContentPadding,
        labelText: label,
        labelStyle: labelStyle ?? TextStyle(color: textColor.withOpacity(0.7)),
        hintText: hint,
        hintStyle: hintStyle ?? TextStyle(color: textColor.withOpacity(0.5)),
        errorStyle: errorStyle ?? const TextStyle(color: Colors.redAccent, fontSize: 12),
        prefixIcon: prefixIcon != null
            ? Padding(
          padding: const EdgeInsets.only(left: 8, right: 8),
          child: IconTheme(data: IconThemeData(color: iconColor), child: prefixIcon!),
        )
            : null,
        prefixIconConstraints: const BoxConstraints(minWidth: 40, minHeight: 40),
        suffixIcon: _buildSuffix(context),
        enabledBorder: _buildBorder(borderColor),
        focusedBorder: _buildBorder(focusedBorderColor),
        errorBorder: _buildBorder(errorBorderColor),
        focusedErrorBorder: _buildBorder(errorBorderColor),
      ),
    );
  }

  Widget? _buildSuffix(BuildContext context) {
    if (showClearButton) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (suffixIcon != null) IconTheme(data: IconThemeData(color: iconColor), child: suffixIcon!),
          GestureDetector(
            onTap: () {
              if (controller != null) {
                controller!.clear();
                FocusScope.of(context).requestFocus(FocusNode());
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Icon(Icons.clear, size: 20, color: iconColor.withOpacity(0.8)),
            ),
          ),
        ],
      );
    }
    if (suffixIcon != null) {
      return IconTheme(data: IconThemeData(color: iconColor), child: suffixIcon!);
    }
    return null;
  }
}