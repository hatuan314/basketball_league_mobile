import 'package:baseketball_league_mobile/presentation/routers.dart';
import 'package:baseketball_league_mobile/presentation/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toastification/toastification.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      splitScreenMode: true,
      builder:
          (context, child) => ToastificationWrapper(
            child: MaterialApp.router(
              debugShowCheckedModeBanner: false,
              routerConfig: router,
              title: "PBL Mobile",
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(
                  seedColor: AppColors.primary,
                ).copyWith(primary: AppColors.primary),
                appBarTheme: AppBarTheme(backgroundColor: AppColors.white),
              ),
              builder: EasyLoading.init(
                builder: (context, child) => child ?? const SizedBox(),
              ),
            ),
          ),
    );
  }
}
