import 'package:baseketball_league_mobile/presentation/widgets/image/app_image_widget.dart';
import 'package:flutter/material.dart';

class WrapWithShape extends StatelessWidget {
  final Widget child;
  final ImageShape? imageShape;
  final BorderRadius? borderRadius;

  const WrapWithShape({
    super.key,
    this.imageShape,
    this.borderRadius,
    required this.child,
  });
  @override
  Widget build(BuildContext context) {
    if (imageShape == ImageShape.circle) {
      return ClipOval(child: child);
    } else if (imageShape == ImageShape.retangle && borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius!, child: child);
    }
    return child;
  }
}
