import 'package:dartz/dartz.dart';

abstract class MatchApi {
  Future<Either<Exception, bool>> createTable();
}
