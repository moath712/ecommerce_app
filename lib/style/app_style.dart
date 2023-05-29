import 'package:flutter/material.dart';


class AppStyles {
  static InputDecoration formStyle(
    BuildContext context,
    String hint, {
    Widget? suffixIcon,
    Widget? prefixIcon,
    bool? showMaxLength = true,
    bool isHidden = true,
  }) {
    final fontStyle = Theme.of(context).textTheme;
    return InputDecoration(
        isDense: true,
        // isCollapsed: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
        labelStyle: fontStyle.bodyMedium,
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Color(0xFFA95EFA),
          ),
          borderRadius: BorderRadius.circular(25),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Color(0xFFA95EFA),
          ),
          borderRadius: BorderRadius.circular(25),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Color(0xFFA95EFA),
          ),
          borderRadius: BorderRadius.circular(25),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Color(0xFFA95EFA),
          ),
          borderRadius: BorderRadius.circular(25),
        ),
        errorStyle: fontStyle.bodySmall?.copyWith(color: Colors.red),

        // fillColor: Style.field,
        suffixIcon: suffixIcon,
        counterText: showMaxLength == true ? null : '',
        prefixIcon: prefixIcon == null
            ? null
            : Padding(
                padding: const EdgeInsetsDirectional.only(end: 8),
                child: prefixIcon,
              ),
        // filled: true,
        hintStyle: fontStyle.bodySmall?.copyWith(color: Colors.grey[200]),
        hintText: hint,
        labelText: hint);
  }
}
