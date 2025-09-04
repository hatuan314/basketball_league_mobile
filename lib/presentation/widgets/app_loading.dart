import 'package:baseketball_league_mobile/common/assets/image_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class AppLoading extends StatelessWidget {
  const AppLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 100.sp,
            width: 100.sp,
            child: Lottie.asset(
              AppImagePaths.basketball_loading_anm,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 16.sp),
          Text('Đang tải dữ liệu...', style: TextStyle(fontSize: 16.sp)),
        ],
      ),
    );
  }
}
