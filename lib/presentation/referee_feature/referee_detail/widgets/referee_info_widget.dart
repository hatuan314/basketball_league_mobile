import 'package:baseketball_league_mobile/domain/entities/referee/referee_entity.dart';
import 'package:baseketball_league_mobile/presentation/theme/app_color.dart';
import 'package:baseketball_league_mobile/presentation/theme/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RefereeInfoWidget extends StatelessWidget {
  final RefereeEntity referee;
  const RefereeInfoWidget({super.key, required this.referee});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.sp),
          child: Text(
            'Thông tin cá nhân',
            style: AppStyle.headline5.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thông tin chi tiết
            _buildInfoItem(
              icon: Icons.numbers,
              title: 'ID',
              value: '${referee.id}',
            ),
            _buildDivider(),
            _buildInfoItem(
              icon: Icons.email_outlined,
              title: 'Email',
              value: referee.email ?? 'Không có email',
            ),
          ],
        ),
      ],
    );
  }

  /// Xây dựng đường phân cách
  Widget _buildDivider() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.sp),
      child: Divider(
        color: AppColors.grey.withValues(alpha: 0.3),
        thickness: 1,
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.sp),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 24.sp, color: AppColors.grey),
          SizedBox(width: 16.sp),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 14.sp, color: AppColors.grey500),
                ),
                SizedBox(height: 4.sp),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
