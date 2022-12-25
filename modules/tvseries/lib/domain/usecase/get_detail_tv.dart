import 'package:dartz/dartz.dart';
import 'package:core/utils/failure.dart';

import '../entities/tv_detail.dart';
import '../repositories/tv_repository.dart';

class GetDetailTvSeries {
  final TvSeriesRepository repository;

  GetDetailTvSeries(this.repository);

  Future<Either<Failure, TvSeriesDetail>> execute(int id) {
    return repository.getTvSeriesDetail(id);
  }
}
