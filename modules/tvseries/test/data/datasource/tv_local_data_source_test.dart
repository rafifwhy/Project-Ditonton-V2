import 'package:core/utils/exception.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tvseries/data/datasource/tv_local_data_source.dart';

import '../../dummy_data/tv_dummy_object.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late TvSeriesLocalDataSourceImpl dataSource;
  late MockDatabaseHelper mockDatabaseHelper;

  setUp(() {
    mockDatabaseHelper = MockDatabaseHelper();
    dataSource =
        TvSeriesLocalDataSourceImpl(databaseHelper: mockDatabaseHelper);
  });

  group('save watch list', () {
    test('should return success message when insert to database success',
        () async {
      // arrange
      when(mockDatabaseHelper.insertTvWatchList(testTvSeriesTable))
          .thenAnswer((_) async => 1);
      // act
      final result = await dataSource.insertTvWatchList(testTvSeriesTable);
      // assert
      expect(result, 'Added to Watchlist');
    });

    test('should return DatabaseException when insert to database failed',
        () async {
      // arrange
      when(mockDatabaseHelper.insertTvWatchList(testTvSeriesTable))
          .thenThrow(Exception());
      // act
      final call = dataSource.insertTvWatchList(testTvSeriesTable);
      // assert
      expect(() => call, throwsA(isA<DatabaseException>()));
    });
  });

  group('remove watchlist', () {
    test('should return success message when remove from database success',
        () async {
      // arrange
      when(mockDatabaseHelper.removeTvWatchList(testTvSeriesTable))
          .thenAnswer((_) async => 1);
      // act
      final result = await dataSource.removeTvWatchList(testTvSeriesTable);
      // assert
      expect(result, 'Removed from Watchlist');
    });

    test('should return DatabaseException when remove from database failed',
        () async {
      // arrange
      when(mockDatabaseHelper.removeTvWatchList(testTvSeriesTable))
          .thenThrow(Exception());
      // act
      final call = dataSource.removeTvWatchList(testTvSeriesTable);
      // assert
      expect(() => call, throwsA(isA<DatabaseException>()));
    });
  });

  group('get movie detail by id', () {
    final tId = 1;

    test('should return Tv Series Detail when data is found', () async {
      // arrange
      when(mockDatabaseHelper.getTvSeriesById(tId))
          .thenAnswer((_) async => testTvSeriesMap);
      // act
      final result = await dataSource.getTvSeriesById(tId);
      // assert
      expect(result, testTvSeriesTable);
    });

    test('should return null when data is not found', () async {
      // arrange
      when(mockDatabaseHelper.getTvSeriesById(tId))
          .thenAnswer((_) async => null);
      // act
      final result = await dataSource.getTvSeriesById(tId);
      // assert
      expect(result, null);
    });
  });

  group('get watchlist tv series', () {
    test('should return list of TvSeriesTable from database', () async {
      // arrange
      when(mockDatabaseHelper.getWatchlistTvSeries())
          .thenAnswer((_) async => [testTvSeriesMap]);
      // act
      final result = await dataSource.getWatchlistTvSeries();
      // assert
      expect(result, [testTvSeriesTable]);
    });
  });

  group('cache on air tv series', () {
    test('should call database helper to save data', () async {
      // arrange
      when(mockDatabaseHelper.clearTvCache('now playing'))
          .thenAnswer((_) async => 1);
      // act
      await dataSource.cacheOnAirTvSeries([testTvSeriesCache]);
      // assert
      verify(mockDatabaseHelper.clearTvCache('now playing'));
      verify(mockDatabaseHelper
          .insertCacheTransactionTvSeries([testTvSeriesCache], 'now playing'));
    });

    test('should return list of tv series from db when data exist', () async {
      // arrange
      when(mockDatabaseHelper.getCacheTvSeries('now playing'))
          .thenAnswer((_) async => [testTvSeriesCacheMap]);
      // act
      final result = await dataSource.getCachedOnAirTvSeries();
      // assert
      expect(result, [testTvSeriesCache]);
    });

    test('should throw CacheExceptin when data is not exist', () async {
      // arrange
      when(mockDatabaseHelper.getCacheTvSeries('now playing'))
          .thenAnswer((_) async => []);
      // act
      final call = dataSource.getCachedOnAirTvSeries();
      // assert
      expect(() => call, throwsA(isA<CacheException>()));
    });
  });
}
