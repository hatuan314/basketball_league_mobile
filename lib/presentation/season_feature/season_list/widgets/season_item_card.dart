import 'package:baseketball_league_mobile/common/assets/image_paths.dart';
import 'package:baseketball_league_mobile/common/constants/router_name.dart';
import 'package:baseketball_league_mobile/common/extentions/route_extension.dart';
import 'package:baseketball_league_mobile/domain/entities/season_entity.dart';
import 'package:baseketball_league_mobile/presentation/widgets/image/app_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class SeasonItemCard extends StatelessWidget {
  final SeasonEntity season;
  final Function(SeasonEntity)? onEdit;
  final Function(SeasonEntity)? onDelete;
  
  const SeasonItemCard({
    super.key, 
    required this.season,
    this.onEdit,
    this.onDelete,
  });
  
  /// Kiểm tra xem giải đấu đã bắt đầu hay chưa
  bool get isSeasonStarted {
    if (season.startDate == null) return false;
    return DateTime.now().isAfter(season.startDate!);
  }
  
  /// Kiểm tra xem giải đấu đã kết thúc hay chưa
  bool get isSeasonEnded {
    if (season.endDate == null) return false;
    return DateTime.now().isAfter(season.endDate!);
  }
  
  /// Lấy trạng thái của giải đấu
  String get seasonStatus {
    if (isSeasonEnded) return 'Đã kết thúc';
    if (isSeasonStarted) return 'Đang diễn ra';
    return 'Chưa bắt đầu';
  }
  
  /// Lấy màu cho trạng thái của giải đấu
  Color get seasonStatusColor {
    if (isSeasonEnded) return Colors.grey;
    if (isSeasonStarted) return Colors.green;
    return Colors.orange;
  }
  
  /// Kiểm tra xem giải đấu có thể chỉnh sửa/xóa hay không
  bool get canEditOrDelete {
    return !isSeasonStarted;
  }

  @override
  Widget build(BuildContext context) {
    final startDate =
        season.startDate != null
            ? DateFormat('dd/MM/yyyy').format(season.startDate!)
            : 'N/A';
    final endDate =
        season.endDate != null
            ? DateFormat('dd/MM/yyyy').format(season.endDate!)
            : 'N/A';

    return Card(
      margin: EdgeInsets.only(bottom: 12.sp),
      elevation: 2,
      child: InkWell(
        onTap: () {
          context.push(
            RouterName.seasonDetail.toSeasonRoute(),
            extra: season,
          ); // Tạm thời chuyển đến màn hình danh sách cầu thủ
        },
        child: Padding(
          padding: EdgeInsets.all(16.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  AppImageWidget(
                    path: AppImagePaths.basketball_season,
                    height: 24.sp,
                    width: 24.sp,
                  ),
                  SizedBox(width: 8.sp),
                  Expanded(
                    child: Text(
                      season.name ?? 'Không có tên',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // Nút sửa - chỉ hiển thị và cho phép sửa nếu giải đấu chưa bắt đầu
                  if (onEdit != null)
                    IconButton(
                      icon: Icon(
                        Icons.edit, 
                        size: 20.sp, 
                        color: canEditOrDelete ? Colors.blue : Colors.grey,
                      ),
                      padding: EdgeInsets.all(4.r),
                      constraints: BoxConstraints(),
                      onPressed: canEditOrDelete ? () => onEdit!(season) : null,
                      tooltip: canEditOrDelete ? 'Sửa' : 'Không thể sửa giải đấu đã bắt đầu',
                    ),
                  // Nút xóa - chỉ hiển thị và cho phép xóa nếu giải đấu chưa bắt đầu
                  if (onDelete != null)
                    IconButton(
                      icon: Icon(
                        Icons.delete, 
                        size: 20.sp, 
                        color: canEditOrDelete ? Colors.red : Colors.grey,
                      ),
                      padding: EdgeInsets.all(4.r),
                      constraints: BoxConstraints(),
                      onPressed: canEditOrDelete ? () => onDelete!(season) : null,
                      tooltip: canEditOrDelete ? 'Xóa' : 'Không thể xóa giải đấu đã bắt đầu',
                    ),
                ],
              ),
              SizedBox(height: 8.sp),
              Row(
                children: [
                  Text(
                    'Mã: ',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(season.code ?? 'N/A', style: TextStyle(fontSize: 14.sp)),
                  Spacer(),
                  // Hiển thị trạng thái của giải đấu
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: seasonStatusColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: seasonStatusColor),
                    ),
                    child: Text(
                      seasonStatus,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: seasonStatusColor,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4.sp),
              Row(
                children: [
                  Text(
                    'Thời gian: ',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '$startDate - $endDate',
                    style: TextStyle(fontSize: 14.sp),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
