import 'package:baseketball_league_mobile/presentation/season_feature/top_player/bloc/top_player_season_cubit.dart';
import 'package:baseketball_league_mobile/presentation/season_feature/top_player/widgets/least_fouls_player_season_standing_table.dart';
import 'package:baseketball_league_mobile/presentation/season_feature/top_player/widgets/top_player_season_sort_button.dart';
import 'package:baseketball_league_mobile/presentation/season_feature/top_player/widgets/top_score_standing_table.dart';
import 'package:baseketball_league_mobile/presentation/theme/app_style.dart';
import 'package:baseketball_league_mobile/presentation/widgets/app_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TopPlayerScreen extends StatefulWidget {
  final int seasonId;
  const TopPlayerScreen({super.key, required this.seasonId});

  @override
  State<TopPlayerScreen> createState() => _TopPlayerScreenState();
}

class _TopPlayerScreenState extends State<TopPlayerScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TopPlayerSeasonCubit>().initial(widget.seasonId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bảng xếp hạng cầu thủ', style: AppStyle.headline4),
        actions: [TopPlayerSeasonSortButton()],
      ),
      body: BlocConsumer<TopPlayerSeasonCubit, TopPlayerSeasonState>(
        listener: (context, state) {
          if (state.status == TopPlayerSeasonStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMsg!),
                backgroundColor: Colors.red,
                action: SnackBarAction(
                  label: 'Thử lại',
                  textColor: Colors.white,
                  onPressed: () {
                    context.read<TopPlayerSeasonCubit>().initial(
                      widget.seasonId,
                    );
                  },
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.status == TopPlayerSeasonStatus.loading) {
            return const AppLoading();
          }
          if (state.sortCriteria == TopPlayerSeasonSortCriteria.topScores) {
            return TopScoreStandingTable(
              topScoresSeasons: state.topScoresSeasonList,
            );
          }
          return LeastFoulsPlayerSeasonStandingTable(
            leastFoulsPlayerSeasonList: state.leastFoulsPlayerSeasonList,
          );
        },
      ),
    );
  }
}
