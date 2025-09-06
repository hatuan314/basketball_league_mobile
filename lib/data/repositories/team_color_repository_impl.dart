import 'dart:math';

import 'package:baseketball_league_mobile/common/constants/available_colors.dart';
import 'package:baseketball_league_mobile/data/datasources/team_color_api.dart';
import 'package:baseketball_league_mobile/data/models/team_color_model.dart';
import 'package:baseketball_league_mobile/domain/entities/team_color_entity.dart';
import 'package:baseketball_league_mobile/domain/repositories/team_color_repository.dart';
import 'package:dartz/dartz.dart';

class TeamColorRepositoryImpl implements TeamColorRepository {
  final TeamColorApi _teamColorApi;

  TeamColorRepositoryImpl({required TeamColorApi teamColorApi})
    : _teamColorApi = teamColorApi;

  @override
  Future<Either<Exception, TeamColorEntity>> createTeamColor(
    TeamColorEntity teamColor,
  ) async {
    try {
      // Chuyển đổi entity thành model
      final teamColorModel = TeamColorModel.fromEntity(teamColor);

      // Gọi API để tạo áo đấu
      final result = await _teamColorApi.createTeamColor(teamColorModel);

      // Xử lý kết quả
      return result.fold(
        (exception) => Left(exception),
        (model) => Right(model.toEntity()),
      );
    } catch (e) {
      return Left(Exception('Lỗi khi tạo áo đấu: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Exception, Unit>> deleteTeamColor(int seasonTeamId) async {
    try {
      // Gọi API để xóa áo đấu
      final result = await _teamColorApi.deleteTeamColor(seasonTeamId);

      // Xử lý kết quả
      return result.fold((exception) => Left(exception), (unit) => Right(unit));
    } catch (e) {
      return Left(Exception('Lỗi khi xóa áo đấu: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Exception, List<TeamColorEntity>>> getTeamColors({
    required int seasonId,
    int? teamId,
  }) async {
    try {
      // Gọi API để lấy danh sách áo đấu
      final result = await _teamColorApi.getTeamColors(
        seasonId: seasonId,
        teamId: teamId,
      );

      // Xử lý kết quả
      return result.fold((exception) => Left(exception), (models) {
        // Chuyển đổi danh sách model thành danh sách entity
        final entities = models.map((model) => model.toEntity()).toList();
        return Right(entities);
      });
    } catch (e) {
      return Left(Exception('Lỗi khi lấy danh sách áo đấu: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Exception, TeamColorEntity>> updateTeamColor(
    TeamColorEntity teamColor,
  ) async {
    try {
      // Chuyển đổi entity thành model
      final teamColorModel = TeamColorModel(
        teamId: teamColor.teamId,
        seasonId: teamColor.seasonId,
        colorName: teamColor.colorName,
      );

      // Gọi API để cập nhật áo đấu
      final result = await _teamColorApi.updateTeamColor(teamColorModel);

      // Xử lý kết quả
      return result.fold(
        (exception) => Left(exception),
        (model) => Right(model.toEntity()),
      );
    } catch (e) {
      return Left(Exception('Lỗi khi cập nhật áo đấu: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Exception, List<TeamColorEntity>>> generateUniqueTeamColors({
    required int seasonId,
    required List<int> teamIds,
    int colorsPerTeam = 3,
  }) async {
    try {
      // Lấy danh sách áo đấu hiện có của mùa giải
      final existingColorsResult = await getTeamColors(seasonId: seasonId);

      // Xử lý kết quả
      return existingColorsResult.fold((exception) => Left(exception), (
        existingColors,
      ) async {
        // Nhóm các áo đấu hiện có theo đội
        final Map<int, List<TeamColorEntity>> existingColorsByTeam = {};
        for (var color in existingColors) {
          if (color.teamId != null) {
            if (!existingColorsByTeam.containsKey(color.teamId)) {
              existingColorsByTeam[color.teamId!] = [];
            }
            existingColorsByTeam[color.teamId!]!.add(color);
          }
        }

        // Lấy danh sách màu đã được sử dụng
        final usedColorNames =
            existingColors
                .map((color) => color.colorName)
                .whereType<String>()
                .toSet();

        // Lọc ra các màu chưa được sử dụng
        final unusedColors =
            availableColors
                .where((color) => !usedColorNames.contains(color))
                .toList();

        // Xáo trộn danh sách màu để tạo sự ngẫu nhiên
        unusedColors.shuffle(Random());

        // Danh sách kết quả
        final List<TeamColorEntity> createdColors = [];
        int unusedColorIndex = 0;

        // Tạo áo đấu cho từng đội
        for (int teamId in teamIds) {
          // Kiểm tra xem đội đã có áo đấu chưa và có đủ số lượng chưa
          final existingTeamColors = existingColorsByTeam[teamId] ?? [];

          // Thêm các áo đấu hiện có vào danh sách kết quả
          createdColors.addAll(existingTeamColors);

          // Tính số áo đấu cần thêm mới
          final colorsToAdd = colorsPerTeam - existingTeamColors.length;

          // Nếu cần thêm áo đấu mới
          if (colorsToAdd > 0) {
            // Kiểm tra xem có đủ màu khả dụng không
            if (unusedColorIndex + colorsToAdd > unusedColors.length) {
              return Left(
                Exception('Không đủ màu sắc khả dụng cho tất cả các đội'),
              );
            }

            // Tạo các áo đấu mới cho đội
            for (int i = 0; i < colorsToAdd; i++) {
              // Tạo áo đấu mới với màu chưa được sử dụng
              final newTeamColor = TeamColorEntity(
                teamId: teamId,
                seasonId: seasonId,
                colorName: unusedColors[unusedColorIndex++],
              );

              // Gọi API để tạo áo đấu
              final createResult = await createTeamColor(newTeamColor);

              // Xử lý kết quả
              final createdColor = createResult.fold((exception) {
                print(
                  "Lỗi khi tạo áo đấu cho đội $teamId: ${exception.toString()}",
                );
              }, (entity) => entity);

              // Nếu tạo thành công, thêm vào danh sách kết quả
              if (createdColor != null) {
                createdColors.add(createdColor);
              } else {
                return Left(Exception('Lỗi khi tạo áo đấu cho đội $teamId'));
              }
            }
          }
        }

        return Right(createdColors);
      });
    } catch (e) {
      return Left(Exception('Lỗi khi tạo áo đấu tự động: ${e.toString()}'));
    }
  }
}
