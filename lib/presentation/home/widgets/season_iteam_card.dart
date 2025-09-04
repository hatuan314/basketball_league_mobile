import 'package:baseketball_league_mobile/common/assets/image_paths.dart';
import 'package:baseketball_league_mobile/common/constants/router_name.dart';
import 'package:baseketball_league_mobile/domain/entities/season_entity.dart';
import 'package:baseketball_league_mobile/presentation/widgets/image/app_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class SeasonIteamCard extends StatelessWidget {
  final SeasonEntity season;
  const SeasonIteamCard({super.key, required this.season});

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
            RouterName.playerList,
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
