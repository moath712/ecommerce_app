import 'package:flutter/material.dart';

import 'colors.dart';

class AppStyles {
  static InputDecoration formStyle(
    BuildContext context,
    String hint, {
    Widget? suffixIcon,
    Widget? prefixIcon,
    bool? showMaxLength = true,
  }) {
    final fontStyle = Theme.of(context).textTheme;
    return InputDecoration(
      isDense: true,
      // isCollapsed: true,
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      labelStyle: fontStyle.bodyMedium,
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.text),
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.text),
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      border: const OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.text),
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      errorBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.redAccent, width: 1),
        borderRadius: BorderRadius.all(Radius.circular(5)),
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
    );
  }
}
