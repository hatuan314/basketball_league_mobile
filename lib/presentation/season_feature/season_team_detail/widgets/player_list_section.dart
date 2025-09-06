import 'package:baseketball_league_mobile/domain/entities/player_season_entity.dart';
import 'package:baseketball_league_mobile/presentation/season_feature/season_team_detail/bloc/season_team_detail_cubit.dart';
import 'package:baseketball_league_mobile/presentation/season_feature/season_team_detail/bloc/season_team_detail_state.dart';
import 'package:baseketball_league_mobile/presentation/theme/app_color.dart';
import 'package:baseketball_league_mobile/presentation/theme/app_style.dart'
    show AppStyle;
import 'package:baseketball_league_mobile/presentation/widgets/app_loading.dart';
import 'package:baseketball_league_mobile/presentation/widgets/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PlayerListSection extends StatelessWidget {
  final SeasonTeamDetailState state;
  final int teamId;
  final int seasonId;
  const PlayerListSection({
    super.key,
    required this.state,
    required this.teamId,
    required this.seasonId,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text('Danh sách cầu thủ', style: AppStyle.headline6)],
        ),
        SizedBox(height: 16.sp),
        if (state.isGeneratingPlayers)
          Center(child: AppLoading())
        else if (state.players.isEmpty)
          EmptyWidget(
            message: 'Chưa có cầu thủ nào trong đội bóng này',
            description: 'Hãy tạo cầu thủ để thêm vào đội bóng này',
            buttonText: "Tạo ngẫu nhiên",
            onButtonPressed: () {
              context.read<SeasonTeamDetailCubit>().generatePlayersForTeam(
                teamId,
                seasonId,
              );
            },
          )
        else
          _buildPlayerList(context, state.players),
      ],
    );
  }

  /// Widget hiển thị danh sách cầu thủ
  Widget _buildPlayerList(
    BuildContext context,
    List<PlayerSeasonEntity> players,
  ) {
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: players.length,
      separatorBuilder: (context, index) => Divider(),
      itemBuilder: (context, index) {
        final player = players[index];
        return _buildPlayerItem(context, player, index + 1);
      },
    );
  }

  /// Widget hiển thị thông tin một cầu thủ
  Widget _buildPlayerItem(
    BuildContext context,
    PlayerSeasonEntity player,
    int index,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primary,
          child: Text(
            '${player.shirtNumber}',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text('Cầu thủ #${player.playerId}', style: AppStyle.bodyMedium),
        subtitle: Text('ID: ${player.id}', style: AppStyle.bodySmall),
        trailing: Icon(Icons.chevron_right),
        onTap: () {
          // Xử lý khi nhấn vào cầu thủ
        },
      ),
    );
  }
}
