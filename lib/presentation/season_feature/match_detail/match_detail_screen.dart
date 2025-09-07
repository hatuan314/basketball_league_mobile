import 'package:baseketball_league_mobile/domain/entities/match_detail_entity.dart';
import 'package:baseketball_league_mobile/domain/entities/match_referee_detail_entity.dart';
import 'package:baseketball_league_mobile/presentation/season_feature/match_detail/bloc/match_detail_cubit.dart';
import 'package:baseketball_league_mobile/presentation/season_feature/match_detail/bloc/match_detail_state.dart';
import 'package:baseketball_league_mobile/presentation/season_feature/match_detail/widgets/match_info_card.dart';
import 'package:baseketball_league_mobile/presentation/season_feature/match_detail/widgets/match_referee_card.dart';
import 'package:baseketball_league_mobile/presentation/season_feature/match_detail/widgets/match_score_card.dart';
import 'package:baseketball_league_mobile/presentation/season_feature/match_detail/widgets/match_stadium_card.dart';
import 'package:baseketball_league_mobile/presentation/theme/app_style.dart';
import 'package:baseketball_league_mobile/presentation/widgets/app_loading.dart';
import 'package:baseketball_league_mobile/presentation/widgets/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MatchDetailScreen extends StatefulWidget {
  final int matchId;
  final int roundId;

  const MatchDetailScreen({
    Key? key,
    required this.matchId,
    required this.roundId,
  }) : super(key: key);

  @override
  State<MatchDetailScreen> createState() => _MatchDetailScreenState();
}

class _MatchDetailScreenState extends State<MatchDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MatchDetailCubit>().initial(
        matchId: widget.matchId,
        roundId: widget.roundId,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết trận đấu', style: AppStyle.headline4),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<MatchDetailCubit>().refreshMatchDetail();
            },
          ),
        ],
      ),
      body: BlocConsumer<MatchDetailCubit, MatchDetailState>(
        listener: (context, state) {
          if (state.status == MatchDetailStatus.updateSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Cập nhật trận đấu thành công'),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state.status == MatchDetailStatus.updateFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.errorMessage ?? 'Cập nhật trận đấu thất bại',
                ),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state.status == MatchDetailStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.errorMessage ?? 'Lỗi khi tải thông tin trận đấu',
                ),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.status == MatchDetailStatus.loading) {
            return const AppLoading();
          } else if (state.match == null) {
            return const EmptyWidget(
              message: 'Không tìm thấy thông tin trận đấu',
            );
          }

          return _buildMatchDetail(context, state.match!, state.referees);
        },
      ),
    );
  }

  Widget _buildMatchDetail(
    BuildContext context,
    MatchDetailEntity match,
    List<MatchRefereeDetailEntity>? referees,
  ) {
    return RefreshIndicator(
      onRefresh: () async {
        await context.read<MatchDetailCubit>().refreshMatchDetail();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(16.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Thông tin cơ bản về trận đấu
            MatchInfoCard(match: match),
            SizedBox(height: 16.sp),

            // Thông tin về tỷ số và điểm số
            MatchScoreCard(
              match: match,
              onUpdateScore: (
                homePoints,
                awayPoints,
                homeFouls,
                awayFouls,
                attendance,
              ) {
                context.read<MatchDetailCubit>().updateMatchScore(
                  homePoints: homePoints,
                  awayPoints: awayPoints,
                  homeFouls: homeFouls,
                  awayFouls: awayFouls,
                  attendance: attendance,
                );
              },
            ),
            SizedBox(height: 16.sp),

            // Thông tin về sân vận động
            MatchStadiumCard(match: match),
            SizedBox(height: 16.sp),

            // Thông tin về trọng tài
            MatchRefereeCard(match: match, referees: referees),
          ],
        ),
      ),
    );
  }
}
