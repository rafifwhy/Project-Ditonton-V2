import 'package:dartz/dartz.dart';
import 'package:core/utils/failure.dart';

import '../entities/tv.dart';
import '../entities/tv_detail.dart';

abstract class TvSeriesRepository {
  Future<Either<Failure, List<TvSeries>>> getPopularTvSeries();
  Future<Either<Failure, List<TvSeries>>> getOnAirTvSeries();
  Future<Either<Failure, List<TvSeries>>> getTopRatedTvSeries();
  Future<Either<Failure, List<TvSeries>>> getTvSeriesRecomendation(int id);
  Future<Either<Failure, TvSeriesDetail>> getTvSeriesDetail(int id);
  Future<Either<Failure, List<TvSeries>>> searchTvSeries(String query);
  Future<Either<Failure, String>> saveTvWatchlist(
      TvSeriesDetail tvSeriesDetail);
  Future<Either<Failure, String>> removeTvWatchlist(
      TvSeriesDetail tvSeriesDetail);
  Future<bool> isAddedToTvWatchlist(int id);
  Future<Either<Failure, List<TvSeries>>> getWatchlistTvSeries();
}
