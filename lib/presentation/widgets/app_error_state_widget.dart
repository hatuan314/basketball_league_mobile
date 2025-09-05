import 'package:baseketball_league_mobile/presentation/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppErrorStateWidget extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onRetry;

  const AppErrorStateWidget({
    super.key,
    required this.errorMessage,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 60.r, color: AppColors.red),
          SizedBox(height: 16.r),
          Text(
            'Đã xảy ra lỗi',
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.r),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.r),
            child: Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14.sp),
            ),
          ),
          SizedBox(height: 24.r),
          ElevatedButton(onPressed: onRetry, child: const Text('Thử lại')),
        ],
      ),
    );
  }
}
