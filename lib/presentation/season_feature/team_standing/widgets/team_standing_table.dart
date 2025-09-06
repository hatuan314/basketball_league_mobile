import 'package:baseketball_league_mobile/domain/entities/team_standing_entity.dart';
import 'package:baseketball_league_mobile/presentation/season_feature/team_standing/bloc/team_standing_cubit.dart';
import 'package:baseketball_league_mobile/presentation/season_feature/team_standing/bloc/team_standing_state.dart';
import 'package:baseketball_league_mobile/presentation/season_feature/team_standing/widgets/team_standing_item_widget.dart';
import 'package:baseketball_league_mobile/presentation/theme/app_color.dart';
import 'package:baseketball_league_mobile/presentation/widgets/app_loading.dart';
import 'package:baseketball_league_mobile/presentation/widgets/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TeamStandingTable extends StatelessWidget {
  final int seasonId;
  final String seasonName;
  const TeamStandingTable({
    super.key,
    required this.seasonId,
    required this.seasonName,
  });

  Widget _buildTableHeader() {
    return Container(
      color: AppColors.primary.withValues(alpha: 0.1),
      padding: EdgeInsets.symmetric(vertical: 8.sp, horizontal: 4.sp),
      child: Row(
        children: [
          SizedBox(width: 40.sp, child: const Text('#')),
          Expanded(flex: 3, child: const Text('Đội bóng')),
          Expanded(child: const Text('Thắng', textAlign: TextAlign.center)),
          Expanded(child: const Text('Thua', textAlign: TextAlign.center)),
          Expanded(child: const Text('Hiệu số', textAlign: TextAlign.center)),
          Expanded(child: const Text('Điểm', textAlign: TextAlign.center)),
        ],
      ),
    );
  }

  Widget _buildTeamStandingsList(List<TeamStandingEntity> teamStandings) {
    return ListView.builder(
      itemCount: teamStandings.length,
      itemBuilder: (context, index) {
        final team = teamStandings[index];
        return TeamStandingItemWidget(team: team, rank: index + 1);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTableHeader(),
        Expanded(
          child: BlocBuilder<TeamStandingCubit, TeamStandingState>(
            builder: (context, state) {
              if (state.isLoading) {
                return const AppLoading();
              }

              if (state.errorMessage != null) {
                // Hiển thị thông báo lỗi bằng SnackBar
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.errorMessage!),
                      backgroundColor: Colors.red,
                      action: SnackBarAction(
                        label: 'Thử lại',
                        textColor: Colors.white,
                        onPressed: () {
                          context.read<TeamStandingCubit>().getTeamStandings(
                            seasonId,
                            seasonName,
                          );
                        },
                      ),
                    ),
                  );
                });

                // Hiển thị widget trống khi có lỗi
                return EmptyWidget(
                  message: 'Không có dữ liệu',
                  description: 'Không tìm thấy bảng xếp hạng cho mùa giải này',
                  buttonText: 'Tạo dữ liệu mẫu',
                  onButtonPressed: () {
                    context.read<TeamStandingCubit>().createBulkSeasonTeams();
                  },
                );
              }

              if (state.teamStandings.isEmpty) {
                return EmptyWidget(
                  message: 'Không có dữ liệu',
                  description: 'Không tìm thấy bảng xếp hạng cho mùa giải này',
                  buttonText: 'Tạo dữ liệu mẫu',
                  onButtonPressed: () {
                    context.read<TeamStandingCubit>().createBulkSeasonTeams();
                  },
                );
              }

              return _buildTeamStandingsList(state.teamStandings);
            },
          ),
        ),
      ],
    );
  }
}
