import 'package:core/data/datasources/db/database_helper.dart';
import 'package:core/utils/exception.dart';

import '../models/tv_series_table.dart';

abstract class TvSeriesLocalDataSource {
  Future<String> insertTvWatchList(TvSeriesTable tvSeries);
  Future<String> removeTvWatchList(TvSeriesTable tvSeries);
  Future<TvSeriesTable?> getTvSeriesById(int id);
  Future<List<TvSeriesTable>> getWatchlistTvSeries();
  Future<void> cacheOnAirTvSeries(List<TvSeriesTable> tvSeries);
  Future<List<TvSeriesTable>> getCachedOnAirTvSeries();
}

class TvSeriesLocalDataSourceImpl implements TvSeriesLocalDataSource {
  late final DatabaseHelper databaseHelper;

  TvSeriesLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<void> cacheOnAirTvSeries(List<TvSeriesTable> tvSeries) async {
    await databaseHelper.clearTvCache('now playing');
    await databaseHelper.insertCacheTransactionTvSeries(
        tvSeries, 'now playing');
  }

  @override
  Future<List<TvSeriesTable>> getCachedOnAirTvSeries() async {
    final result = await databaseHelper.getCacheTvSeries('now playing');
    if (result.length > 0) {
      return result.map((data) => TvSeriesTable.fromMap(data)).toList();
    } else {
      throw CacheException('Cant get the data');
    }
  }

  @override
  Future<TvSeriesTable?> getTvSeriesById(int id) async {
    final result = await databaseHelper.getTvSeriesById(id);
    if (result != null) {
      return TvSeriesTable.fromMap(result);
    } else {
      return null;
    }
  }

  @override
  Future<List<TvSeriesTable>> getWatchlistTvSeries() async {
    final result = await databaseHelper.getWatchlistTvSeries();
    return result.map((data) => TvSeriesTable.fromMap(data)).toList();
  }

  @override
  Future<String> insertTvWatchList(TvSeriesTable tvSeries) async {
    try {
      await databaseHelper.insertTvWatchList(tvSeries);
      return 'Added to Watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<String> removeTvWatchList(TvSeriesTable tvSeries) async {
    try {
      await databaseHelper.removeTvWatchList(tvSeries);
      return 'Removed from Watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }
}
