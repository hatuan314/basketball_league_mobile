import 'package:baseketball_league_mobile/presentation/widgets/image/app_image_widget.dart';
import 'package:flutter/material.dart';

class WrapWithBorder extends StatelessWidget {
  final Widget child;
  final ImageShape imageShader;
  final double? width;
  final double? height;
  final BorderSide? border;
  final BorderRadius? borderRadius;

  const WrapWithBorder({
    super.key,
    required this.imageShader,
    this.width,
    this.height,
    this.border,
    this.borderRadius,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (border != null) {
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          shape:
              imageShader == ImageShape.circle
                  ? BoxShape.circle
                  : BoxShape.rectangle,
          border: Border.fromBorderSide(border!),
          borderRadius:
              imageShader == ImageShape.retangle ? borderRadius : null,
        ),
        clipBehavior: Clip.hardEdge,
        child: child,
      );
    }
    return child;
  }
}
