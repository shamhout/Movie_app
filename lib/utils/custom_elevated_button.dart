import 'package:flutter/material.dart';

import 'app_color.dart';
import 'app_style.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton(
      {super.key,
        required this.onPressed,
        required this.text,
        this.backgroundColor = AppColor.yellow,
        this.borderColor = Colors.transparent,
        this.textStyle = AppStyle.reglur20black,
        this.hasIcon = false,
        this.iconWidget,
        this.mainAxisAlignment,
        this.padding,
        this.iconWidgetSuf,
        this.hasSuffix = false});

  final VoidCallback onPressed;
  final String text;
  final Color backgroundColor;
  final Color borderColor;
  final TextStyle? textStyle;
  final bool hasIcon;
  final Widget? iconWidget;
  final Widget? iconWidgetSuf;
  final MainAxisAlignment? mainAxisAlignment;
  final EdgeInsetsGeometry? padding;
  final bool hasSuffix;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          shadowColor: Colors.transparent,
          padding: padding ?? EdgeInsets.symmetric(vertical: height * 0.017),
          backgroundColor: backgroundColor,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: borderColor))),
      onPressed: onPressed,
      child: hasIcon
          ? Row(
        mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
        children: [
          iconWidget ?? const SizedBox(),
          SizedBox(
            width: width * 0.02,
          ),
          Text(
            text,
            style: textStyle ?? AppStyle.bold16White,
          ),
          if (hasSuffix) ...[
            const Spacer(),
            iconWidgetSuf ?? const SizedBox(),
          ],
          SizedBox(
            width: width * 0.03,
          ),
        ],
      )
          : Text(
        text,
        style: textStyle ?? AppStyle.bold16White,
      ),
    );
  }
}