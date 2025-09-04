import 'dart:io';
import 'dart:ui' as ui;

import 'package:baseketball_league_mobile/common/app_utils.dart';
import 'package:baseketball_league_mobile/presentation/widgets/image/app_network_image_widget.dart';
import 'package:baseketball_league_mobile/presentation/widgets/image/wrap_with_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';

import 'wrap_with_shape.dart';

/// Widget hiển thị ảnh đa năng cho asset, network, file, svg, icon.
///
/// Các tham số:
/// - [path]: Đường dẫn hoặc đối tượng ảnh (bắt buộc)
/// - [placeholder]: Widget hiển thị khi loading (ưu tiên nếu không có placeholderBuilder)
/// - [placeholderBuilder]: Hàm builder cho widget loading (ưu tiên hơn placeholder)
/// - [errorWidget]: Widget hiển thị khi lỗi (ưu tiên nếu không có errorWidgetBuilder)
/// - [errorWidgetBuilder]: Hàm builder cho widget lỗi (ưu tiên hơn errorWidget)
/// - [fit]: BoxFit cho ảnh
/// - [width], [height]: Kích thước ảnh
/// - [color]: Màu overlay cho ảnh (nếu hỗ trợ)
/// - [loadingSize]: Kích thước loading indicator
/// - [imageShape]: Hình dạng ảnh (chữ nhật/hình tròn)
/// - [borderRadius]: Bo góc cho hình chữ nhật
/// - [border]: Viền cho ảnh
/// - [onLoadedNetworkImage]: Callback khi ảnh network load xong
/// - [headers]: Header cho ảnh network/svg
/// - [errorColor]: Màu icon lỗi mặc định
/// - [loadingColor]: Màu loading indicator mặc định
/// - [overlay]: Widget overlay lên ảnh
/// - [semanticLabel]: Label cho accessibility
/// - [filterQuality]: Chất lượng filter ảnh
/// - [fadeInDuration]: Thời gian fade-in khi load ảnh network/asset
class AppImageWidget extends StatefulWidget {
  final dynamic path;
  final Widget? placeholder;
  final Widget? errorWidget;
  final BoxFit? fit;
  final double? width;
  final double? height;
  final Color? color;
  final double? loadingSize;
  final ImageShape? imageShape;
  final BorderRadius? borderRadius;
  final BorderSide? border;
  final VoidCallback? onLoadedNetworkImage;
  final Map<String, String>? headers;
  final Color? errorColor;
  final Color? loadingColor;
  final Widget? overlay;
  final String? semanticLabel;
  final FilterQuality? filterQuality;
  final Duration? fadeInDuration;
  final Widget Function(BuildContext)? placeholderBuilder;
  final Widget Function(BuildContext)? errorWidgetBuilder;
  final bool autoWrap;

  const AppImageWidget({
    required this.path,
    super.key,
    this.placeholder,
    this.errorWidget,
    this.fit,
    this.width,
    this.height,
    this.loadingSize,
    this.color,
    this.imageShape,
    this.borderRadius,
    this.border,
    this.onLoadedNetworkImage,
    this.headers,
    this.errorColor,
    this.loadingColor,
    this.overlay,
    this.semanticLabel,
    this.filterQuality,
    this.fadeInDuration,
    this.placeholderBuilder,
    this.errorWidgetBuilder,
    this.autoWrap = false,
  }) : assert(
         imageShape != ImageShape.circle || borderRadius == null,
         'Không nên truyền borderRadius khi imageShape là circle, ClipOval sẽ override borderRadius.',
       );

  @override
  State<AppImageWidget> createState() => _AppImageWidgetState();
}

class _AppImageWidgetState extends State<AppImageWidget> {
  @override
  void initState() {
    super.initState();
  }

  Widget get _placeholder {
    return Center(
      child: SizedBox(
        width: widget.loadingSize ?? 20.sp,
        height: widget.loadingSize ?? 20.sp,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            widget.loadingColor ?? Colors.black,
          ),
          strokeWidth: 2,
        ),
      ),
    );
  }

  Widget get _errorWidget {
    return Icon(Icons.error, color: widget.errorColor, size: widget.height);
  }

  bool get _isAsset {
    if (widget.path is String) {
      return (widget.path as String).startsWith('assets/') ||
          (widget.path as String).startsWith('packages/');
    }
    return false;
  }

  ImageType get _imageType {
    if (widget.path == null) return ImageType.icons;
    if (widget.path is File) {
      return ImageType.file;
    }
    if (widget.path is IconData) {
      return ImageType.icons;
    }
    if (widget.path is String) {
      final String p = widget.path as String;
      if (p.toLowerCase().endsWith('.json')) {
        // Nếu path kết thúc bằng .json => Lottie
        return ImageType.lottie;
      }
      if (p.toLowerCase().endsWith('.svg')) {
        // Nếu path kết thúc bằng .svg => SVG
        return ImageType.svg;
      }
      // Các trường hợp string khác => image thông thường
      return ImageType.image;
    }
    return ImageType.icons;
  }

  ImageShape get _imageShape => widget.imageShape ?? ImageShape.retangle;

  Widget _buildSvgImageWidget() {
    Widget svgWidget;
    if (_isAsset) {
      svgWidget = SvgPicture.asset(
        widget.path,
        fit: widget.fit ?? BoxFit.contain,
        width: widget.width,
        height: widget.height,
        colorFilter:
            widget.color != null
                ? ColorFilter.mode(widget.color!, BlendMode.srcIn)
                : null,
        semanticsLabel: widget.semanticLabel,
      );
    } else {
      svgWidget = SvgPicture.network(
        widget.path,
        fit: widget.fit ?? BoxFit.contain,
        width: widget.width,
        height: widget.height,
        colorFilter:
            widget.color != null
                ? ColorFilter.mode(widget.color!, BlendMode.srcIn)
                : null,
        placeholderBuilder:
            (context) =>
                widget.placeholderBuilder?.call(context) ??
                widget.placeholder ??
                _placeholder,
        headers: widget.headers,
        semanticsLabel: widget.semanticLabel,
      );
    }
    return WrapWithBorder(
      child: WrapWithShape(
        imageShape: _imageShape,
        borderRadius: widget.borderRadius,
        child: svgWidget,
      ),
      imageShader: _imageShape,
      width: widget.width,
      height: widget.height,
      border: widget.border,
      borderRadius: widget.borderRadius,
    );
  }

  Future<ui.Image> getImageFromAsset(String path) async {
    try {
      // Đọc dữ liệu ảnh từ assets
      final ByteData data = await rootBundle.load(path);

      // Lấy kích thước ảnh
      return decodeImageFromList(data.buffer.asUint8List());
    } catch (e) {
      debugPrint('Error getting image orientation from asset: $e');
      rethrow;
    }
  }

  Future<ui.Image> getImageFromUrl(String url) async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // Lấy kích thước ảnh
        return decodeImageFromList(response.bodyBytes);
      } else {
        throw Exception(
          'Failed to load image from URL ($url): ${response.statusCode}',
        );
      }
    } catch (e) {
      debugPrint('Error getting image orientation from URL ($url): $e');
      rethrow;
    }
  }

  Future<ui.Image> getUiImage(String path) {
    if (_isAsset) {
      return getImageFromAsset(path);
    }
    return getImageFromUrl(path);
  }

  Widget _buildFutureImage({
    required String path,
    required Function(double? width, double? height) builder,
  }) {
    return widget.autoWrap == true
        ? FutureBuilder<ui.Image>(
          future: getUiImage(path),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return widget.placeholderBuilder?.call(context) ??
                  widget.placeholder ??
                  _placeholder;
            } else if (snapshot.hasError) {
              return widget.errorWidgetBuilder?.call(context) ??
                  widget.errorWidget ??
                  _errorWidget;
            } else if (snapshot.hasData) {
              double? width;
              double? height;
              width = widget.width;
              if (width != null && width > 0) {
                height = width * snapshot.data!.height / snapshot.data!.width;
              }
              return builder(width, height);
            }
            return widget.placeholderBuilder?.call(context) ??
                widget.placeholder ??
                _placeholder;
          },
        )
        : builder(widget.width, widget.height);
  }

  Widget _buildNormalImageWidget() {
    if (_isAsset) {
      Widget assetImg = Image.asset(
        widget.path,
        fit: widget.fit ?? BoxFit.contain,
        width: widget.width,
        height: widget.height,
        filterQuality: widget.filterQuality ?? FilterQuality.low,
        semanticLabel: widget.semanticLabel,
      );
      if (widget.fadeInDuration != null) {
        assetImg = AnimatedSwitcher(
          duration: widget.fadeInDuration!,
          child: assetImg,
        );
      }
      return WrapWithBorder(
        child: WrapWithShape(
          imageShape: _imageShape,
          borderRadius: widget.borderRadius,
          child: assetImg,
        ),
        imageShader: _imageShape,
        width: widget.width,
        height: widget.height,
        border: widget.border,
        borderRadius: widget.borderRadius,
      );
    }
    return AppNetworkImageWidget(
      url: widget.path,
      placeholderBuilder: (context, url) {
        return widget.placeholderBuilder?.call(context) ??
            widget.placeholder ??
            _placeholder;
      },
      imageShape: _imageShape,
      errorWidgetBuilder: (context, url, error) {
        return widget.errorWidgetBuilder?.call(context) ??
            widget.errorWidget ??
            _errorWidget;
      },
      fit: widget.fit ?? BoxFit.contain,
      width: widget.width,
      height: widget.height,
      borderRadius: widget.borderRadius,
      border: widget.border,
      onLoadedNetworkImage: widget.onLoadedNetworkImage,
      headers: widget.headers,
      filterQuality: widget.filterQuality,
      fadeInDuration: widget.fadeInDuration,
      autoWrap: widget.autoWrap,
    );
    // return CachedNetworkImage(
    //   imageUrl: widget.path,
    //   imageBuilder: (context, imageProvider) {
    //     if (widget.onLoadedNetworkImage != null) {
    //       widget.onLoadedNetworkImage!();
    //     }
    //     Widget img = _buildFutureImage(
    //         path: widget.path,
    //         builder: (width, height) {
    //           return Container(
    //             width: width,
    //             height: height,
    //             decoration: BoxDecoration(
    //               shape: (_imageShape == ImageShape.retangle)
    //                   ? BoxShape.rectangle
    //                   : BoxShape.circle,
    //               borderRadius: (_imageShape == ImageShape.retangle)
    //                   ? widget.borderRadius
    //                   : null,
    //               border: widget.border != null &&
    //                       _imageShape == ImageShape.retangle
    //                   ? Border.fromBorderSide(widget.border!)
    //                   : null,
    //               image: DecorationImage(
    //                 image: imageProvider,
    //                 fit: widget.fit ?? BoxFit.contain,
    //                 filterQuality: widget.filterQuality ?? FilterQuality.low,
    //               ),
    //             ),
    //           );
    //         });
    //     return WrapWithBorder(
    //       child: WrapWithShape(
    //         imageShape: _imageShape,
    //         borderRadius: widget.borderRadius,
    //         child: img,
    //       ),
    //       imageShader: _imageShape,
    //       width: widget.width,
    //       height: widget.height,
    //       border: widget.border,
    //       borderRadius: widget.borderRadius,
    //     );
    //   },
    //   placeholder: (context, url) =>
    //       widget.placeholderBuilder?.call(context) ??
    //       widget.placeholder ??
    //       _placeholder,
    //   errorWidget: (context, url, error) {
    //     return widget.errorWidgetBuilder?.call(context) ??
    //         widget.errorWidget ??
    //         _errorWidget;
    //   },
    //   cacheManager: CacheManager(
    //     Config(
    //       'ImageCacheKey',
    //       stalePeriod: const Duration(days: 1),
    //     ),
    //   ),
    //   errorListener: (err) {
    //     debugPrint('Không tải được ${widget.path}: $err');
    //   },
    //   httpHeaders: widget.headers,
    //   fadeInDuration:
    //       widget.fadeInDuration ?? const Duration(milliseconds: 300),
    // );
  }

  Widget _buildImageLocalFile() {
    Widget fileImg = Image.file(
      widget.path,
      fit: widget.fit ?? BoxFit.scaleDown,
      width: widget.width,
      height: widget.height,
      filterQuality: widget.filterQuality ?? FilterQuality.low,
      semanticLabel: widget.semanticLabel,
    );
    return WrapWithBorder(
      child: WrapWithShape(
        imageShape: _imageShape,
        borderRadius: widget.borderRadius,
        child: fileImg,
      ),
      imageShader: _imageShape,
      width: widget.width,
      height: widget.height,
      border: widget.border,
      borderRadius: widget.borderRadius,
    );
  }

  Widget _buildIconWidget(BuildContext context) {
    return Icon(
      widget.path ?? Icons.warning,
      color: widget.color ?? Theme.of(context).colorScheme.onBackground,
      size: widget.height,
      semanticLabel: widget.semanticLabel,
    );
  }

  Widget _buildWarningWidget(BuildContext context) {
    return Icon(
      Icons.warning,
      color: widget.color ?? Theme.of(context).colorScheme.onBackground,
      size: widget.height,
      semanticLabel: widget.semanticLabel,
    );
  }

  Widget _buildWithOverlay(Widget child) {
    if (widget.overlay == null) return child;
    return Stack(
      alignment: Alignment.center,
      children: [child, widget.overlay!],
    );
  }

  Widget _buildLottieImageWidget() {
    if (_isAsset) {
      return Lottie.asset(
        widget.path,
        fit: widget.fit,
        width: widget.width,
        height: widget.height,
      );
    }
    return Lottie.network(
      widget.path,
      fit: widget.fit,
      width: widget.width,
      height: widget.height,
      errorBuilder: (context, error, stackTrace) {
        return widget.errorWidget ?? _errorWidget;
      },
      frameBuilder: (context, child, composition) {
        if (composition != null) {
          return Lottie(composition: composition);
        } else {
          return widget.placeholder ?? _placeholder;
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.path == null ||
        (widget.path is String && AppUtils.isNullEmpty(widget.path))) {
      // ignore: avoid_print
      assert(() {
        debugPrint(
          '[AppImageWidget] path null hoặc rỗng, fallback về Icons.warning',
        );
        return true;
      }());
      return _buildWarningWidget(context);
    }
    Widget result;
    switch (_imageType) {
      case ImageType.lottie:
        return _buildLottieImageWidget();
      case ImageType.svg:
        result = _buildSvgImageWidget();
        break;
      case ImageType.file:
        result = _buildImageLocalFile();
        break;
      case ImageType.icons:
        result = _buildIconWidget(context);
        break;
      default:
        result = _buildNormalImageWidget();
    }
    return _buildWithOverlay(result);
  }
}

enum ImageType { svg, image, lottie, file, icons }

enum ImageShape { circle, retangle }
