import 'package:dartz/dartz.dart';

abstract class MatchPlayerStatsApi {
  Future<Either<Exception, bool>> createTable();
}
