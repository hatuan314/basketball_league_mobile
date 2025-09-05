import 'package:baseketball_league_mobile/common/constants/router_name.dart';
import 'package:baseketball_league_mobile/common/extentions/route_extension.dart';
import 'package:baseketball_league_mobile/common/injection.dart';
import 'package:baseketball_league_mobile/data/models/stadium_model.dart';
import 'package:baseketball_league_mobile/presentation/stadium_feature/stadium_list/bloc/stadium_list_cubit.dart';
import 'package:baseketball_league_mobile/presentation/stadium_feature/stadium_list/bloc/stadium_list_state.dart';
import 'package:baseketball_league_mobile/presentation/stadium_feature/stadium_list/widgets/stadium_item.dart';
import 'package:baseketball_league_mobile/presentation/theme/app_colors.dart';
import 'package:baseketball_league_mobile/presentation/theme/app_style.dart';
import 'package:baseketball_league_mobile/presentation/widgets/app_error_state_widget.dart';
import 'package:baseketball_league_mobile/presentation/widgets/app_loading.dart';
import 'package:baseketball_league_mobile/presentation/widgets/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class StadiumListScreen extends StatelessWidget {
  const StadiumListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<StadiumListCubit>()..getStadiums(),
      child: const _StadiumListView(),
    );
  }
}

class _StadiumListView extends StatefulWidget {
  const _StadiumListView();

  @override
  State<_StadiumListView> createState() => _StadiumListViewState();
}

class _StadiumListViewState extends State<_StadiumListView> {
  /// Controller cho text field tìm kiếm
  final TextEditingController _searchController = TextEditingController();

  /// Biến để kiểm soát hiển thị thanh tìm kiếm
  bool _showSearchBar = false;
  @override
  void initState() {
    super.initState();
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
    context.read<StadiumListCubit>().searchStadiums(_searchController.text);
  }

  void _loadStadiums() {
    context.read<StadiumListCubit>().getStadiums();
  }

  void _createTable() {
    context.read<StadiumListCubit>().createTable();
  }

  Future<void> _generateRandomStadiums() async {
    // Hiển thị dialog để nhập số lượng
    final TextEditingController countController = TextEditingController(
      text: '5',
    );
    final int? count = await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Tạo sân vận động ngẫu nhiên'),
          content: TextField(
            controller: countController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Số lượng',
              hintText: 'Nhập số lượng sân vận động cần tạo',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                final count = int.tryParse(countController.text);
                Navigator.pop(context, count);
              },
              child: const Text('Tạo'),
            ),
          ],
        );
      },
    );

    if (count == null || count <= 0) return;

    context.read<StadiumListCubit>().generateRandomStadiums(count);
  }

  void _deleteStadium(int id) {
    context.read<StadiumListCubit>().deleteStadium(id);
  }

  Widget _buildBody() {
    return BlocConsumer<StadiumListCubit, StadiumListState>(
      listener: (context, state) {
        if (state is StadiumTableCreated) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Tạo bảng thành công!'),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is StadiumTableError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Lỗi khi tạo bảng: ${state.message}'),
              backgroundColor: Colors.red,
            ),
          );
        } else if (state is StadiumDeleted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Xóa sân vận động thành công!'),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is StadiumDeleteError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Lỗi khi xóa: ${state.message}'),
              backgroundColor: Colors.red,
            ),
          );
        } else if (state is StadiumRandomCreated) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Đã tạo ${state.stadiums.length} sân vận động ngẫu nhiên',
              ),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is StadiumRandomError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Lỗi khi tạo dữ liệu: ${state.message}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is StadiumListLoading) {
          return AppLoading();
        }

        if (state is StadiumListError) {
          return AppErrorStateWidget(
            errorMessage: state.message,
            onRetry: _loadStadiums,
          );
        }

        if (state is StadiumListLoaded) {
          if (state.stadiums.isEmpty) {
            return EmptyWidget(
              message: 'Chưa có sân vận động nào',
              description: 'Hãy thêm sân vận động mới hoặc tạo dữ liệu mẫu',
              buttonText: 'Tạo dữ liệu mẫu',
              onButtonPressed: () => _generateRandomStadiums(),
            );
          }

          return RefreshIndicator(
            onRefresh: () async => _loadStadiums(),
            child: ListView.builder(
              padding: EdgeInsets.all(16.r),
              itemCount: state.stadiums.length,
              itemBuilder: (context, index) {
                final stadium = state.stadiums[index];
                return StadiumItem(
                  stadium: stadium,
                  onEdit:
                      () => context
                          .push(
                            RouterName.stadiumEdit.toStadiumRoute(),
                            extra: {'stadium': stadium, 'isEditing': true},
                          )
                          .then((_) => _loadStadiums()),
                  onDelete: () => _showDeleteConfirmation(stadium),
                );
              },
            ),
          );
        }

        return EmptyWidget(
          message: 'Chưa có sân vận động nào',
          description: 'Hãy thêm sân vận động mới hoặc tạo dữ liệu mẫu',
          buttonText: 'Tạo dữ liệu mẫu',
          onButtonPressed: () => _generateRandomStadiums(),
        );
      },
    );
  }

  void _showDeleteConfirmation(StadiumModel stadium) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Xác nhận xóa'),
            content: Text(
              'Bạn có chắc chắn muốn xóa sân vận động "${stadium.name}"?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Hủy'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  if (stadium.id != null) {
                    _deleteStadium(stadium.id!);
                  }
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Xóa'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            _showSearchBar
                ? TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Tìm kiếm sân vận động...',
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
                        _loadStadiums();
                      },
                    ),
                  ),
                  style: AppStyle.bodyLarge,
                  autofocus: true,
                )
                : Text('Danh sách sân vận động', style: AppStyle.headline4),
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
              onPressed: _loadStadiums,
              tooltip: 'Làm mới',
            ),
          ],
        ],
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.orange,
        onPressed:
            () => context
                .push(
                  RouterName.stadiumEdit.toStadiumRoute(),
                  extra: {'stadium': null, 'isEditing': false},
                )
                .then((_) => _loadStadiums()),
        child: const Icon(Icons.add, color: AppColors.white),
      ),
    );
  }
}
