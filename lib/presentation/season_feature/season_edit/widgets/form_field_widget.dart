import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:baseketball_league_mobile/presentation/theme/app_color.dart';

class FormFieldWidget extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final Function(String) onChanged;
  final String? Function(String?) validator;
  final IconData prefixIcon;
  final IconData? labelIcon;

  const FormFieldWidget({
    super.key,
    required this.label,
    required this.hintText,
    required this.controller,
    required this.onChanged,
    required this.validator,
    required this.prefixIcon,
    this.labelIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Row(
          children: [
            Icon(
              labelIcon ?? Icons.label,
              size: 18.sp,
              color: AppColors.primary,
            ),
            SizedBox(width: 8.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        
        // Text field
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(
                color: AppColors.primary,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: Colors.red, width: 1),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 12.w,
              vertical: 16.h,
            ),
            prefixIcon: Icon(prefixIcon, color: Colors.grey),
            filled: true,
            fillColor: Colors.grey.shade50,
          ),
          onChanged: onChanged,
          validator: validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
        ),
        SizedBox(height: 20.h),
      ],
    );
  }
}
