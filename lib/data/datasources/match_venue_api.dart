import 'package:dartz/dartz.dart';

abstract class MatchVenueApi {
  Future<Either<Exception, bool>> createTable();
}
