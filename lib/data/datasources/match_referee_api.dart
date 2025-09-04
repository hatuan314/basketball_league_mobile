import 'package:dartz/dartz.dart';

abstract class MatchRefereeApi {
  Future<Either<Exception, bool>> createTable();
}
