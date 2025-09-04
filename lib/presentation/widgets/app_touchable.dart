import 'package:flutter/material.dart';

class AppTouchable extends StatelessWidget {
  final Function()? onPressed;
  final Widget? child;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final Color? rippleColor;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final OutlinedBorder? outlinedBorder;

  const AppTouchable({
    required this.onPressed,
    required this.child,
    super.key,
    this.width,
    this.height,
    this.backgroundColor,
    this.rippleColor,
    this.padding,
    this.margin,
    this.outlinedBorder,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin ?? EdgeInsets.zero,
      child: TextButton(
        onPressed: onPressed,
        style: ButtonStyle(
          foregroundColor: WidgetStateProperty.all(Colors.transparent),
          surfaceTintColor: WidgetStateProperty.all(Colors.transparent),
          backgroundColor: WidgetStateProperty.all(
            backgroundColor ?? Colors.transparent,
          ),
          overlayColor: WidgetStateProperty.all(
            rippleColor ?? Colors.grey.withValues(alpha: 0.1),
          ),
          shape: WidgetStateProperty.all(
            outlinedBorder ??
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          padding: WidgetStateProperty.all(padding ?? EdgeInsets.zero),
          minimumSize: WidgetStateProperty.all(Size.zero),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.standard,
        ),
        child: child ?? const SizedBox.shrink(),
      ),
    );
  }
}
