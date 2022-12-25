import 'dart:convert';
import 'package:core/utils/exception.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:tvseries/data/datasource/tv_remote_data_source.dart';
import 'package:tvseries/data/models/tv_detail_model.dart';
import 'package:tvseries/data/models/tv_model.dart';

import '../../json_reader.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  const API_KEY = 'api_key=2174d146bb9c0eab47529b2e77d6b526';
  const BASE_URL = 'https://api.themoviedb.org/3';

  late TvRemoteDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = TvRemoteDataSourceImpl(client: mockHttpClient);
  });

  group('get On Air Tv Series', () {
    final tTvSeriesList = TvSeriesResponse.fromJson(
            json.decode(readJson('dummy_data/on_air_tv_series.json')))
        .tvList;

    test('should return list of TvSeriesModel when the response code is 200',
        () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/on_the_air?$API_KEY')))
          .thenAnswer((_) async =>
              http.Response(readJson('dummy_data/on_air_tv_series.json'), 200));
      // act
      final result = await dataSource.getOnAirTvSeries();
      // assert
      expect(result, equals(tTvSeriesList));
    });

    test('should return ServerException when the response code is 404 or other',
        () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/on_the_air?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.getOnAirTvSeries();
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('Get Popular Tv Series', () {
    final tTvSeriesList = TvSeriesResponse.fromJson(
            json.decode(readJson('dummy_data/popular_tv_series.json')))
        .tvList;
    test('should return list of TvSeries when response is succsess (200)',
        () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/popular?$API_KEY')))
          .thenAnswer((_) async => http.Response(
              readJson('dummy_data/popular_tv_series.json'), 200));
      // act
      final result = await dataSource.getPopularTvSeries();
      // assert
      expect(result, equals(tTvSeriesList));
    });

    test(
        'should return ServerException when response is unsuccessful (404 or others)',
        () {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/popular?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.getPopularTvSeries();
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('Get Top Rated Tv Series', () {
    final tTvSeriesList = TvSeriesResponse.fromJson(
            json.decode(readJson('dummy_data/top_rated_tv_series.json')))
        .tvList;

    test('should return list of TvSeries when response is successful (200)',
        () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/top_rated?$API_KEY')))
          .thenAnswer((_) async => http.Response(
              readJson('dummy_data/top_rated_tv_series.json'), 200));
      // act
      final result = await dataSource.getTopRatedTvSeries();
      // assert
      expect(result, equals(tTvSeriesList));
    });

    test(
        'should return ServerException when response is unsuccsessful (404 or others)',
        () {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/top_rated?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.getTopRatedTvSeries();
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('Get Tv Series Detail', () {
    final tId = 1;
    final tTvSeriesDetail = TvSeriesDetailResponse.fromJson(
        json.decode(readJson('dummy_data/detail_tv_series.json')));

    test('should return tv series detail when response is successfull (200)',
        () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/$tId?$API_KEY')))
          .thenAnswer((_) async =>
              http.Response(readJson('dummy_data/detail_tv_series.json'), 200));
      // act
      final result = await dataSource.getTvSeriesDetail(tId);
      // assert
      expect(result, equals(tTvSeriesDetail));
    });

    test(
        'should return ServerException when response is unsuccessful (404 or others)',
        () {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/$tId?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.getTvSeriesDetail(tId);
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('Get Tv Series Recommendation', () {
    final tId = 1;
    final tTvSeriesList = TvSeriesResponse.fromJson(
            json.decode(readJson('dummy_data/recommendation_tv_series.json')))
        .tvList;

    test('should return TvSeries model when response is successful (200)',
        () async {
      // arrange
      when(mockHttpClient
              .get(Uri.parse('$BASE_URL/tv/$tId/recommendations?$API_KEY')))
          .thenAnswer((_) async => http.Response(
              readJson('dummy_data/recommendation_tv_series.json'), 200));
      // act
      final result = await dataSource.getTvSeriesRecomendation(tId);
      // assert
      expect(result, equals(tTvSeriesList));
    });

    test(
        'should return ServerException when response is unsuccessful (404 or others) ',
        () async {
      // arrange
      when(mockHttpClient
              .get(Uri.parse('$BASE_URL/tv/$tId/recommendations?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.getTvSeriesRecomendation(tId);
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('Search Tv Series', () {
    final tSearchResult = TvSeriesResponse.fromJson(
            jsonDecode(readJson('dummy_data/search_LOTR_tv_series.json')))
        .tvList;
    final tSearchQuery = 'Lord';

    test('should return list of Tv Series when response code 200', () async {
      // arrange
      when(mockHttpClient.get(
              Uri.parse('$BASE_URL/search/tv?$API_KEY&query=$tSearchQuery')))
          .thenAnswer((_) async => http.Response(
              readJson('dummy_data/search_LOTR_tv_series.json'), 200));
      // act
      final result = await dataSource.searchTvSeries(tSearchQuery);
      // assert
      expect(result, equals(tSearchResult));
    });

    test('should return ServerException when response code is 404 or others',
        () async {
      // arrange
      when(mockHttpClient.get(
              Uri.parse('$BASE_URL/search/tv?$API_KEY&query=$tSearchQuery')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.searchTvSeries(tSearchQuery);
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });
}
