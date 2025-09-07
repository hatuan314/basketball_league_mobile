import 'package:baseketball_league_mobile/common/widgets/app_loading.dart';
import 'package:baseketball_league_mobile/common/widgets/empty_widget.dart';
import 'package:baseketball_league_mobile/presentation/season_feature/round/round_detail/bloc/round_detail_cubit.dart';
import 'package:baseketball_league_mobile/presentation/season_feature/round/round_detail/bloc/round_detail_state.dart';
import 'package:baseketball_league_mobile/presentation/season_feature/round/round_detail/widgets/match_listview.dart';
import 'package:baseketball_league_mobile/presentation/season_feature/round/round_detail/widgets/round_info_widget.dart';
import 'package:baseketball_league_mobile/presentation/theme/app_color.dart';
import 'package:baseketball_league_mobile/presentation/theme/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Màn hình chi tiết vòng đấu
class RoundDetailScreen extends StatefulWidget {
  /// ID của vòng đấu
  final int roundId;

  /// Constructor
  const RoundDetailScreen({super.key, required this.roundId});

  @override
  State<RoundDetailScreen> createState() => _RoundDetailScreenState();
}

class _RoundDetailScreenState extends State<RoundDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RoundDetailCubit>().initial(widget.roundId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RoundDetailCubit, RoundDetailState>(
      listenWhen:
          (previous, current) =>
              current.status == RoundDetailStatus.createSuccess ||
              current.status == RoundDetailStatus.createFailure ||
              current.status == RoundDetailStatus.failure,
      listener: (context, state) {
        if (state.status == RoundDetailStatus.createSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Tạo trận đấu thành công'),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state.status == RoundDetailStatus.createFailure ||
            state.status == RoundDetailStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'Đã xảy ra lỗi'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              state.round != null
                  ? 'Vòng ${state.round!.roundNo}'
                  : 'Chi tiết vòng đấu',
              style: AppStyle.headline4,
            ),
          ),
          body: _buildBody(context, state),
          floatingActionButton:
              state.matches.isEmpty
                  ? FloatingActionButton.extended(
                    backgroundColor: AppColors.orange,
                    foregroundColor: Colors.white,
                    onPressed:
                        () => _showGenerateMatchesDialog(
                          context,
                          onGenerate:
                              () =>
                                  context
                                      .read<RoundDetailCubit>()
                                      .generateMatches(),
                        ),
                    icon: const Icon(Icons.add),
                    label: const Text('Tạo trận đấu'),
                  )
                  : null,
        );
      },
    );
  }

  /// Xây dựng nội dung chính của màn hình
  Widget _buildBody(BuildContext context, RoundDetailState state) {
    if (state.status == RoundDetailStatus.loading ||
        state.status == RoundDetailStatus.creating) {
      return const AppLoading();
    }

    if (state.round == null) {
      return const EmptyWidget(message: 'Không tìm thấy thông tin vòng đấu');
    }

    return RefreshIndicator(
      onRefresh: () => context.read<RoundDetailCubit>().refresh(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thông tin vòng đấu
            RoundInfoWidget(round: state.round!),

            // Danh sách trận đấu
            MatchListview(matches: state.matches),
          ],
        ),
      ),
    );
  }

  /// Hiển thị dialog xác nhận tạo trận đấu
  void _showGenerateMatchesDialog(
    BuildContext context, {
    required Function() onGenerate,
  }) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Tạo trận đấu'),
            content: const Text(
              'Bạn có muốn tạo tự động các trận đấu cho vòng đấu này không?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Hủy'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  onGenerate();
                },
                child: const Text('Tạo'),
              ),
            ],
          ),
    );
  }
}
