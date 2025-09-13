import 'package:baseketball_league_mobile/common/assets/image_paths.dart';
import 'package:baseketball_league_mobile/domain/entities/referee/referee_entity.dart';
import 'package:baseketball_league_mobile/presentation/theme/app_color.dart';
import 'package:baseketball_league_mobile/presentation/widgets/image/app_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Widget hiển thị thông tin của một trọng tài
class RefereeItemCard extends StatelessWidget {
  /// Thông tin trọng tài
  final RefereeEntity referee;

  /// Callback khi nhấn vào nút xem chi tiết
  final VoidCallback? onViewDetail;

  /// Callback khi nhấn vào nút chỉnh sửa
  final VoidCallback? onEdit;

  /// Callback khi nhấn vào nút xóa
  final VoidCallback? onDelete;

  /// Constructor
  const RefereeItemCard({
    super.key,
    required this.referee,
    this.onViewDetail,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.sp, horizontal: 16.sp),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.sp)),
      child: Padding(
        padding: EdgeInsets.all(16.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.white,
                  radius: 24.sp,
                  child: AppImageWidget(
                    path: AppImagePaths.referee,
                    width: 24.sp,
                    height: 24.sp,
                    color: AppColors.orange,
                  ),
                ),
                SizedBox(width: 16.sp),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        referee.fullName ?? 'Không có tên',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.sp),
                      Text(
                        'ID: ${referee.id}',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.grey700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.sp),
            Row(
              children: [
                Icon(Icons.email_outlined, size: 16.sp, color: AppColors.grey),
                SizedBox(width: 8.sp),
                Expanded(
                  child: Text(
                    referee.email ?? 'Không có email',
                    style: TextStyle(fontSize: 14.sp),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.sp),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Nút xem chi tiết
                if (onViewDetail != null)
                  TextButton.icon(
                    onPressed: onViewDetail,
                    icon: Icon(
                      Icons.visibility_outlined,
                      size: 16.sp,
                      color: AppColors.primary,
                    ),
                    label: Text(
                      'Chi tiết',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                SizedBox(width: 8.sp),
                // Nút chỉnh sửa
                if (onEdit != null)
                  TextButton.icon(
                    onPressed: onEdit,
                    icon: Icon(
                      Icons.edit_outlined,
                      size: 16.sp,
                      color: AppColors.orange,
                    ),
                    label: Text(
                      'Sửa',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.orange,
                      ),
                    ),
                  ),
                SizedBox(width: 8.sp),
                // Nút xóa
                if (onDelete != null)
                  TextButton.icon(
                    onPressed: onDelete,
                    icon: Icon(
                      Icons.delete_outline,
                      size: 16.sp,
                      color: AppColors.red,
                    ),
                    label: Text(
                      'Xóa',
                      style: TextStyle(fontSize: 14.sp, color: AppColors.red),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
