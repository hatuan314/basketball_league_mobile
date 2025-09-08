import 'package:baseketball_league_mobile/domain/entities/match_detail_entity.dart';
import 'package:baseketball_league_mobile/presentation/season_feature/match_detail/bloc/match_detail_cubit.dart';
import 'package:baseketball_league_mobile/presentation/season_feature/match_detail/bloc/match_detail_state.dart';
import 'package:baseketball_league_mobile/presentation/season_feature/match_detail/widgets/match_player_listview.dart';
import 'package:baseketball_league_mobile/presentation/theme/app_style.dart';
import 'package:baseketball_league_mobile/presentation/widgets/app_loading.dart';
import 'package:baseketball_league_mobile/presentation/widgets/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomePlayersTab extends StatelessWidget {
  final MatchDetailEntity match;

  const HomePlayersTab({super.key, required this.match});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MatchDetailCubit, MatchDetailState>(
      listener: (context, state) {
        if (state.status == MatchDetailStatus.loadPlayersSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Đã thêm cầu thủ vào trận đấu thành công'),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state.status == MatchDetailStatus.loadPlayersFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.errorMessage ?? 'Lỗi khi thêm cầu thủ vào trận đấu',
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      buildWhen:
          (previous, current) =>
              previous.status != current.status ||
              previous.registeredPlayerIds != current.registeredPlayerIds ||
              previous.homeTeamPlayers != current.homeTeamPlayers,
      builder: (context, state) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.all(16.sp),
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.sp),
            ),
            child: Padding(
              padding: EdgeInsets.all(16.sp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Danh sách cầu thủ ${match.homeTeamName ?? "Đội nhà"}',
                    style: AppStyle.headline5,
                  ),
                  SizedBox(height: 16.sp),
                  if (state.status == MatchDetailStatus.loadingPlayers)
                    const AppLoading()
                  else if (state.homeTeamPlayers == null ||
                      state.homeTeamPlayers!.isEmpty)
                    EmptyWidget(
                      message: 'Chưa có dữ liệu cầu thủ',
                      description:
                          'Danh sách cầu thủ đội nhà chưa được cập nhật',
                      buttonText: 'Tự động thêm cầu thủ',
                      onButtonPressed: () {
                        context
                            .read<MatchDetailCubit>()
                            .autoRegisterHomePlayersForMatch();
                      },
                    )
                  else
                    MatchPlayerListview(players: state.homeTeamPlayers!),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
