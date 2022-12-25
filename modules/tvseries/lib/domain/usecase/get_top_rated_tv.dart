import 'package:dartz/dartz.dart';
import 'package:core/utils/failure.dart';

import '../entities/tv.dart';
import '../repositories/tv_repository.dart';

class GetTopRatedTvSeries {
  final TvSeriesRepository repository;

  GetTopRatedTvSeries(this.repository);

  Future<Either<Failure, List<TvSeries>>> execute() {
    return repository.getTopRatedTvSeries();
  }
}
