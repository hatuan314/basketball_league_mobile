import 'package:baseketball_league_mobile/presentation/widgets/image/wrap_with_border.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import 'app_image_widget.dart';
import 'wrap_with_shape.dart';

class AppNetworkImageWidget extends StatelessWidget {
  final String url;
  final BoxFit? fit;
  final double? width;
  final double? height;
  final ImageShape imageShape;
  final BorderRadius? borderRadius;
  final BorderSide? border;
  final VoidCallback? onLoadedNetworkImage;
  final Map<String, String>? headers;
  final FilterQuality? filterQuality;
  final Duration? fadeInDuration;
  final Widget Function(BuildContext, String)? placeholderBuilder;
  final LoadingErrorWidgetBuilder? errorWidgetBuilder;
  final bool autoWrap;

  const AppNetworkImageWidget({
    super.key,
    required this.url,
    required this.imageShape,
    this.fit,
    this.width,
    this.height,
    this.borderRadius,
    this.border,
    this.onLoadedNetworkImage,
    this.headers,
    this.filterQuality,
    this.fadeInDuration,
    this.placeholderBuilder,
    this.errorWidgetBuilder,
    this.autoWrap = false,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url,
      imageBuilder:
          (context, imageProvider) => AppImageNetworkBuilder(
            imageProvider: imageProvider,
            autoWrap: autoWrap,
            imageShape: imageShape,
            width: width,
            height: height,
            borderRadius: borderRadius,
            border: border,
            fit: fit,
            filterQuality: filterQuality,
            onLoadedNetworkImage: onLoadedNetworkImage,
          ),
      placeholder: placeholderBuilder,
      errorWidget: errorWidgetBuilder,
      cacheManager: CacheManager(
        Config('ImageCacheKey', stalePeriod: const Duration(days: 1)),
      ),
      errorListener: (err) {
        debugPrint('Không tải được $url: $err');
      },
      httpHeaders: headers,
      fadeInDuration: fadeInDuration ?? const Duration(milliseconds: 300),
    );
  }
}

class AppImageNetworkBuilder extends StatefulWidget {
  final ImageProvider imageProvider;
  final VoidCallback? onLoadedNetworkImage;
  final double? width;
  final double? height;
  final bool autoWrap;
  final ImageShape imageShape;
  final BorderRadius? borderRadius;
  final BorderSide? border;
  final BoxFit? fit;
  final FilterQuality? filterQuality;

  const AppImageNetworkBuilder({
    super.key,
    required this.imageProvider,
    this.onLoadedNetworkImage,
    this.width,
    this.height,
    required this.autoWrap,
    required this.imageShape,
    this.borderRadius,
    this.border,
    this.fit,
    this.filterQuality,
  });

  @override
  State<StatefulWidget> createState() => _AppImageNetworkBuilderState();
}

class _AppImageNetworkBuilderState extends State<AppImageNetworkBuilder> {
  double? imageWidth;
  double? imageHeight;

  @override
  void initState() {
    super.initState();
    imageWidth = widget.width;
    imageHeight = widget.height;
    if (widget.autoWrap) {
      // Sử dụng imageProvider để lấy chiều dài, chiều rộng của ảnh
      widget.imageProvider
          .resolve(ImageConfiguration())
          .addListener(
            ImageStreamListener((ImageInfo info, bool synchronousCall) {
              final realImageWidth = info.image.width.toDouble();
              final realImageHeight = info.image.height.toDouble();
              if (imageWidth != null && imageWidth! > 0) {
                if (mounted) {
                  setState(() {
                    imageHeight =
                        imageWidth! * realImageHeight / realImageWidth;
                  });
                }
              }
            }),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.onLoadedNetworkImage != null) {
      widget.onLoadedNetworkImage!();
    }

    Widget img = Container(
      width: imageWidth,
      height: imageHeight,
      decoration: BoxDecoration(
        shape:
            (widget.imageShape == ImageShape.retangle)
                ? BoxShape.rectangle
                : BoxShape.circle,
        borderRadius:
            (widget.imageShape == ImageShape.retangle)
                ? widget.borderRadius
                : null,
        border:
            widget.border != null && widget.imageShape == ImageShape.retangle
                ? Border.fromBorderSide(widget.border!)
                : null,
        image: DecorationImage(
          image: widget.imageProvider,
          fit: widget.fit ?? BoxFit.contain,
          filterQuality: widget.filterQuality ?? FilterQuality.low,
        ),
      ),
    );
    return WrapWithBorder(
      child: WrapWithShape(
        imageShape: widget.imageShape,
        borderRadius: widget.borderRadius,
        child: img,
      ),
      imageShader: widget.imageShape,
      width: widget.width,
      height: widget.height,
      border: widget.border,
      borderRadius: widget.borderRadius,
    );
  }
}
