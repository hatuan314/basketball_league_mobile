import 'dart:math';

import 'package:baseketball_league_mobile/common/injection.dart';
import 'package:baseketball_league_mobile/common/postgresql/connect_database.dart';
import 'package:baseketball_league_mobile/data/datasources/match_api.dart';
import 'package:baseketball_league_mobile/data/models/match_detail_model.dart';
import 'package:baseketball_league_mobile/data/models/match_model.dart';
import 'package:dartz/dartz.dart';
import 'package:postgres/postgres.dart';

class MatchApiImpl implements MatchApi {
  @override
  Future<Either<Exception, MatchModel>> createMatch(MatchModel match) async {
    try {
      final conn = sl.get<PostgresConnection>().conn;

      if (!conn.isOpen) {
        await sl.get<PostgresConnection>().connectDb();
      }

      final sql = '''
      INSERT INTO match(
        round_id, match_datetime, home_team_id, away_team_id, 
        home_color, away_color, attendance, home_points, 
        away_points, home_fouls, away_fouls
      ) VALUES (
        @roundId, @matchDate, @homeTeamId, @awayTeamId, 
        @homeColor, @awayColor, @attendance, @homePoints, 
        @awayPoints, @homeFouls, @awayFouls
      ) RETURNING match_id, round_id, match_datetime, home_team_id, away_team_id, 
                 home_color, away_color, attendance, home_points, 
                 away_points, home_fouls, away_fouls;
      ''';

      final params = {
        'roundId': match.roundId,
        'matchDate': match.matchDate,
        'homeTeamId': match.homeTeamId,
        'awayTeamId': match.awayTeamId,
        'homeColor': match.homeColor,
        'awayColor': match.awayColor,
        'attendance': match.attendance ?? 0,
        'homePoints': match.homePoints ?? 0,
        'awayPoints': match.awayPoints ?? 0,
        'homeFouls': match.homeFouls ?? 0,
        'awayFouls': match.awayFouls ?? 0,
      };

      final result = await conn.execute(Sql.named(sql), parameters: params);

      if (result.isNotEmpty) {
        return Right(MatchModel.fromPostgres(result[0]));
      } else {
        return Left(Exception('Không thể tạo trận đấu'));
      }
    } catch (e) {
      print('Lỗi khi tạo trận đấu: $e');
      return Left(Exception('Lỗi khi tạo trận đấu: $e'));
    }
  }

  @override
  Future<Either<Exception, bool>> deleteMatch(int id) async {
    try {
      final conn = sl.get<PostgresConnection>().conn;

      if (!conn.isOpen) {
        await sl.get<PostgresConnection>().connectDb();
      }

      final sql = 'DELETE FROM match WHERE match_id = @id';
      final params = {'id': id};

      final result = await conn.execute(Sql.named(sql), parameters: params);

      if (result.affectedRows > 0) {
        return const Right(true);
      } else {
        return Left(Exception('Không tìm thấy trận đấu với ID: $id'));
      }
    } catch (e) {
      print('Lỗi khi xóa trận đấu: $e');
      return Left(Exception('Lỗi khi xóa trận đấu: $e'));
    }
  }

  @override
  Future<Either<Exception, List<MatchModel>>> generateMatches(
    int roundId,
  ) async {
    try {
      final conn = sl.get<PostgresConnection>().conn;

      if (!conn.isOpen) {
        await sl.get<PostgresConnection>().connectDb();
      }

      // Lấy thông tin về vòng đấu
      final roundSql = 'SELECT season_id FROM round WHERE round_id = @roundId';
      final roundParams = {'roundId': roundId};
      final roundResult = await conn.execute(
        Sql.named(roundSql),
        parameters: roundParams,
      );

      if (roundResult.isEmpty) {
        return Left(Exception('Không tìm thấy vòng đấu với ID: $roundId'));
      }

      final seasonId = roundResult[0][0] as int;

      // Lấy danh sách đội trong mùa giải
      final teamsSql = '''
      SELECT st.season_team_id,
            tc.color_name
      FROM season_team st
      JOIN team t ON st.team_id = t.team_id
              JOIN team_color tc ON st.season_id = tc.season_id AND st.team_id = tc.team_id
      WHERE st.season_id = @seasonId
      ''';

      final teamsParams = {'seasonId': seasonId};
      final teamsResult = await conn.execute(
        Sql.named(teamsSql),
        parameters: teamsParams,
      );

      if (teamsResult.isEmpty) {
        return Left(Exception('Không có đội nào trong mùa giải'));
      }

      // Tạo map để gộp các team có cùng teamId
      final teamMap = <int, Map<String, dynamic>>{};

      for (final row in teamsResult) {
        final seasonTeamId = row[0] as int;
        // Biến teamId có thể được sử dụng trong tương lai nếu cần phân biệt các đội
        // final teamId = row[1] as int;
        final colorName = row[1] as String;

        if (!teamMap.containsKey(seasonTeamId)) {
          teamMap[seasonTeamId] = {'id': seasonTeamId, 'colors': <String>[]};
        }

        // Thêm màu vào danh sách màu của team
        final colors = teamMap[seasonTeamId]!['colors'] as List<String>;
        if (!colors.contains(colorName)) {
          colors.add(colorName);
        }
      }

      // Chuyển map thành list
      final teams = teamMap.values.toList();

      // Lấy thông tin về thời gian của vòng đấu
      final roundDateSql =
          'SELECT start_date, end_date FROM round WHERE round_id = @roundId';
      final roundDateParams = {'roundId': roundId};
      final roundDateResult = await conn.execute(
        Sql.named(roundDateSql),
        parameters: roundDateParams,
      );

      final startDate = roundDateResult[0][0] as DateTime;
      final endDate = roundDateResult[0][1] as DateTime;

      // Tạo các trận đấu
      final matches = <MatchModel>[];
      final createdMatches = <MatchModel>[];

      // Tạo các cặp đấu (mỗi đội sẽ đấu với tất cả các đội khác)
      for (int i = 0; i < teams.length; i++) {
        for (int j = i + 1; j < teams.length; j++) {
          final homeTeam = teams[i];
          final awayTeam = teams[j];

          // Tính toán thời gian trận đấu (phân bố đều trong khoảng thời gian của vòng đấu)
          final matchDate = startDate.add(
            Duration(
              hours:
                  ((i * teams.length + j) *
                          (endDate.difference(startDate).inHours /
                              (teams.length * (teams.length - 1) / 2)))
                      .round(),
            ),
          );

          // Lấy ngẫu nhiên một màu từ danh sách màu của mỗi đội
          final homeColors = homeTeam['colors'] as List<String>;
          final awayColors = awayTeam['colors'] as List<String>;

          // Đảm bảo màu của hai đội không trùng nhau
          String homeColor = homeColors[0];
          String awayColor = awayColors[0];

          if (awayColors.length > 1) {
            // Tìm màu khác cho đội khách nếu trùng với đội nhà
            do {
              int index = Random().nextInt(awayColors.length - 1);
              awayColor = awayColors[index];
            } while (awayColor == homeColor);
          }

          final match = MatchModel(
            roundId: roundId,
            matchDate: matchDate,
            homeTeamId: homeTeam['id'],
            awayTeamId: awayTeam['id'],
            homeColor: homeColor,
            awayColor: awayColor,
            attendance: 0,
            homePoints: 0,
            awayPoints: 0,
            homeFouls: 0,
            awayFouls: 0,
          );

          matches.add(match);
        }
      }

      // Lưu các trận đấu vào database
      for (final match in matches) {
        final result = await createMatch(match);
        result.fold(
          (error) => print('Lỗi khi tạo trận đấu: $error'),
          (createdMatch) => createdMatches.add(createdMatch),
        );
      }

      return Right(createdMatches);
    } catch (e) {
      print('Lỗi khi tạo các trận đấu: $e');
      return Left(Exception('Lỗi khi tạo các trận đấu: $e'));
    }
  }

  @override
  Future<Either<Exception, MatchModel>> getMatchById(int id) async {
    try {
      final conn = sl.get<PostgresConnection>().conn;

      if (!conn.isOpen) {
        await sl.get<PostgresConnection>().connectDb();
      }

      final sql = '''
      SELECT match_id, round_id, match_datetime, home_team_id, away_team_id, 
             home_color, away_color, attendance, home_points, 
             away_points, home_fouls, away_fouls 
      FROM match 
      WHERE match_id = @id
      ''';

      final params = {'id': id};
      final result = await conn.execute(Sql.named(sql), parameters: params);

      if (result.isNotEmpty) {
        return Right(MatchModel.fromPostgres(result[0]));
      } else {
        return Left(Exception('Không tìm thấy trận đấu với ID: $id'));
      }
    } catch (e) {
      print('Lỗi khi lấy thông tin trận đấu: $e');
      return Left(Exception('Lỗi khi lấy thông tin trận đấu: $e'));
    }
  }

  @override
  Future<Either<Exception, List<MatchModel>>> getMatches({int? roundId}) async {
    try {
      final conn = sl.get<PostgresConnection>().conn;

      if (!conn.isOpen) {
        await sl.get<PostgresConnection>().connectDb();
      }

      String sql = '''
      SELECT match_id, round_id, match_datetime, home_team_id, away_team_id, 
             home_color, away_color, attendance, home_points, 
             away_points, home_fouls, away_fouls 
      FROM match 
      ''';

      final params = <String, dynamic>{};

      if (roundId != null) {
        sql += 'WHERE round_id = @roundId ';
        params['roundId'] = roundId;
      }

      sql += 'ORDER BY match_datetime';

      final result = await conn.execute(Sql.named(sql), parameters: params);

      final matches = <MatchModel>[];
      for (final row in result) {
        matches.add(MatchModel.fromPostgres(row));
      }

      return Right(matches);
    } catch (e) {
      print('Lỗi khi lấy danh sách trận đấu: $e');
      return Left(Exception('Lỗi khi lấy danh sách trận đấu: $e'));
    }
  }

  @override
  Future<Either<Exception, MatchModel>> updateMatch(MatchModel match) async {
    try {
      final conn = sl.get<PostgresConnection>().conn;

      if (!conn.isOpen) {
        await sl.get<PostgresConnection>().connectDb();
      }

      if (match.id == null) {
        return Left(Exception('ID trận đấu không được để trống'));
      }

      final sql = '''
      UPDATE match SET 
        round_id = @roundId, 
        match_datetime = @matchDate, 
        home_team_id = @homeTeamId, 
        away_team_id = @awayTeamId, 
        home_color = @homeColor, 
        away_color = @awayColor, 
        attendance = @attendance, 
        home_points = @homePoints, 
        away_points = @awayPoints, 
        home_fouls = @homeFouls, 
        away_fouls = @awayFouls 
      WHERE match_id = @id 
      RETURNING match_id, round_id, match_datetime, home_team_id, away_team_id, 
               home_color, away_color, attendance, home_points, 
               away_points, home_fouls, away_fouls;
      ''';

      final params = {
        'id': match.id,
        'roundId': match.roundId,
        'matchDate': match.matchDate,
        'homeTeamId': match.homeTeamId,
        'awayTeamId': match.awayTeamId,
        'homeColor': match.homeColor,
        'awayColor': match.awayColor,
        'attendance': match.attendance ?? 0,
        'homePoints': match.homePoints ?? 0,
        'awayPoints': match.awayPoints ?? 0,
        'homeFouls': match.homeFouls ?? 0,
        'awayFouls': match.awayFouls ?? 0,
      };

      final result = await conn.execute(Sql.named(sql), parameters: params);

      if (result.isNotEmpty) {
        return Right(MatchModel.fromPostgres(result[0]));
      } else {
        return Left(Exception('Không tìm thấy trận đấu với ID: ${match.id}'));
      }
    } catch (e) {
      print('Lỗi khi cập nhật trận đấu: $e');
      return Left(Exception('Lỗi khi cập nhật trận đấu: $e'));
    }
  }

  @override
  Future<Either<Exception, List<MatchDetailModel>>> getMatchDetailByRoundId(
    int roundId, {
    int? matchId,
  }) async {
    try {
      final conn = sl.get<PostgresConnection>().conn;

      if (!conn.isOpen) {
        await sl.get<PostgresConnection>().connectDb();
      }

      // Sử dụng view match_details đã được tạo trong database
      final sql = '''
      SELECT 
          match_id, match_datetime, round_id, round_no, season_id, season_name,
          home_team_id, away_team_id, home_team_name, away_team_name,
          home_color, away_color, home_points, away_points, home_fouls, away_fouls,
          attendance, stadium_id, stadium_name, ticket_price, winner_team_id, winner_team_name
      FROM 
          match_details
      WHERE 
          round_id = @roundId
          ${matchId != null ? 'AND match_id = @matchId' : ''}
      ORDER BY 
          match_datetime
      ''';

      final params = {'roundId': roundId};
      if (matchId != null) {
        params['matchId'] = matchId;
      }
      final result = await conn.execute(Sql.named(sql), parameters: params);

      if (result.isEmpty) {
        return const Right([]);
      }

      final matches = <MatchDetailModel>[];
      for (final row in result) {
        matches.add(MatchDetailModel.fromRow(row));
      }

      return Right(matches);
    } catch (e) {
      print('Lỗi khi lấy chi tiết trận đấu theo vòng đấu: $e');
      return Left(Exception('Lỗi khi lấy chi tiết trận đấu theo vòng đấu: $e'));
    }
  }
}
