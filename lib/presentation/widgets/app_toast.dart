import 'package:baseketball_league_mobile/presentation/theme/app_color.dart';
import 'package:baseketball_league_mobile/presentation/theme/app_style.dart';
import 'package:baseketball_league_mobile/presentation/widgets/image/app_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toastification/toastification.dart';

class RokaToast {
  static void showErrorToast({required String message}) {
    showCustomToast(
      child: ToastBuilder(type: ToastType.error, message: message),
    );
  }

  static void showInfoToast({required String message}) {
    showCustomToast(
      child: ToastBuilder(type: ToastType.info, message: message),
    );
  }

  static void showSuccessToast({required String message}) {
    showCustomToast(
      child: ToastBuilder(type: ToastType.success, message: message),
    );
  }

  static void showCustomToast({required Widget child}) {
    toastification.showCustom(
      builder: (context, holder) => child,
      alignment: Alignment.topCenter,
      animationBuilder: (context, animation, alignment, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: Offset(0, -0.3), // trượt từ trên xuống
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
          child: FadeTransition(opacity: animation, child: child),
        );
      },
      autoCloseDuration: const Duration(seconds: 2),
      animationDuration: const Duration(milliseconds: 300),
    );
  }
}

class ToastBuilder extends StatelessWidget {
  final ToastType type;
  final String message;

  const ToastBuilder({super.key, required this.type, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 16.sp).copyWith(bottom: 8.sp),
      padding: EdgeInsets.symmetric(vertical: 8.sp, horizontal: 12.sp),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppImageWidget(
            path: toastImagePath,
            height: 24.sp,
            width: 24.sp,
            color: AppColors.white,
          ),
          SizedBox(width: 8.sp),
          Expanded(
            child: Text(
              message,
              style: AppStyle.bodyMedium
                  .copyWith(fontWeight: FontWeight.w500)
                  .copyWith(color: AppColors.white, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Color get backgroundColor {
    switch (type) {
      case ToastType.error:
        return AppColors.red;
      case ToastType.info:
        return AppColors.orange;
      case ToastType.success:
        return AppColors.green;
    }
  }

  dynamic get toastImagePath {
    switch (type) {
      case ToastType.error:
        return Icons.error;
      case ToastType.info:
        return Icons.info;
      case ToastType.success:
        return Icons.check;
    }
  }
}

enum ToastType { error, info, success }
