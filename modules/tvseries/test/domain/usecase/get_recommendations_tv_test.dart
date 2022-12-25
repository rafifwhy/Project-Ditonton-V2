import 'package:dartz/dartz.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tvseries/domain/entities/tv.dart';
import 'package:tvseries/domain/usecase/get_recommendations_tv.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetRecommendationsTvSeries usecase;
  late MockTvSeriesRepository mockTvSeriesRepository;

  setUp(() {
    mockTvSeriesRepository = MockTvSeriesRepository();
    usecase = GetRecommendationsTvSeries(mockTvSeriesRepository);
  });

  final tId = 1;
  final tTvSeries = <TvSeries>[];

  test('should get list of tv recommendations from the repository', () async {
    // arrange
    when(mockTvSeriesRepository.getTvSeriesRecomendation(tId))
        .thenAnswer((_) async => Right(tTvSeries));
    // act
    final result = await usecase.execute(tId);
    // assert
    expect(result, Right(tTvSeries));
  });
}
