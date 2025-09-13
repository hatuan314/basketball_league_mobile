import 'package:baseketball_league_mobile/domain/match/match_player_detail_entity.dart';
import 'package:baseketball_league_mobile/presentation/theme/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MatchPlayerListview extends StatelessWidget {
  final List<MatchPlayerDetailEntity> players;
  const MatchPlayerListview({super.key, required this.players});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tiêu đề bảng
        Container(
          padding: EdgeInsets.symmetric(vertical: 8.sp, horizontal: 12.sp),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8.sp),
              topRight: Radius.circular(8.sp),
            ),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 40.sp,
                child: Text('Số', style: AppStyle.headline6),
              ),
              SizedBox(width: 8.sp),
              Expanded(child: Text('Tên cầu thủ', style: AppStyle.headline6)),
              SizedBox(
                width: 60.sp,
                child: Text('Điểm', style: AppStyle.headline6),
              ),
              SizedBox(
                width: 60.sp,
                child: Text('Lỗi', style: AppStyle.headline6),
              ),
            ],
          ),
        ),
        // Danh sách cầu thủ
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: players.length,
          separatorBuilder: (context, index) => Divider(height: 1.sp),
          itemBuilder: (context, index) {
            final player = players[index];
            return _buildPlayerItem(player);
          },
        ),
      ],
    );
  }

  Widget _buildPlayerItem(MatchPlayerDetailEntity player) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.sp, horizontal: 12.sp),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey[300]!, width: 1.sp),
        ),
      ),
      child: Row(
        children: [
          // Số áo
          Container(
            width: 40.sp,
            height: 40.sp,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
            child: Text(
              '${player.shirtNumber ?? 0}',
              style: AppStyle.headline6.copyWith(color: Colors.white),
            ),
          ),
          SizedBox(width: 8.sp),
          // Thông tin cầu thủ
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  player.playerName ?? 'Không có tên',
                  style: AppStyle.headline6,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.sp),
                Text(
                  player.playerCode ?? '',
                  style: AppStyle.caption.copyWith(color: Colors.grey),
                ),
              ],
            ),
          ),
          // Điểm số
          Container(
            width: 60.sp,
            alignment: Alignment.center,
            child: Text(
              '${player.points ?? 0}',
              style: AppStyle.headline6.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ),
          // Lỗi phạm
          Container(
            width: 60.sp,
            alignment: Alignment.center,
            child: Text(
              '${player.fouls ?? 0}',
              style: AppStyle.headline6.copyWith(
                fontWeight: FontWeight.bold,
                color: (player.fouls ?? 0) >= 5 ? Colors.red : Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
