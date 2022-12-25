import 'dart:io';

import 'package:core/common/network_info.dart';
import 'package:core/data/models/genre_model.dart';
import 'package:core/utils/exception.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tvseries/data/models/tv_detail_model.dart';
import 'package:tvseries/data/models/tv_model.dart';
import 'package:tvseries/data/models/tv_series_table.dart';
import 'package:tvseries/data/repositories/tv_repository_impl.dart';
import 'package:tvseries/domain/entities/tv.dart';

import '../../dummy_data/tv_dummy_object.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late TvSeriesRepositoryImpl repository;
  late MockTvRemoteDataSource mockTvRemoteDataSource;
  late MockTvSeriesLocalDataSource mockTvSeriesLocalDataSource;
  late NetworkInfo mockNetworkInfo;

  setUpAll(() {
    mockTvRemoteDataSource = MockTvRemoteDataSource();
    mockTvSeriesLocalDataSource = MockTvSeriesLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = TvSeriesRepositoryImpl(
      remoteDataSource: mockTvRemoteDataSource,
      localDataSource: mockTvSeriesLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  final tTvSeriesModel = TvSeriesModel(
    backdropPath: "/1rO4xoCo4Z5WubK0OwdVll3DPYo.jpg",
    genreIds: [
      10765,
      10759,
      18,
    ],
    id: 84773,
    name: "The Lord of the Rings: The Rings of Power",
    originCountry: ["US"],
    originalName: "The Lord of the Rings: The Rings of Power",
    overview:
        "Beginning in a time of relative peace, we follow an ensemble cast of characters as they confront the re-emergence of evil to Middle-earth. From the darkest depths of the Misty Mountains, to the majestic forests of Lindon, to the breathtaking island kingdom of Númenor, to the furthest reaches of the map, these kingdoms and characters will carve out legacies that live on long after they are gone.",
    popularity: 5442.025,
    posterPath: "/mYLOqiStMxDK3fYZFirgrMt8z5d.jpg",
    voteAverage: 7.7,
    voteCount: 1020,
  );

  final tTvSeries = TvSeries(
    backdropPath: "/1rO4xoCo4Z5WubK0OwdVll3DPYo.jpg",
    genreIds: [
      10765,
      10759,
      18,
    ],
    id: 84773,
    name: "The Lord of the Rings: The Rings of Power",
    originCountry: ["US"],
    originalName: "The Lord of the Rings: The Rings of Power",
    overview:
        "Beginning in a time of relative peace, we follow an ensemble cast of characters as they confront the re-emergence of evil to Middle-earth. From the darkest depths of the Misty Mountains, to the majestic forests of Lindon, to the breathtaking island kingdom of Númenor, to the furthest reaches of the map, these kingdoms and characters will carve out legacies that live on long after they are gone.",
    popularity: 5442.025,
    posterPath: "/mYLOqiStMxDK3fYZFirgrMt8z5d.jpg",
    voteAverage: 7.7,
    voteCount: 1020,
  );

  final tTvSeriesModelList = <TvSeriesModel>[tTvSeriesModel];
  final tTvSeriesList = <TvSeries>[tTvSeries];

  group('On Air Tv Series', () {
    test('should check if the device is online', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockTvRemoteDataSource.getOnAirTvSeries())
          .thenAnswer((_) async => []);
      // act
      await repository.getOnAirTvSeries();
      // assert
      verify(mockNetworkInfo.isConnected);
    });

    group('when device online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
          'should return remote data when the call to remote data is successful',
          () async {
        // arrange
        when(mockTvRemoteDataSource.getOnAirTvSeries())
            .thenAnswer((_) async => tTvSeriesModelList);
        // act
        final result = await repository.getOnAirTvSeries();
        // assert
        verify(mockTvRemoteDataSource.getOnAirTvSeries());

        final resultList = result.getOrElse(() => []);
        expect(resultList, tTvSeriesList);
      });

      test(
          'should cache data locally when the call of remote data source is successful',
          () async {
        // arrange
        when(mockTvRemoteDataSource.getOnAirTvSeries())
            .thenAnswer((_) async => tTvSeriesModelList);
        // act
        await repository.getOnAirTvSeries();
        // assert
        verify(mockTvRemoteDataSource.getOnAirTvSeries());
        verify(mockTvSeriesLocalDataSource
            .cacheOnAirTvSeries([testTvSeriesCache]));
      });

      test(
          'should return server failure when the call to remote data source is unsuccessful',
          () async {
        // arrange
        when(mockTvRemoteDataSource.getOnAirTvSeries())
            .thenThrow(ServerException());
        // act
        final result = await repository.getOnAirTvSeries();
        // assert
        verify(mockTvRemoteDataSource.getOnAirTvSeries());
        expect(result, equals(Left(ServerFailure(''))));
      });
    });

    group('when device offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test('should return cached data when device is offline', () async {
        // arrange
        when(mockTvSeriesLocalDataSource.getCachedOnAirTvSeries())
            .thenAnswer((_) async => [testTvSeriesCache]);
        // act
        final result = await repository.getOnAirTvSeries();
        // assert
        verify(mockTvSeriesLocalDataSource.getCachedOnAirTvSeries());
        final resultList = result.getOrElse(() => []);
        expect(resultList, [testTvSeriesFromCache]);
      });

      test('should return CacheFailure when app has no cache', () async {
        // arrange
        when(mockTvSeriesLocalDataSource.getCachedOnAirTvSeries())
            .thenThrow(CacheException('No Cache'));
        // act
        final result = await repository.getOnAirTvSeries();
        // assert
        verify(mockTvSeriesLocalDataSource.getCachedOnAirTvSeries());
        expect(result, Left(CacheFailure('No Cache')));
      });
    });
  });

  group('Popular Tv Series', () {
    test('should return tv series list when call to data source is success ',
        () async {
      // arrange
      when(mockTvRemoteDataSource.getPopularTvSeries())
          .thenAnswer((_) async => tTvSeriesModelList);
      // act
      final result = await repository.getPopularTvSeries();
      // assert
      final resultList = result.getOrElse(() => []);
      expect(resultList, tTvSeriesList);
    });

    test(
        'should return server failure when call to data source is unsuccessful',
        () async {
      // arrange
      when(mockTvRemoteDataSource.getPopularTvSeries())
          .thenThrow(ServerException());
      // act
      final result = await repository.getPopularTvSeries();
      // assert
      expect(result, Left(ServerFailure('')));
    });

    test(
        'should return connection failure when device is not connected to the internet',
        () async {
      // arrange
      when(mockTvRemoteDataSource.getPopularTvSeries())
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await repository.getPopularTvSeries();
      // assert
      expect(
          result, Left(ConnectionFailure('Failed to connect to the network')));
    });
  });

  group('Top Rated Tv Series', () {
    test('should return tv series list when call to data source is success ',
        () async {
      // arrange
      when(mockTvRemoteDataSource.getTopRatedTvSeries())
          .thenAnswer((_) async => tTvSeriesModelList);
      // act
      final result = await repository.getTopRatedTvSeries();
      // assert
      final resultList = result.getOrElse(() => []);
      expect(resultList, tTvSeriesList);
    });

    test(
        'should return server failure when call to data source is unsuccessful',
        () async {
      // arrange
      when(mockTvRemoteDataSource.getTopRatedTvSeries())
          .thenThrow(ServerException());
      // act
      final result = await repository.getTopRatedTvSeries();
      // assert
      expect(result, Left(ServerFailure('')));
    });

    test(
        'should return connection failure when device is not connected to the internet',
        () async {
      // arrange
      when(mockTvRemoteDataSource.getTopRatedTvSeries())
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await repository.getTopRatedTvSeries();
      // assert
      expect(
          result, Left(ConnectionFailure('Failed to connect to the network')));
    });
  });

  group('Get Tv Series Detail', () {
    final tId = 1;
    final tTvSeriesResponse = TvSeriesDetailResponse(
      adult: false,
      backdropPath: "backdrop.jpg",
      episodeRunTime: [60],
      firstAirDate: DateTime.parse("2022-09-01"),
      genres: [
        GenreModel(id: 10765, name: "Sci-Fi & Fantasy"),
      ],
      homepage: "https://www.amazon.com/dp/B09QHC2LZM",
      id: 1,
      inProduction: true,
      languages: ["en"],
      lastAirDate: DateTime.parse("2022-10-06"),
      name: 'name',
      numberOfEpisodes: 1,
      numberOfSeasons: 1,
      originCountry: ["US"],
      originalLanguage: 'originalLanguage',
      originalName: 'originalName',
      overview: 'overview',
      popularity: 1,
      posterPath: 'posterPath',
      status: 'status',
      tagline: 'tagline',
      type: 'type',
      voteAverage: 1,
      voteCount: 1,
    );

    test(
        'should return Tv Series data when the call to remote data source is successful',
        () async {
      // arrange
      when(mockTvRemoteDataSource.getTvSeriesDetail(tId))
          .thenAnswer((_) async => tTvSeriesResponse);
      // act
      final result = await repository.getTvSeriesDetail(tId);
      // assert
      verify(mockTvRemoteDataSource.getTvSeriesDetail(tId));
      expect(result, equals(Right(testTvSeriesDetail)));
    });

    test(
        'should return Server Failure when the call to remote data source is unsuccessful',
        () async {
      // arrange
      when(mockTvRemoteDataSource.getTvSeriesDetail(tId))
          .thenThrow(ServerException());
      // act
      final result = await repository.getTvSeriesDetail(tId);
      // assert
      verify(mockTvRemoteDataSource.getTvSeriesDetail(tId));
      expect(result, equals(Left(ServerFailure(''))));
    });

    test(
        'should return connection failure when the device is not connected to internet',
        () async {
      // arrange
      when(mockTvRemoteDataSource.getTvSeriesDetail(tId))
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await repository.getTvSeriesDetail(tId);
      // assert
      verify(mockTvRemoteDataSource.getTvSeriesDetail(tId));
      expect(result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))));
    });
  });

  group('Get Tv Series Recommendations', () {
    final tTvSeriesList = <TvSeriesModel>[];
    final tId = 1;

    test('should return data (tv series list) when the call is successful',
        () async {
      // arrange
      when(mockTvRemoteDataSource.getTvSeriesRecomendation(tId))
          .thenAnswer((_) async => tTvSeriesList);
      // act
      final result = await repository.getTvSeriesRecomendation(tId);
      // assert
      verify(mockTvRemoteDataSource.getTvSeriesRecomendation(tId));
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => []);
      expect(resultList, equals(tTvSeriesList));
    });

    test(
        'should return server failure when call to remote data source is unsuccessful',
        () async {
      // arrange
      when(mockTvRemoteDataSource.getTvSeriesRecomendation(tId))
          .thenThrow(ServerException());
      // act
      final result = await repository.getTvSeriesRecomendation(tId);
      // assertbuild runner
      verify(mockTvRemoteDataSource.getTvSeriesRecomendation(tId));
      expect(result, equals(Left(ServerFailure(''))));
    });

    test(
        'should return connection failure when the device is not connected to the internet',
        () async {
      // arrange
      when(mockTvRemoteDataSource.getTvSeriesRecomendation(tId))
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await repository.getTvSeriesRecomendation(tId);
      // assert
      verify(mockTvRemoteDataSource.getTvSeriesRecomendation(tId));
      expect(result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))));
    });
  });

  group('Seach Tv Series', () {
    final tQuery = 'lord';

    test('should return tv series list when call to data source is successful',
        () async {
      // arrange
      when(mockTvRemoteDataSource.searchTvSeries(tQuery))
          .thenAnswer((_) async => tTvSeriesModelList);
      // act
      final result = await repository.searchTvSeries(tQuery);
      // assert
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => []);
      expect(resultList, tTvSeriesList);
    });

    test('should return ServerFailure when call to data source is unsuccessful',
        () async {
      // arrange
      when(mockTvRemoteDataSource.searchTvSeries(tQuery))
          .thenThrow(ServerException());
      // act
      final result = await repository.searchTvSeries(tQuery);
      // assert
      expect(result, Left(ServerFailure('')));
    });

    test(
        'should return ConnectionFailure when device is not connected to the internet',
        () async {
      // arrange
      when(mockTvRemoteDataSource.searchTvSeries(tQuery))
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await repository.searchTvSeries(tQuery);
      // assert
      expect(
          result, Left(ConnectionFailure('Failed to connect to the network')));
    });
  });

  group('Save Watchlist', () {
    test('should return success message when saving successful', () async {
      // arrange
      when(mockTvSeriesLocalDataSource
              .insertTvWatchList(TvSeriesTable.fromEntity(testTvSeriesDetail)))
          .thenAnswer((_) async => 'Added to Watchlist');
      // act
      final result = await repository.saveTvWatchlist(testTvSeriesDetail);
      // assert
      expect(result, Right('Added to Watchlist'));
    });

    test('should return DatabaseFailure when saving unsuccessful', () async {
      // arrange
      when(mockTvSeriesLocalDataSource
              .insertTvWatchList(TvSeriesTable.fromEntity(testTvSeriesDetail)))
          .thenThrow(DatabaseException('Failed to add watchlist'));
      // act
      final result = await repository.saveTvWatchlist(testTvSeriesDetail);
      // assert
      expect(result, Left(DatabaseFailure('Failed to add watchlist')));
    });
  });

  group('remove watchlist', () {
    test('should return success message when remove successful', () async {
      // arrange
      when(mockTvSeriesLocalDataSource
              .removeTvWatchList(TvSeriesTable.fromEntity(testTvSeriesDetail)))
          .thenAnswer((_) async => 'Removed from watchlist');
      // act
      final result = await repository.removeTvWatchlist(testTvSeriesDetail);
      // assert
      expect(result, Right('Removed from watchlist'));
    });

    test('should return DatabaseFailure when remove unsuccessful', () async {
      // arrange
      when(mockTvSeriesLocalDataSource
              .removeTvWatchList(TvSeriesTable.fromEntity(testTvSeriesDetail)))
          .thenThrow(DatabaseException('Failed to remove watchlist'));
      // act
      final result = await repository.removeTvWatchlist(testTvSeriesDetail);
      // assert
      expect(result, Left(DatabaseFailure('Failed to remove watchlist')));
    });
  });

  group('get watchlist status', () {
    test('should return watch status whether data is found', () async {
      // arrange
      final tId = 1;
      when(mockTvSeriesLocalDataSource.getTvSeriesById(tId))
          .thenAnswer((_) async => null);
      // act
      final result = await repository.isAddedToTvWatchlist(tId);
      // assert
      expect(result, false);
    });
  });

  group('get watchlist movies', () {
    test('should return list of Movies', () async {
      // arrange
      when(mockTvSeriesLocalDataSource.getWatchlistTvSeries())
          .thenAnswer((_) async => [testTvSeriesTable]);
      // act
      final result = await repository.getWatchlistTvSeries();
      // assert
      final resultList = result.getOrElse(() => []);
      expect(resultList, [testWatchlistTvSeries]);
    });
  });
}
