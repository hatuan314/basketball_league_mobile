import 'package:baseketball_league_mobile/presentation/theme/app_color.dart';
import 'package:baseketball_league_mobile/presentation/theme/app_style.dart';
import 'package:baseketball_league_mobile/presentation/widgets/app_touchable.dart';
import 'package:baseketball_league_mobile/presentation/widgets/image/app_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MenuButtonWidget extends StatelessWidget {
  final String iconPath;
  final String title;
  final VoidCallback onTap;
  final Color? color;
  const MenuButtonWidget({
    super.key,
    required this.iconPath,
    required this.title,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return AppTouchable(
      onPressed: onTap,
      child: Card(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.white,
                ),
                padding: EdgeInsets.all(8.sp),
                child: AppImageWidget(
                  path: iconPath,
                  width: 24.sp,
                  height: 24.sp,
                  color: color,
                ),
              ),
              SizedBox(height: 8.sp),
              Text(
                title,
                style: AppStyle.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
