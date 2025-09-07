import 'package:baseketball_league_mobile/common/constants/router_name.dart';
import 'package:baseketball_league_mobile/common/extentions/route_extension.dart';
import 'package:baseketball_league_mobile/domain/entities/season_entity.dart';
import 'package:baseketball_league_mobile/presentation/season_feature/season_list/bloc/season_list_cubit.dart';
import 'package:baseketball_league_mobile/presentation/season_feature/season_list/widgets/season_item_card.dart';
import 'package:baseketball_league_mobile/presentation/theme/app_color.dart';
import 'package:baseketball_league_mobile/presentation/theme/app_style.dart';
import 'package:baseketball_league_mobile/presentation/widgets/app_error_state_widget.dart';
import 'package:baseketball_league_mobile/presentation/widgets/app_loading.dart';
import 'package:baseketball_league_mobile/presentation/widgets/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class SeasonListScreen extends StatefulWidget {
  const SeasonListScreen({super.key});

  @override
  State<SeasonListScreen> createState() => _SeasonListScreenState();
}

class _SeasonListScreenState extends State<SeasonListScreen> {
  /// Controller cho text field tìm kiếm
  final TextEditingController _searchController = TextEditingController();

  /// Biến để kiểm soát hiển thị thanh tìm kiếm
  bool _showSearchBar = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SeasonListCubit>().initial();
    });
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  /// Xử lý khi nội dung tìm kiếm thay đổi
  void _onSearchChanged() {
    context.read<SeasonListCubit>().searchSeasons(_searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: _showSearchBar ? false : true,
        title:
            _showSearchBar
                ? TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Tìm kiếm giải đấu...',
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 14.sp),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 8.h),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear, color: AppColors.primary),
                      padding: EdgeInsets.all(8.r),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          _showSearchBar = false;
                        });
                        context.read<SeasonListCubit>().initial();
                      },
                    ),
                  ),
                  style: AppStyle.bodyLarge,
                  autofocus: true,
                )
                : Text('Danh sách giải đấu', style: AppStyle.headline4),
        actions: [
          if (!_showSearchBar) ...[
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                setState(() {
                  _showSearchBar = true;
                });
              },
              tooltip: 'Tìm kiếm',
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                context.read<SeasonListCubit>().initial();
              },
              tooltip: 'Làm mới',
            ),
          ],
        ],
      ),
      body: BlocBuilder<SeasonListCubit, SeasonListState>(
        builder: (context, state) {
          if (state.status == SeasonListStatus.loading) {
            return AppLoading();
          } else if (state.status == SeasonListStatus.error) {
            return AppErrorStateWidget(
              errorMessage: state.errorMessage ?? 'Đã xảy ra lỗi',
              onRetry: () => context.read<SeasonListCubit>().initial(),
            );
          } else {
            return _buildSeasonListView(state.seasons ?? []);
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.orange,
        onPressed: () {
          context
              .push(
                RouterName.seasonEdit.toSeasonRoute(),
                extra: {'season': null, 'isEditing': false},
              )
              .then((result) {
                if (result == true) {
                  context.read<SeasonListCubit>().initial();
                }
              });
        },
        child: const Icon(Icons.add, color: AppColors.white),
      ),
    );
  }

  Widget _buildSeasonListView(List<SeasonEntity> seasons) {
    if (seasons.isEmpty) {
      return EmptyWidget(
        message: 'Chưa có mùa giải nào',
        description: 'Hãy thêm mùa giải mới bằng nút + bên dưới',
        buttonText: 'Tạo dữ liệu mẫu',
        onButtonPressed: () {
          context.read<SeasonListCubit>().createRandomSeasons();
        },
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16.sp),
      itemCount: seasons.length,
      itemBuilder: (context, index) {
        final season = seasons[index];
        return SeasonItemCard(
          season: season,
          onEdit: _handleEditSeason,
          onDelete: _handleDeleteSeason,
        );
      },
    );
  }

  /// Xử lý sự kiện sửa mùa giải
  void _handleEditSeason(SeasonEntity season) {
    context
        .push(
          RouterName.seasonEdit.toSeasonRoute(),
          extra: {'season': season, 'isEditing': true},
        )
        .then((result) {
          if (result == true) {
            context.read<SeasonListCubit>().initial();
          }
        });
  }

  /// Xử lý sự kiện xóa mùa giải
  void _handleDeleteSeason(SeasonEntity season) {
    // Hiển thị hộp thoại xác nhận trước khi xóa
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Xác nhận xóa'),
            content: Text(
              'Bạn có chắc chắn muốn xóa mùa giải "${season.name}"?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Hủy'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  context.read<SeasonListCubit>().deleteSeason(season);
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: Text('Xóa'),
              ),
            ],
          ),
    );
  }
}
