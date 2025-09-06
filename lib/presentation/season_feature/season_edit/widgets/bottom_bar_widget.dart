import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:baseketball_league_mobile/presentation/theme/app_color.dart';

class BottomBarWidget extends StatelessWidget {
  final VoidCallback onCancel;
  final VoidCallback onSave;

  const BottomBarWidget({
    super.key,
    required this.onCancel,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              icon: Icon(Icons.cancel_outlined, size: 20.sp),
              label: Text(
                'Hủy',
                style: TextStyle(fontSize: 16.sp),
              ),
              onPressed: onCancel,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade200,
                foregroundColor: Colors.black87,
                padding: EdgeInsets.symmetric(vertical: 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
                elevation: 0,
              ),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: ElevatedButton.icon(
              icon: Icon(Icons.save_outlined, size: 20.sp),
              label: Text(
                'Lưu',
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
              ),
              onPressed: onSave,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.orange,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
                elevation: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
