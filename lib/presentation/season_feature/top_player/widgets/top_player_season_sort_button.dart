import 'package:baseketball_league_mobile/presentation/season_feature/top_player/bloc/top_player_season_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TopPlayerSeasonSortButton extends StatelessWidget {
  const TopPlayerSeasonSortButton({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<TopPlayerSeasonSortCriteria>(
      icon: const Icon(Icons.sort),
      onSelected: (TopPlayerSeasonSortCriteria criteria) {
        context.read<TopPlayerSeasonCubit>().sortTopPlayerSeason(criteria);
      },
      itemBuilder:
          (BuildContext context) =>
              <PopupMenuEntry<TopPlayerSeasonSortCriteria>>[
                const PopupMenuItem<TopPlayerSeasonSortCriteria>(
                  value: TopPlayerSeasonSortCriteria.topScores,
                  child: Text('Sắp xếp theo số điểm cao nhất'),
                ),
                const PopupMenuItem<TopPlayerSeasonSortCriteria>(
                  value: TopPlayerSeasonSortCriteria.leastFouls,
                  child: Text('Sắp xếp theo số lỗi ít nhất'),
                ),
              ],
    );
  }
}
