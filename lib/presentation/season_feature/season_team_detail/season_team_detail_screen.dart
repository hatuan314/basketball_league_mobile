import 'package:baseketball_league_mobile/presentation/season_feature/season_team_detail/bloc/season_team_detail_cubit.dart';
import 'package:baseketball_league_mobile/presentation/season_feature/season_team_detail/bloc/season_team_detail_state.dart';
import 'package:baseketball_league_mobile/presentation/season_feature/season_team_detail/widgets/competition_results_widget.dart'
    show CompetitionResultsWidget;
import 'package:baseketball_league_mobile/presentation/season_feature/season_team_detail/widgets/player_list_section.dart';
import 'package:baseketball_league_mobile/presentation/theme/app_style.dart';
import 'package:baseketball_league_mobile/presentation/widgets/app_error_state_widget.dart';
import 'package:baseketball_league_mobile/presentation/widgets/app_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Màn hình chi tiết đội bóng
class SeasonTeamDetailScreen extends StatefulWidget {
  /// ID của đội bóng
  final int teamId;

  /// ID của mùa giải
  final int seasonId;

  /// Tên đội bóng
  final String teamName;

  /// Constructor
  const SeasonTeamDetailScreen({
    Key? key,
    required this.teamId,
    required this.seasonId,
    required this.teamName,
  }) : super(key: key);

  @override
  State<SeasonTeamDetailScreen> createState() => _SeasonTeamDetailScreenState();
}

class _SeasonTeamDetailScreenState extends State<SeasonTeamDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<SeasonTeamDetailCubit>().loadTeamDetail(
      widget.teamId,
      widget.seasonId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.teamName, style: AppStyle.headline4)),
      body: BlocConsumer<SeasonTeamDetailCubit, SeasonTeamDetailState>(
        listener: (context, state) {
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.status == SeasonTeamDetailStatus.loading) {
            return const Center(child: AppLoading());
          } else if (state.status == SeasonTeamDetailStatus.error) {
            return AppErrorStateWidget(
              errorMessage: state.errorMessage!,
              onRetry: () {
                context.read<SeasonTeamDetailCubit>().loadTeamDetail(
                  widget.teamId,
                  widget.seasonId,
                );
              },
            );
          }

          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16.sp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CompetitionResultsWidget(teamStanding: state.teamStanding!),
                  SizedBox(height: 16.sp),
                  PlayerListSection(
                    state: state,
                    teamId: widget.teamId,
                    seasonId: widget.seasonId,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
