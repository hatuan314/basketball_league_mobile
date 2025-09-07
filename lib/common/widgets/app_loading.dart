import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

/// Widget hiển thị trạng thái đang tải dữ liệu
class AppLoading extends StatelessWidget {
  /// Kích thước của widget loading
  final double? size;

  /// Constructor
  const AppLoading({
    super.key,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            'assets/images/basketball_loading_anm.json',
            width: size ?? 100.r,
            height: size ?? 100.r,
          ),
          SizedBox(height: 16.h),
          Text(
            'Đang tải dữ liệu...',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
