import 'package:baseketball_league_mobile/domain/entities/match_detail_entity.dart';
import 'package:baseketball_league_mobile/presentation/theme/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Widget hiển thị thông tin điểm số của trận đấu
class MatchScoreCard extends StatefulWidget {
  /// Thông tin chi tiết của trận đấu
  final MatchDetailEntity match;

  /// Callback khi cập nhật điểm số
  final Function(int homePoints, int awayPoints, int homeFouls, int awayFouls, int attendance) onUpdateScore;

  /// Constructor
  const MatchScoreCard({
    Key? key,
    required this.match,
    required this.onUpdateScore,
  }) : super(key: key);

  @override
  State<MatchScoreCard> createState() => _MatchScoreCardState();
}

class _MatchScoreCardState extends State<MatchScoreCard> {
  late TextEditingController _homePointsController;
  late TextEditingController _awayPointsController;
  late TextEditingController _homeFoulsController;
  late TextEditingController _awayFoulsController;
  late TextEditingController _attendanceController;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  void _initControllers() {
    _homePointsController = TextEditingController(text: '${widget.match.homePoints ?? 0}');
    _awayPointsController = TextEditingController(text: '${widget.match.awayPoints ?? 0}');
    _homeFoulsController = TextEditingController(text: '${widget.match.homeFouls ?? 0}');
    _awayFoulsController = TextEditingController(text: '${widget.match.awayFouls ?? 0}');
    _attendanceController = TextEditingController(text: '${widget.match.attendance ?? 0}');
  }

  @override
  void didUpdateWidget(MatchScoreCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.match != widget.match) {
      _initControllers();
    }
  }

  @override
  void dispose() {
    _homePointsController.dispose();
    _awayPointsController.dispose();
    _homeFoulsController.dispose();
    _awayFoulsController.dispose();
    _attendanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.sp),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tỷ số trận đấu',
                  style: AppStyle.headline5,
                ),
                IconButton(
                  icon: Icon(_isEditing ? Icons.save : Icons.edit),
                  onPressed: () {
                    if (_isEditing) {
                      // Lưu thay đổi
                      _saveChanges();
                    } else {
                      // Bắt đầu chỉnh sửa
                      setState(() {
                        _isEditing = true;
                      });
                    }
                  },
                ),
              ],
            ),
            SizedBox(height: 16.sp),
            _buildScoreSection(theme),
            SizedBox(height: 16.sp),
            _buildFoulsSection(theme),
            SizedBox(height: 16.sp),
            _buildAttendanceSection(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Điểm số',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.sp),
        Row(
          children: [
            Expanded(
              child: _buildTeamScoreColumn(
                theme,
                'Đội nhà',
                widget.match.homeTeamName ?? 'Đội nhà',
                _homePointsController,
              ),
            ),
            SizedBox(width: 16.sp),
            Text(
              '-',
              style: theme.textTheme.headlineMedium,
            ),
            SizedBox(width: 16.sp),
            Expanded(
              child: _buildTeamScoreColumn(
                theme,
                'Đội khách',
                widget.match.awayTeamName ?? 'Đội khách',
                _awayPointsController,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTeamScoreColumn(
    ThemeData theme,
    String label,
    String teamName,
    TextEditingController controller,
  ) {
    return Column(
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium,
        ),
        SizedBox(height: 4.sp),
        Text(
          teamName,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 8.sp),
        _isEditing
            ? TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.sp),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 8.sp,
                    vertical: 8.sp,
                  ),
                ),
              )
            : Text(
                controller.text,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
      ],
    );
  }

  Widget _buildFoulsSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Lỗi',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.sp),
        Row(
          children: [
            Expanded(
              child: _buildTeamFoulsColumn(
                theme,
                'Đội nhà',
                _homeFoulsController,
              ),
            ),
            SizedBox(width: 16.sp),
            Text(
              '-',
              style: theme.textTheme.headlineMedium,
            ),
            SizedBox(width: 16.sp),
            Expanded(
              child: _buildTeamFoulsColumn(
                theme,
                'Đội khách',
                _awayFoulsController,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTeamFoulsColumn(
    ThemeData theme,
    String label,
    TextEditingController controller,
  ) {
    return Column(
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium,
        ),
        SizedBox(height: 8.sp),
        _isEditing
            ? TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.sp),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 8.sp,
                    vertical: 8.sp,
                  ),
                ),
              )
            : Text(
                controller.text,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
      ],
    );
  }

  Widget _buildAttendanceSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Số người xem',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.sp),
        _isEditing
            ? TextField(
                controller: _attendanceController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.sp),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.sp,
                    vertical: 12.sp,
                  ),
                ),
              )
            : Text(
                '${_attendanceController.text} người',
                style: theme.textTheme.titleMedium,
              ),
      ],
    );
  }

  void _saveChanges() {
    // Kiểm tra dữ liệu đầu vào
    final homePoints = int.tryParse(_homePointsController.text) ?? 0;
    final awayPoints = int.tryParse(_awayPointsController.text) ?? 0;
    final homeFouls = int.tryParse(_homeFoulsController.text) ?? 0;
    final awayFouls = int.tryParse(_awayFoulsController.text) ?? 0;
    final attendance = int.tryParse(_attendanceController.text) ?? 0;

    // Gọi callback để cập nhật điểm số
    widget.onUpdateScore(
      homePoints,
      awayPoints,
      homeFouls,
      awayFouls,
      attendance,
    );

    // Tắt chế độ chỉnh sửa
    setState(() {
      _isEditing = false;
    });
  }
}
