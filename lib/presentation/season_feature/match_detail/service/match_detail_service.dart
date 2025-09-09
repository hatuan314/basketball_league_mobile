import 'dart:math';

import 'package:baseketball_league_mobile/domain/entities/match_detail_entity.dart';
import 'package:baseketball_league_mobile/domain/entities/match_entity.dart';
import 'package:baseketball_league_mobile/domain/entities/match_player_detail_entity.dart';
import 'package:baseketball_league_mobile/domain/entities/match_player_entity.dart';
import 'package:baseketball_league_mobile/domain/entities/match_player_stats_entity.dart';
import 'package:baseketball_league_mobile/domain/entities/match_referee_detail_entity.dart';
import 'package:baseketball_league_mobile/domain/repositories/match_repository.dart';
import 'package:baseketball_league_mobile/domain/usecases/match_player_stats_usecase.dart';
import 'package:baseketball_league_mobile/domain/usecases/match_referee_usecase.dart';
import 'package:baseketball_league_mobile/domain/usecases/match_usecase.dart';
import 'package:baseketball_league_mobile/domain/usecases/player_match_usecase.dart';
import 'package:baseketball_league_mobile/domain/usecases/stadium_usecase.dart';
import 'package:dartz/dartz.dart';

/// Service để xử lý logic liên quan đến chi tiết trận đấu
class MatchDetailService {
  /// UseCase và Repository để quản lý trận đấu
  final MatchUseCase _matchUseCase;
  final MatchRefereeUseCase _matchRefereeUseCase;
  final PlayerMatchUseCase _playerMatchUseCase;
  final MatchRepository _matchRepository;
  final StadiumUseCase _stadiumUseCase;
  final MatchPlayerStatsUseCase _matchPlayerStatsUseCase;

  /// Constructor
  MatchDetailService({
    required MatchUseCase matchUseCase,
    required MatchRefereeUseCase matchRefereeUseCase,
    required PlayerMatchUseCase playerMatchUseCase,
    required MatchRepository matchRepository,
    required StadiumUseCase stadiumUseCase,
    required MatchPlayerStatsUseCase matchPlayerStatsUseCase,
  }) : _matchUseCase = matchUseCase,
       _matchRefereeUseCase = matchRefereeUseCase,
       _playerMatchUseCase = playerMatchUseCase,
       _matchRepository = matchRepository,
       _stadiumUseCase = stadiumUseCase,
       _matchPlayerStatsUseCase = matchPlayerStatsUseCase;

  /// Lấy thông tin trận đấu theo ID
  Future<Either<Exception, MatchEntity>> getMatchById(int matchId) async {
    try {
      return await _matchUseCase.getMatchById(matchId);
    } catch (e) {
      return Left(Exception('Lỗi khi tải thông tin trận đấu: $e'));
    }
  }

  /// Lấy thông tin chi tiết của trận đấu
  Future<Either<Exception, MatchDetailEntity>> getMatchDetail(
    int matchId,
    int roundId,
  ) async {
    try {
      final result = await _matchUseCase.getMatchDetailByRoundId(
        roundId,
        matchId: matchId,
      );

      return result.fold((error) => Left(error), (matches) {
        if (matches.isEmpty) {
          return Left(Exception('Không tìm thấy thông tin trận đấu'));
        }
        return Right(matches.first);
      });
    } catch (e) {
      return Left(Exception('Lỗi khi tải thông tin trận đấu: $e'));
    }
  }

  /// Lấy danh sách trọng tài của trận đấu
  Future<Either<Exception, List<MatchRefereeDetailEntity>>> getMatchReferees(
    int matchId,
  ) async {
    try {
      return await _matchRefereeUseCase.getMatchRefereeDetailsByMatchId(
        matchId,
      );
    } catch (e) {
      return Left(Exception('Lỗi khi tải thông tin trọng tài: $e'));
    }
  }

  /// Lấy danh sách cầu thủ của đội trong trận đấu
  Future<Either<Exception, List<MatchPlayerDetailEntity>>>
  getTeamPlayerDetailsInMatch(int matchId, int teamId) async {
    try {
      return await _playerMatchUseCase.getTeamPlayersDetailInMatch(
        matchId,
        teamId,
      );
    } catch (e) {
      return Left(
        Exception('Lỗi khi tải thông tin cầu thủ trong trận đấu: $e'),
      );
    }
  }

  /// Cập nhật điểm số và số lỗi của trận đấu
  Future<Either<Exception, MatchEntity>> updateMatchScore({
    required int matchId,
    required int homeScore,
    required int awayScore,
    int? homeFouls,
    int? awayFouls,
  }) async {
    try {
      return await _matchRepository.updateMatchScore(
        matchId: matchId,
        homeScore: homeScore,
        awayScore: awayScore,
        homeFouls: homeFouls,
        awayFouls: awayFouls,
      );
    } catch (e) {
      return Left(Exception('Lỗi khi cập nhật tỉ số trận đấu: $e'));
    }
  }

  /// Tự động phân công trọng tài cho trận đấu
  Future<Either<Exception, List<dynamic>>> generateMatchReferees({
    required int roundId,
    required int matchId,
  }) async {
    try {
      final result = await _matchRefereeUseCase.generateMatchReferees(
        roundId: roundId,
        matchId: matchId,
      );
      return result.fold(
        (error) => Left(error),
        (data) => Right(data as List<dynamic>),
      );
    } catch (e) {
      return Left(Exception('Lỗi khi phân công trọng tài: $e'));
    }
  }

  /// Xóa trọng tài khỏi trận đấu
  Future<Either<Exception, bool>> deleteMatchReferee(String id) async {
    try {
      return await _matchRefereeUseCase.deleteMatchReferee(id);
    } catch (e) {
      return Left(Exception('Lỗi khi xóa trọng tài: $e'));
    }
  }

  /// Tự động thêm cầu thủ vào trận đấu
  Future<Either<Exception, List<dynamic>>> autoRegisterPlayersForMatch(
    int matchId,
    int teamId,
  ) async {
    try {
      final result = await _playerMatchUseCase.autoRegisterPlayersForMatch(
        matchId,
        teamId,
      );
      return result.fold(
        (error) => Left(error),
        (data) => Right(data as List<dynamic>),
      );
    } catch (e) {
      return Left(Exception('Lỗi khi tự động thêm cầu thủ: $e'));
    }
  }

  /// Giả lập tỉ số và số lỗi cho trận đấu
  /// Sử dụng sức chứa của sân vận động làm giá trị maxAttendance
  Future<Either<Exception, MatchEntity>> simulateMatchScore({
    required int matchId,
    required List<MatchPlayerStatsEntity> homePlayerStats,
    required List<MatchPlayerStatsEntity> awayPlayerStats,
    int minAttendance = 1000,
  }) async {
    try {
      int homeTotalPoints = 0;
      int homeTotalFouls = 0;
      for (final stats in homePlayerStats) {
        homeTotalPoints += stats.points ?? 0;
        homeTotalFouls += stats.fouls ?? 0;
      }

      int awayTotalPoints = 0;
      int awayTotalFouls = 0;
      for (final stats in awayPlayerStats) {
        awayTotalPoints += stats.points ?? 0;
        awayTotalFouls += stats.fouls ?? 0;
      }

      // Lấy thông tin chi tiết trận đấu để biết sân vận động
      // Cần biết roundId để gọi getMatchDetail
      final matchBasicResult = await _matchUseCase.getMatchById(matchId);

      return await matchBasicResult.fold((error) => Left(error), (match) async {
        final roundId = match.roundId;
        if (roundId == null) {
          return Left(
            Exception('Không tìm thấy thông tin vòng đấu của trận đấu'),
          );
        }

        // Lấy thông tin chi tiết trận đấu để có thông tin sân vận động
        final matchDetailResult = await getMatchDetail(matchId, roundId);

        return await matchDetailResult.fold((error) => Left(error), (
          matchDetail,
        ) async {
          // Lấy thông tin sân vận động
          final stadiumId = matchDetail.stadiumId;

          if (stadiumId == null) {
            return Left(
              Exception('Không tìm thấy thông tin sân vận động của trận đấu'),
            );
          }

          // Lấy chính xác sức chứa của sân vận động từ cơ sở dữ liệu
          int maxAttendance = 20000; // Giá trị mặc định nếu không tìm thấy

          // Lấy thông tin sân vận động từ cơ sở dữ liệu
          final stadiumResult = await _stadiumUseCase.getStadiumById(stadiumId);

          await stadiumResult.fold(
            (error) {
              // Nếu có lỗi, sử dụng giá trị mặc định
              print(
                'Không thể lấy thông tin sân vận động: ${error.toString()}',
              );
            },
            (stadium) {
              // Nếu tìm thấy sân vận động và có sức chứa
              if (stadium != null &&
                  stadium.capacity != null &&
                  stadium.capacity! > 0) {
                maxAttendance = stadium.capacity!;
              }
            },
          );

          // Đảm bảo minAttendance không vượt quá maxAttendance
          final safeMinAttendance =
              minAttendance < maxAttendance ? minAttendance : maxAttendance / 2;

          return await _matchUseCase.simulateMatchScore(
            matchId: matchId,
            homeScore: homeTotalPoints,
            awayScore: awayTotalPoints,
            homeFouls: homeTotalFouls,
            awayFouls: awayTotalFouls,
            minAttendance: safeMinAttendance.toInt(),
            maxAttendance: maxAttendance,
          );
        });
      });
    } catch (e) {
      return Left(Exception('Lỗi khi giả lập tỉ số trận đấu: $e'));
    }
  }

  /// Giả lập danh sách kết quả thi đấu của các cầu thủ trong trận đấu
  /// Đảm bảo tổng điểm của các cầu thủ đội nhà bằng tổng điểm đội nhà
  /// Đảm bảo tổng điểm của các cầu thủ đội khách bằng tổng điểm đội khách
  Future<Either<Exception, Map<String, List<MatchPlayerStatsEntity>>>>
  simulatePlayerStats({required int matchId}) async {
    try {
      // Lấy thông tin trận đấu để biết điểm số của hai đội
      final matchResult = await _matchUseCase.getMatchById(matchId);

      return await matchResult.fold((error) => Left(error), (match) async {
        // Kiểm tra xem trận đấu đã có điểm số chưa
        if (match.homePoints == null || match.awayPoints == null) {
          return Left(
            Exception(
              'Trận đấu chưa có điểm số, hãy giả lập điểm số trận đấu trước',
            ),
          );
        }

        final homeTeamId = match.homeSeasonTeamId;
        final awayTeamId = match.awaySeasonTeamId;

        if (homeTeamId == null || awayTeamId == null) {
          return Left(
            Exception('Không tìm thấy thông tin đội bóng trong trận đấu'),
          );
        }

        // Lấy danh sách cầu thủ của đội nhà
        final homePlayersResult = await _playerMatchUseCase
            .getTeamPlayersInMatch(matchId, homeTeamId);
        // Lấy danh sách cầu thủ của đội khách
        final awayPlayersResult = await _playerMatchUseCase
            .getTeamPlayersInMatch(matchId, awayTeamId);

        return await homePlayersResult.fold((error) => Left(error), (
          homePlayers,
        ) async {
          if (homePlayers.isEmpty) {
            return Left(
              Exception('Không tìm thấy cầu thủ của đội nhà trong trận đấu'),
            );
          }

          return await awayPlayersResult.fold((error) => Left(error), (
            awayPlayers,
          ) async {
            if (awayPlayers.isEmpty) {
              return Left(
                Exception(
                  'Không tìm thấy cầu thủ của đội khách trong trận đấu',
                ),
              );
            }

            // Giả lập điểm số và số lỗi cho từng cầu thủ
            final homePlayerStats = await _distributePlayerStats(
              players: homePlayers,
            );

            final awayPlayerStats = await _distributePlayerStats(
              players: awayPlayers,
            );

            return Right({'home': homePlayerStats, 'away': awayPlayerStats});
          });
        });
      });
    } catch (e) {
      return Left(Exception('Lỗi khi giả lập kết quả thi đấu của cầu thủ: $e'));
    }
  }

  /// Tạo thống kê ngẫu nhiên cho các cầu thủ trong đội
  /// Không phụ thuộc vào tổng điểm của trận đấu
  Future<List<MatchPlayerStatsEntity>> _distributePlayerStats({
    required List<MatchPlayerEntity> players,
  }) async {
    // Khởi tạo random
    final random = Random();

    // Danh sách kết quả
    final playerStats = <MatchPlayerStatsEntity>[];

    // Tạo thống kê ngẫu nhiên cho từng cầu thủ
    for (final player in players) {
      // Random điểm số cho cầu thủ (0-30 điểm)
      final playerScore = random.nextInt(31); // 0-30 điểm

      // Random số lỗi cho cầu thủ (0-5 lỗi)
      final playerFouls = random.nextInt(6); // 0-5 lỗi

      // Tạo thống kê cho cầu thủ
      final newStats = MatchPlayerStatsEntity(
        matchPlayerId: player.id,
        points: playerScore,
        fouls: playerFouls,
      );
      final matchPlayerDetailResult = await _matchPlayerStatsUseCase
          .getMatchPlayerStatsByMatchPlayerId(player.id!);
      matchPlayerDetailResult.fold(
        (error) {
          print(error.toString());
        },
        (stats) async {
          if (stats == null) {
            final result = await _matchPlayerStatsUseCase
                .createMatchPlayerStats(newStats);
            result.fold(
              (error) {
                print(error.toString());
              },
              (stats) {
                playerStats.add(stats);
              },
            );
          } else {
            final result = await _matchPlayerStatsUseCase
                .updateMatchPlayerStats(newStats.copyWith(id: stats.id));
            result.fold(
              (error) {
                print(error.toString());
              },
              (stats) {
                playerStats.add(stats);
              },
            );
          }
        },
      );
    }

    return playerStats;
  }
}
