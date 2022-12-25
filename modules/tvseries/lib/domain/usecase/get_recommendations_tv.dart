import 'package:dartz/dartz.dart';
import 'package:core/utils/failure.dart';

import '../entities/tv.dart';
import '../repositories/tv_repository.dart';

class GetRecommendationsTvSeries {
  final TvSeriesRepository repository;

  GetRecommendationsTvSeries(this.repository);

  Future<Either<Failure, List<TvSeries>>> execute(id) {
    return repository.getTvSeriesRecomendation(id);
  }
}
