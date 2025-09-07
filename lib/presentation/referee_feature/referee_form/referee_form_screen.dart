import 'package:baseketball_league_mobile/presentation/referee_feature/referee_form/bloc/referee_form_cubit.dart';
import 'package:baseketball_league_mobile/presentation/referee_feature/referee_form/bloc/referee_form_state.dart';
import 'package:baseketball_league_mobile/presentation/theme/app_color.dart';
import 'package:baseketball_league_mobile/presentation/widgets/app_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Màn hình form thêm/sửa trọng tài
class RefereeFormScreen extends StatefulWidget {
  /// ID của trọng tài (null nếu là thêm mới)
  final int? refereeId;

  /// Constructor
  const RefereeFormScreen({super.key, this.refereeId});

  @override
  State<RefereeFormScreen> createState() => _RefereeFormScreenState();
}

class _RefereeFormScreenState extends State<RefereeFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();

  bool get _isEditing => widget.refereeId != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      // Nếu là chỉnh sửa, lấy thông tin trọng tài
      context.read<RefereeFormCubit>().loadRefereeForEdit(widget.refereeId!);
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocConsumer<RefereeFormCubit, RefereeFormState>(
        listenWhen:
            (previous, current) =>
                current.status == RefereeFormStatus.saveSuccess ||
                current.status == RefereeFormStatus.saveFailure,
        listener: (context, state) {
          if (state.status == RefereeFormStatus.saveSuccess) {
            // Hiển thị thông báo thành công
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Lưu thông tin trọng tài thành công'),
                backgroundColor: Colors.green,
              ),
            );
            // Quay lại màn hình trước
            Navigator.of(context).pop(true);
          } else if (state.status == RefereeFormStatus.saveFailure) {
            // Hiển thị thông báo lỗi
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Đã xảy ra lỗi'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          // Đang tải dữ liệu
          if (state.status == RefereeFormStatus.loading) {
            return const Center(child: AppLoading());
          }

          // Đang lưu dữ liệu
          if (state.status == RefereeFormStatus.saving) {
            return const Center(child: AppLoading());
          }

          // Cập nhật các controller nếu có dữ liệu
          if (_isEditing &&
              state.referee != null &&
              _fullNameController.text.isEmpty) {
            _fullNameController.text = state.referee!.fullName ?? '';
            _emailController.text = state.referee!.email ?? '';
          }

          // Hiển thị form
          return SingleChildScrollView(
            padding: EdgeInsets.all(16.sp),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tiêu đề
                  Text(
                    _isEditing
                        ? 'Chỉnh sửa thông tin trọng tài'
                        : 'Thêm trọng tài mới',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(height: 24.sp),
                  // Form họ tên
                  TextFormField(
                    controller: _fullNameController,
                    decoration: InputDecoration(
                      labelText: 'Họ và tên',
                      hintText: 'Nhập họ và tên trọng tài',
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.sp),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập họ và tên';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.sp),
                  // Form email
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      hintText: 'Nhập địa chỉ email',
                      prefixIcon: const Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.sp),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập email';
                      }
                      // Kiểm tra định dạng email
                      final emailRegExp = RegExp(
                        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                      );
                      if (!emailRegExp.hasMatch(value)) {
                        return 'Email không đúng định dạng';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 32.sp),
                  // Các nút hành động
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Nút hủy
                      OutlinedButton.icon(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(Icons.cancel),
                        label: const Text('Hủy'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.grey,
                          side: BorderSide(color: AppColors.grey),
                          padding: EdgeInsets.symmetric(
                            horizontal: 24.sp,
                            vertical: 12.sp,
                          ),
                        ),
                      ),
                      SizedBox(width: 16.sp),
                      // Nút lưu
                      ElevatedButton.icon(
                        onPressed: _saveReferee,
                        icon: const Icon(Icons.save),
                        label: const Text('Lưu'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            horizontal: 24.sp,
                            vertical: 12.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// Lưu thông tin trọng tài
  void _saveReferee() {
    // Kiểm tra form hợp lệ
    if (_formKey.currentState?.validate() ?? false) {
      context.read<RefereeFormCubit>().saveReferee(
        id: widget.refereeId,
        fullName: _fullNameController.text,
        email: _emailController.text,
      );
    }
  }
}
