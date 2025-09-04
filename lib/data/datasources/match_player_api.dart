import 'package:dartz/dartz.dart';

abstract class MatchPlayerApi {
  Future<Either<Exception, bool>> createTable();
}
