import 'package:bloc_test/bloc_test.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:tvseries/domain/usecase/get_recommendations_tv.dart';
import 'package:tvseries/presentation/bloc/tv_recommendation/tv_recommendation_bloc.dart';

import '../../dummy_data/tv_dummy_object.dart';
import 'tv_recommendation_bloc_test.mocks.dart';

@GenerateMocks([GetRecommendationsTvSeries])
void main() {
  late TvRecommendationBloc tvRecommendationBloc;
  late MockGetRecommendationsTvSeries mockGetRecommendationsTvSeries;

  setUp(() {
    mockGetRecommendationsTvSeries = MockGetRecommendationsTvSeries();
    tvRecommendationBloc = TvRecommendationBloc(mockGetRecommendationsTvSeries);
  });

  const tId = 1;

  test('initial state should be empty', () {
    expect(tvRecommendationBloc.state, TvRecommendationEmpty());
  });

  blocTest<TvRecommendationBloc, TvRecommendationState>(
    'should emit [Loading, HasData] when tv recommendation data is gotten successfuly',
    build: () {
      when(mockGetRecommendationsTvSeries.execute(tId))
          .thenAnswer((_) async => Right(testTvSeriesList));
      return tvRecommendationBloc;
    },
    act: (bloc) => bloc.add(const FetchTvRecommendation(tId)),
    expect: () => [
      TvRecommendationLoading(),
      TvRecommendationHasData(testTvSeriesList),
    ],
    verify: (bloc) {
      verify(mockGetRecommendationsTvSeries.execute(tId));
    },
  );

  blocTest<TvRecommendationBloc, TvRecommendationState>(
    'should emit [Loading, Error] when tv popular data is gotten unsuccessful',
    build: () {
      when(mockGetRecommendationsTvSeries.execute(tId))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return tvRecommendationBloc;
    },
    act: (bloc) => bloc.add(const FetchTvRecommendation(tId)),
    expect: () => [
      TvRecommendationLoading(),
      const TvRecommendationError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetRecommendationsTvSeries.execute(tId));
    },
  );
}
