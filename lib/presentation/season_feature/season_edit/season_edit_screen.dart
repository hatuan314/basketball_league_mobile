import 'package:baseketball_league_mobile/common/injection.dart';
import 'package:baseketball_league_mobile/domain/entities/season_entity.dart';
import 'package:baseketball_league_mobile/domain/usecases/season_usecase.dart';
import 'package:baseketball_league_mobile/presentation/season_feature/season_edit/bloc/season_edit_cubit.dart';
import 'package:baseketball_league_mobile/presentation/season_feature/season_edit/bloc/season_edit_state.dart';
import 'package:baseketball_league_mobile/presentation/season_feature/season_edit/widgets/index.dart';
import 'package:baseketball_league_mobile/presentation/theme/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class SeasonEditScreen extends StatelessWidget {
  final SeasonEntity? season;
  final bool isEditing;

  const SeasonEditScreen({super.key, this.season, required this.isEditing});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SeasonEditCubit(
        seasonUsecase: sl<SeasonUsecase>(),
        season: season,
        isEditing: isEditing,
      ),
      child: const _SeasonEditView(),
    );
  }
}

class _SeasonEditView extends StatefulWidget {
  const _SeasonEditView();

  @override
  State<_SeasonEditView> createState() => _SeasonEditViewState();
}

class _SeasonEditViewState extends State<_SeasonEditView> {
  final _nameController = TextEditingController();
  final _codeController = TextEditingController();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  void _initializeControllers() {
    final season = context.read<SeasonEditCubit>().state.season;
    if (season != null) {
      _nameController.text = season.name ?? '';
      _codeController.text = season.code ?? '';

      if (season.startDate != null) {
        _startDateController.text = DateFormat(
          'dd/MM/yyyy',
        ).format(season.startDate!);
      }

      if (season.endDate != null) {
        _endDateController.text = DateFormat(
          'dd/MM/yyyy',
        ).format(season.endDate!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SeasonEditCubit, SeasonEditState>(
      listener: (context, state) {
        if (state.status == SeasonEditStatus.error && state.errorMessage != null && state.errorMessage!.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.all(16.r),
            ),
          );
        } else if (state.status == SeasonEditStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.isEditing ? 'Cập nhật giải đấu thành công!' : 'Tạo giải đấu thành công!'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.all(16.r),
              duration: const Duration(seconds: 2),
            ),
          );
          // Đóng màn hình và trả về true để cập nhật danh sách
          Future.delayed(const Duration(milliseconds: 500), () {
            Navigator.pop(context, true);
          });
        }
      },
      builder: (context, state) {
        final isEditing = state.isEditing;
        final title = isEditing ? 'Chỉnh sửa giải đấu' : 'Thêm giải đấu mới';

        return Scaffold(
          appBar: AppBar(
            title: Text(title, style: AppStyle.headline4),
            centerTitle: true,
          ),
          body: _buildForm(context, state),
          bottomNavigationBar: _buildBottomBar(context),
        );
      },
    );
  }

  Widget _buildForm(BuildContext context, SeasonEditState state) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Lỗi sẽ được hiển thị bằng SnackBar

              // Card chứa form
              FormContainerWidget(
                children: [
                    // Tên giải đấu
                    FormFieldWidget(
                      label: 'Tên giải đấu',
                      hintText: 'Nhập tên giải đấu',
                      controller: _nameController,
                      onChanged: (value) => context.read<SeasonEditCubit>().updateName(value),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập tên giải đấu';
                        }
                        if (value.length < 3) {
                          return 'Tên giải đấu phải có ít nhất 3 ký tự';
                        }
                        if (value.length > 100) {
                          return 'Tên giải đấu không được quá 100 ký tự';
                        }
                        return null;
                      },
                      prefixIcon: Icons.edit,
                      labelIcon: Icons.sports_basketball,
                    ),

                    // Mã giải đấu
                    FormFieldWidget(
                      label: 'Mã giải đấu',
                      hintText: 'Nhập mã giải đấu',
                      controller: _codeController,
                      onChanged: (value) => context.read<SeasonEditCubit>().updateCode(value),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập mã giải đấu';
                        }
                        if (!RegExp(r'^[A-Za-z0-9_-]+$').hasMatch(value)) {
                          return 'Mã giải đấu chỉ được chứa chữ cái, số, gạch dưới và gạch ngang';
                        }
                        if (value.length < 2) {
                          return 'Mã giải đấu phải có ít nhất 2 ký tự';
                        }
                        if (value.length > 20) {
                          return 'Mã giải đấu không được quá 20 ký tự';
                        }
                        return null;
                      },
                      prefixIcon: Icons.tag,
                      labelIcon: Icons.code,
                    ),

                    // Ngày bắt đầu
                    DateFieldWidget(
                      label: 'Ngày bắt đầu',
                      hintText: 'Chọn ngày bắt đầu',
                      controller: _startDateController,
                      onDateSelected: (date) => context.read<SeasonEditCubit>().updateStartDate(date),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng chọn ngày bắt đầu';
                        }

                        // Kiểm tra ngày bắt đầu không được trước ngày hiện tại quá 1 năm
                        try {
                          final startDate = DateFormat('dd/MM/yyyy').parse(value);
                          final oneYearAgo = DateTime.now().subtract(
                            const Duration(days: 365),
                          );

                          if (startDate.isBefore(oneYearAgo)) {
                            return 'Ngày bắt đầu không được trước ngày hiện tại quá 1 năm';
                          }
                        } catch (e) {
                          return 'Ngày không hợp lệ';
                        }

                        return null;
                      },
                      prefixIcon: Icons.event,
                      labelIcon: Icons.calendar_today,
                    ),

                    // Ngày kết thúc
                    DateFieldWidget(
                      label: 'Ngày kết thúc',
                      hintText: 'Chọn ngày kết thúc',
                      controller: _endDateController,
                      onDateSelected: (date) => context.read<SeasonEditCubit>().updateEndDate(date),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng chọn ngày kết thúc';
                        }

                        // Kiểm tra ngày kết thúc phải sau ngày bắt đầu
                        try {
                          final endDate = DateFormat('dd/MM/yyyy').parse(value);

                          if (_startDateController.text.isNotEmpty) {
                            final startDate = DateFormat('dd/MM/yyyy').parse(_startDateController.text);

                            if (endDate.isBefore(startDate) || endDate.isAtSameMomentAs(startDate)) {
                              return 'Ngày kết thúc phải sau ngày bắt đầu';
                            }

                            // Kiểm tra thời gian giải đấu không quá 1 năm
                            final difference = endDate.difference(startDate).inDays;
                            if (difference > 365) {
                              return 'Thời gian giải đấu không được quá 1 năm';
                            }
                          }

                          // Kiểm tra ngày kết thúc không được quá 2 năm từ hiện tại
                          final twoYearsLater = DateTime.now().add(
                            const Duration(days: 365 * 2),
                          );
                          if (endDate.isAfter(twoYearsLater)) {
                            return 'Ngày kết thúc không được quá 2 năm từ hiện tại';
                          }
                        } catch (e) {
                          return 'Ngày không hợp lệ';
                        }

                        return null;
                      },
                      prefixIcon: Icons.event_available,
                      labelIcon: Icons.event_available,
                    ),
                  ],
                ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return BottomBarWidget(
      onCancel: () => Navigator.pop(context),
      onSave: _saveSeason,
    );
  }

  // Phương thức _selectDate đã được chuyển vào DateFieldWidget

  void _saveSeason() {
    if (_formKey.currentState!.validate()) {
      context.read<SeasonEditCubit>().saveSeason();
    }
  }
}
