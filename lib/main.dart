import 'package:baseketball_league_mobile/common/assets/image_paths.dart';
import 'package:baseketball_league_mobile/common/injection.dart';
import 'package:baseketball_league_mobile/presentation/app.dart';
import 'package:baseketball_league_mobile/presentation/widgets/image/app_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void main() {
  configureDependencies();
  runApp(const MyApp());
  configEasyLoading();
}

/// EASY LOADING CONFIGURATION
void configEasyLoading() {
  EasyLoading.instance
    ..backgroundColor = Colors.white
    ..indicatorWidget = AppImageWidget(
      path: AppImagePaths.basketball_loading_anm,
      width: 80,
      height: 80,
    )
    ..boxShadow = [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.0),
        spreadRadius: 1,
        blurRadius: 10,
        offset: const Offset(0, 3),
      ),
    ] // thêm shadow để thấy rõ hơn
    ..loadingStyle = EasyLoadingStyle.custom
    ..maskColor = const Color(0xffCAD3DA).withValues(alpha: 0.6)
    ..maskType = EasyLoadingMaskType.custom
    ..dismissOnTap = false
    ..userInteractions = false
    ..textColor = const Color(0xFF526779)
    ..indicatorColor = Colors.white
    ..textStyle = const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      fontFamily: "SVN-Gilroy",
      color: Color(0xFF526779),
    )
    ..contentPadding = const EdgeInsets.all(8)
    ..radius = 14
    ..toastPosition = EasyLoadingToastPosition.center; // Thêm vị trí toast
}
