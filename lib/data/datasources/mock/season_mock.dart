import 'dart:math';

import 'package:baseketball_league_mobile/data/models/season_model.dart';

// Danh sách các giải đấu ngẫu nhiên
final List<SeasonModel> mockSeasonList = createRandomSeasons(5);

/// Tạo danh sách giải đấu ngẫu nhiên
List<SeasonModel> createRandomSeasons(int count) {
  final random = Random();
  final List<SeasonModel> seasons = [];
  final currentYear = DateTime.now().year;

  final List<String> seasonNames = [
    'Giải Bóng Rổ Quốc Gia',
    'Giải Vô Địch Bóng Rổ',
    'Giải Bóng Rổ Đại Học',
    'Giải Bóng Rổ Trẻ',
    'Giải Bóng Rổ Liên Lục Địa',
    'Giải Bóng Rổ Mở Rộng',
    'Giải Bóng Rổ Liên Đoàn',
    'Giải Bóng Rổ Cúp Quốc Gia',
  ];

  for (int i = 0; i < count; i++) {
    // Tạo năm ngẫu nhiên trong khoảng 3 năm gần đây
    final year = currentYear - random.nextInt(3);

    // Tạo tháng bắt đầu ngẫu nhiên
    final startMonth = 1 + random.nextInt(6); // Tháng 1-6

    // Tạo ngày bắt đầu ngẫu nhiên
    final startDay = 1 + random.nextInt(28); // Ngày 1-28

    // Tạo ngày kết thúc (3-6 tháng sau ngày bắt đầu)
    final durationMonths = 3 + random.nextInt(4); // 3-6 tháng

    final startDate = DateTime(year, startMonth, startDay);
    final endDate = DateTime(year, startMonth + durationMonths, startDay);

    // Chọn tên giải đấu ngẫu nhiên
    final nameIndex = random.nextInt(seasonNames.length);
    final seasonName = '${seasonNames[nameIndex]} ${year}';

    // Tạo mã giải đấu
    final seasonCode =
        'S${year.toString().substring(2)}${(i + 1).toString().padLeft(3, '0')}';

    seasons.add(
      SeasonModel(
        id: i + 1,
        code: seasonCode,
        name: seasonName,
        startDate: startDate,
        endDate: endDate,
      ),
    );
  }

  return seasons;
}

/// Lấy danh sách giải đấu ngẫu nhiên
List<SeasonModel> getRandomSeasons() {
  return mockSeasonList;
}
