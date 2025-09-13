import 'dart:math';

import 'package:baseketball_league_mobile/common/injection.dart';
import 'package:baseketball_league_mobile/common/postgresql/connect_database.dart';
import 'package:baseketball_league_mobile/data/datasources/match_api.dart';
import 'package:baseketball_league_mobile/data/models/match/match_detail_model.dart';
import 'package:baseketball_league_mobile/data/models/match/match_model.dart';
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
        'homeTeamId': match.homeSeasonTeamId,
        'awayTeamId': match.awaySeasonTeamId,
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
      final roundSql = '''
      SELECT r.season_id, r.round_no, r.start_date, r.end_date 
      FROM round r 
      WHERE r.round_id = @roundId
      ''';
      final roundParams = {'roundId': roundId};
      final roundResult = await conn.execute(
        Sql.named(roundSql),
        parameters: roundParams,
      );

      if (roundResult.isEmpty) {
        return Left(Exception('Không tìm thấy vòng đấu với ID: $roundId'));
      }

      final seasonId = roundResult[0][0] as int;
      final roundNo = roundResult[0][1] as int;
      final startDate = roundResult[0][2] as DateTime;
      final endDate = roundResult[0][3] as DateTime;

      // Lấy danh sách đội trong mùa giải
      final teamsSql = '''
      SELECT st.season_team_id, t.team_id, t.team_name, tc.color_name
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

      // Tạo map để gộp các team có cùng seasonTeamId
      final teamMap = <int, Map<String, dynamic>>{};

      for (final row in teamsResult) {
        final seasonTeamId = row[0] as int;
        final teamId = row[1] as int;
        final teamName = row[2] as String;
        final colorName = row[3] as String;

        if (!teamMap.containsKey(seasonTeamId)) {
          teamMap[seasonTeamId] = {
            'seasonTeamId': seasonTeamId,
            'teamId': teamId,
            'teamName': teamName,
            'colors': <String>[],
          };
        }

        // Thêm màu vào danh sách màu của team
        final colors = teamMap[seasonTeamId]!['colors'] as List<String>;
        if (!colors.contains(colorName)) {
          colors.add(colorName);
        }
      }

      // Chuyển map thành list
      final teams = teamMap.values.toList();

      // Kiểm tra số lượng đội
      if (teams.length < 2) {
        return Left(Exception('Cần ít nhất 2 đội để tạo trận đấu'));
      }

      // Lấy thông tin về các trận đấu đã tạo trong mùa giải
      final existingMatchesSql = '''
      SELECT m.home_team_id, m.away_team_id
      FROM match m
      JOIN round r ON m.round_id = r.round_id
      WHERE r.season_id = @seasonId
      ''';

      final existingMatchesParams = {'seasonId': seasonId};
      final existingMatchesResult = await conn.execute(
        Sql.named(existingMatchesSql),
        parameters: existingMatchesParams,
      );

      // Tạo map để đếm số trận đã đấu giữa các cặp đội
      final matchCountMap = <String, int>{};

      for (final row in existingMatchesResult) {
        final homeTeamId = row[0] as int;
        final awayTeamId = row[1] as int;

        // Tạo key cho cặp đội (không phân biệt sân nhà/sân khách)
        final key1 = '$homeTeamId-$awayTeamId';
        final key2 = '$awayTeamId-$homeTeamId';

        if (matchCountMap.containsKey(key1)) {
          matchCountMap[key1] = matchCountMap[key1]! + 1;
        } else if (matchCountMap.containsKey(key2)) {
          matchCountMap[key2] = matchCountMap[key2]! + 1;
        } else {
          matchCountMap[key1] = 1;
        }
      }

      // Kiểm tra các đội đã thi đấu trong vòng đấu hiện tại
      final teamsInCurrentRoundSql = '''
      SELECT m.home_team_id, m.away_team_id
      FROM match m
      WHERE m.round_id = @roundId
      ''';

      final teamsInCurrentRoundParams = {'roundId': roundId};
      final teamsInCurrentRoundResult = await conn.execute(
        Sql.named(teamsInCurrentRoundSql),
        parameters: teamsInCurrentRoundParams,
      );

      // Tạo set để lưu các đội đã thi đấu trong vòng đấu hiện tại
      final teamsInCurrentRound = <int>{};

      for (final row in teamsInCurrentRoundResult) {
        teamsInCurrentRound.add(row[0] as int);
        teamsInCurrentRound.add(row[1] as int);
      }

      // Tạo các trận đấu
      final matches = <MatchModel>[];
      final createdMatches = <MatchModel>[];

      // Danh sách các đội chưa thi đấu trong vòng đấu hiện tại
      final availableTeams =
          teams
              .where(
                (team) => !teamsInCurrentRound.contains(team['seasonTeamId']),
              )
              .toList();

      // Sắp xếp ngẫu nhiên để tạo các cặp đấu
      availableTeams.shuffle(Random());

      // Tạo các cặp đấu cho vòng đấu hiện tại
      for (int i = 0; i < availableTeams.length - 1; i += 2) {
        if (i + 1 >= availableTeams.length) break;

        final homeTeam = availableTeams[i];
        final awayTeam = availableTeams[i + 1];

        final homeTeamId = homeTeam['seasonTeamId'] as int;
        final awayTeamId = awayTeam['seasonTeamId'] as int;

        // Kiểm tra số trận đã đấu giữa hai đội
        final key1 = '$homeTeamId-$awayTeamId';
        final key2 = '$awayTeamId-$homeTeamId';
        final matchCount = matchCountMap[key1] ?? matchCountMap[key2] ?? 0;

        // Nếu đã đấu đủ 4 trận, bỏ qua cặp đấu này
        if (matchCount >= 4) continue;

        // Tính toán thời gian trận đấu (phân bố đều trong khoảng thời gian của vòng đấu)
        final matchDate = startDate.add(
          Duration(
            hours:
                (i /
                        2 *
                        (endDate.difference(startDate).inHours /
                            (availableTeams.length / 2)))
                    .round(),
          ),
        );

        // Lấy ngẫu nhiên một màu từ danh sách màu của mỗi đội
        final homeColors = homeTeam['colors'] as List<String>;
        final awayColors = awayTeam['colors'] as List<String>;

        // Đảm bảo màu của hai đội không trùng nhau
        String homeColor = homeColors.isNotEmpty ? homeColors[0] : 'white';
        String awayColor = awayColors.isNotEmpty ? awayColors[0] : 'black';

        if (homeColors.isNotEmpty &&
            awayColors.length > 1 &&
            homeColor == awayColor) {
          // Tìm màu khác cho đội khách nếu trùng với đội nhà
          for (final color in awayColors) {
            if (color != homeColor) {
              awayColor = color;
              break;
            }
          }
        }

        final match = MatchModel(
          roundId: roundId,
          matchDate: matchDate,
          homeSeasonTeamId: homeTeamId,
          awaySeasonTeamId: awayTeamId,
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
        'homeTeamId': match.homeSeasonTeamId,
        'awayTeamId': match.awaySeasonTeamId,
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

  @override
  Future<Either<Exception, MatchModel>> updateMatchScore({
    required int matchId,
    required int homeScore,
    required int awayScore,
    int? homeFouls,
    int? awayFouls,
    int? attendance,
  }) async {
    try {
      final conn = sl.get<PostgresConnection>().conn;

      if (!conn.isOpen) {
        await sl.get<PostgresConnection>().connectDb();
      }

      // Kiểm tra trận đấu tồn tại
      final checkSql =
          'SELECT match_id, home_fouls, away_fouls FROM match WHERE match_id = @matchId';
      final checkParams = {'matchId': matchId};
      final checkResult = await conn.execute(
        Sql.named(checkSql),
        parameters: checkParams,
      );

      if (checkResult.isEmpty) {
        return Left(Exception('Không tìm thấy trận đấu với ID: $matchId'));
      }

      // Lấy số lỗi hiện tại nếu không được cung cấp
      final currentHomeFouls = checkResult[0][1] as int?;
      final currentAwayFouls = checkResult[0][2] as int?;

      // Sử dụng giá trị hiện tại nếu không được cung cấp giá trị mới
      final updatedHomeFouls = homeFouls ?? currentHomeFouls ?? 0;
      final updatedAwayFouls = awayFouls ?? currentAwayFouls ?? 0;

      // Kiểm tra điểm số hợp lệ (không âm)
      if (homeScore < 0 || awayScore < 0) {
        return Left(Exception('Điểm số không được âm'));
      }

      // Kiểm tra số lỗi hợp lệ (không âm)
      if (updatedHomeFouls < 0 || updatedAwayFouls < 0) {
        return Left(Exception('Số lỗi không được âm'));
      }

      // Kiểm tra không được hòa (điểm số phải khác nhau)
      if (homeScore == awayScore) {
        return Left(
          Exception('Kết quả trận đấu không được hòa, điểm số phải khác nhau'),
        );
      }

      // Cập nhật điểm số, số lỗi và số lượng người xem
      final sql =
          attendance != null
              ? '''
      UPDATE match 
      SET 
        home_points = @homeScore, 
        away_points = @awayScore,
        home_fouls = @homeFouls,
        away_fouls = @awayFouls,
        attendance = @attendance
      WHERE match_id = @matchId 
      RETURNING match_id, round_id, match_datetime, home_team_id, away_team_id, 
               home_color, away_color, attendance, home_points, 
               away_points, home_fouls, away_fouls;
      '''
              : '''
      UPDATE match 
      SET 
        home_points = @homeScore, 
        away_points = @awayScore,
        home_fouls = @homeFouls,
        away_fouls = @awayFouls
      WHERE match_id = @matchId 
      RETURNING match_id, round_id, match_datetime, home_team_id, away_team_id, 
               home_color, away_color, attendance, home_points, 
               away_points, home_fouls, away_fouls;
      ''';

      // Kiểm tra số lượng người xem hợp lệ (không âm) nếu được cung cấp
      if (attendance != null && attendance < 0) {
        return Left(Exception('Số lượng người xem không được âm'));
      }

      final params = {
        'matchId': matchId,
        'homeScore': homeScore,
        'awayScore': awayScore,
        'homeFouls': updatedHomeFouls,
        'awayFouls': updatedAwayFouls,
        'attendance': attendance,
      };

      final result = await conn.execute(Sql.named(sql), parameters: params);

      if (result.isNotEmpty) {
        return Right(MatchModel.fromPostgres(result[0]));
      } else {
        return Left(Exception('Không thể cập nhật tỉ số và số lỗi trận đấu'));
      }
    } catch (e) {
      print('Lỗi khi cập nhật tỉ số và số lỗi trận đấu: $e');
      return Left(Exception('Lỗi khi cập nhật tỉ số và số lỗi trận đấu: $e'));
    }
  }
}
