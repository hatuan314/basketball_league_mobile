import 'package:baseketball_league_mobile/domain/entities/round_entity.dart';
import 'package:baseketball_league_mobile/presentation/season_feature/round/round_list/bloc/round_list_cubit.dart';
import 'package:baseketball_league_mobile/presentation/season_feature/round/round_list/bloc/round_list_state.dart';
import 'package:baseketball_league_mobile/presentation/season_feature/round/round_list/widgets/round_item_card.dart';
import 'package:baseketball_league_mobile/presentation/theme/app_colors.dart';
import 'package:baseketball_league_mobile/presentation/theme/app_style.dart';
import 'package:baseketball_league_mobile/presentation/widgets/app_loading.dart';
import 'package:baseketball_league_mobile/presentation/widgets/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Màn hình hiển thị danh sách vòng đấu của một mùa giải
class RoundListScreen extends StatefulWidget {
  /// ID của mùa giải
  final int seasonId;

  /// Constructor
  const RoundListScreen({Key? key, required this.seasonId}) : super(key: key);

  @override
  State<RoundListScreen> createState() => _RoundListScreenState();
}

class _RoundListScreenState extends State<RoundListScreen> {
  @override
  void initState() {
    super.initState();
    // Thiết lập ID mùa giải và lấy danh sách vòng đấu
    context.read<RoundListCubit>()
      ..setSeasonId(widget.seasonId)
      ..getRounds();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Vòng đấu', style: AppStyle.headline4)),
      body: BlocConsumer<RoundListCubit, RoundListState>(
        listener: (context, state) {
          // Hiển thị thông báo khi tạo vòng đấu thành công
          if (state.status == RoundListStatus.createSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Tạo vòng đấu thành công'),
                backgroundColor: Colors.green,
              ),
            );
          }

          // Hiển thị thông báo lỗi
          if (state.status == RoundListStatus.failure ||
              state.status == RoundListStatus.createFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Đã xảy ra lỗi'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          // Hiển thị loading khi đang tải dữ liệu
          if (state.status == RoundListStatus.loading ||
              state.status == RoundListStatus.initial) {
            return const AppLoading();
          }

          // Hiển thị loading khi đang tạo vòng đấu
          if (state.status == RoundListStatus.creating) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppLoading(),
                  SizedBox(height: 16),
                  Text('Đang tạo vòng đấu...'),
                ],
              ),
            );
          }

          // Hiển thị thông báo khi không có vòng đấu
          if (state.rounds.isEmpty) {
            return EmptyWidget(
              message: 'Chưa có vòng đấu nào',
              description: 'Mùa giải này chưa có vòng đấu nào được tạo',
              buttonText: 'Tạo vòng đấu tự động',
              onButtonPressed:
                  () => _showGenerateRoundsConfirmDialog(
                    context,
                    onConfirm:
                        () => context.read<RoundListCubit>().generateRounds(),
                  ),
            );
          }

          // Hiển thị danh sách vòng đấu
          return ListView.builder(
            padding: EdgeInsets.only(bottom: 80.h),
            itemCount: state.rounds.length,
            itemBuilder: (context, index) {
              final round = state.rounds[index];
              return RoundItemCard(
                round: round,
                onTap: () => _navigateToRoundDetail(context, round),
              );
            },
          );
        },
      ),
    );
  }

  /// Hiển thị dialog xác nhận tạo vòng đấu tự động
  void _showGenerateRoundsConfirmDialog(
    BuildContext context, {
    required Function() onConfirm,
  }) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Tạo vòng đấu tự động'),
            content: const Text(
              'Hệ thống sẽ tự động tạo các vòng đấu dựa trên số lượng đội tham gia và thời gian bắt đầu của mùa giải.\n\n'
              'Bạn có chắc chắn muốn tiếp tục?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Hủy'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.orange,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  onConfirm();
                },
                child: const Text(
                  'Xác nhận',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
    );
  }

  /// Điều hướng đến màn hình chi tiết vòng đấu
  void _navigateToRoundDetail(BuildContext context, RoundEntity round) {
    // TODO: Điều hướng đến màn hình chi tiết vòng đấu
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Chức năng xem chi tiết vòng đấu đang được phát triển'),
      ),
    );
  }
}
