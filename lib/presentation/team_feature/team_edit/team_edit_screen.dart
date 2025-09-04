import 'package:baseketball_league_mobile/domain/entities/team_entity.dart';
import 'package:baseketball_league_mobile/presentation/team_feature/team_edit/bloc/team_edit_cubit.dart';
import 'package:baseketball_league_mobile/presentation/theme/app_color.dart';
import 'package:baseketball_league_mobile/presentation/theme/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class TeamEditScreen extends StatefulWidget {
  final TeamEntity? team;
  
  const TeamEditScreen({
    Key? key,
    this.team,
  }) : super(key: key);

  @override
  State<TeamEditScreen> createState() => _TeamEditScreenState();
}

class _TeamEditScreenState extends State<TeamEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _codeController = TextEditingController();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.team != null;
    if (_isEditing) {
      _nameController.text = widget.team!.name ?? '';
      _codeController.text = widget.team!.code ?? '';
    }
    
    // Khởi tạo trạng thái cho TeamEditCubit
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TeamEditCubit>().initialize(isEditing: _isEditing);
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TeamEditCubit, TeamEditState>(
      listener: (context, state) {
        if (state.status == TeamEditStatus.success) {
          context.pop();
        } else if (state.status == TeamEditStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'Đã xảy ra lỗi'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            _isEditing ? 'Chỉnh sửa đội bóng' : 'Thêm đội bóng mới',
            style: AppStyle.headline5,
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: EdgeInsets.all(16.sp),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildNameField(),
                SizedBox(height: 16.sp),
                _buildCodeField(),
                SizedBox(height: 24.sp),
                _buildSubmitButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      decoration: InputDecoration(
        labelText: 'Tên đội bóng',
        hintText: 'Nhập tên đội bóng',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.sp),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Vui lòng nhập tên đội bóng';
        }
        return null;
      },
    );
  }

  Widget _buildCodeField() {
    return TextFormField(
      controller: _codeController,
      decoration: InputDecoration(
        labelText: 'Mã đội bóng',
        hintText: 'Nhập mã đội bóng (ví dụ: LAL, BOS)',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.sp),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Vui lòng nhập mã đội bóng';
        }
        if (value.length < 2 || value.length > 5) {
          return 'Mã đội bóng phải từ 2-5 ký tự';
        }
        return null;
      },
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        padding: EdgeInsets.symmetric(vertical: 12.sp),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.sp),
        ),
      ),
      onPressed: () => _submitForm(context),
      child: Text(
        _isEditing ? 'Cập nhật' : 'Thêm mới',
        style: AppStyle.buttonLarge.copyWith(color: Colors.white),
      ),
    );
  }

  void _submitForm(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      final teamEditCubit = context.read<TeamEditCubit>();
      
      final team = TeamEntity(
        id: _isEditing ? widget.team!.id : null,
        name: _nameController.text,
        code: _codeController.text,
      );
      
      if (_isEditing) {
        await teamEditCubit.updateTeam(team);
      } else {
        await teamEditCubit.addTeam(team);
      }
    }
  }
}
