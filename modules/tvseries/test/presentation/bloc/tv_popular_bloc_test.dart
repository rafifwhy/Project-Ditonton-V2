import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:tvseries/domain/usecase/get_popular_tv.dart';
import 'package:tvseries/presentation/bloc/tv_popular/tv_popular_bloc.dart';

import '../../dummy_data/tv_dummy_object.dart';
import 'tv_popular_bloc_test.mocks.dart';

@GenerateMocks([GetPopularTvSeries])
void main() {
  late TvPopularBloc tvPopularBloc;
  late MockGetPopularTvSeries mockGetPopularTvSeries;

  setUp(() {
    mockGetPopularTvSeries = MockGetPopularTvSeries();
    tvPopularBloc = TvPopularBloc(mockGetPopularTvSeries);
  });

  test('initial state should be empty', () {
    expect(tvPopularBloc.state, TvPopularEmpty());
  });

  blocTest<TvPopularBloc, TvPopularState>(
    'should emit [Loading, HasData] when tv popular data is gotten successfuly',
    build: () {
      when(mockGetPopularTvSeries.execute())
          .thenAnswer((_) async => Right(testTvSeriesList));
      return tvPopularBloc;
    },
    act: (bloc) => bloc.add(FetchTvPopular()),
    expect: () => [
      TvPopularLoading(),
      TvPopularHasData(testTvSeriesList),
    ],
    verify: (bloc) {
      verify(mockGetPopularTvSeries.execute());
    },
  );

  blocTest<TvPopularBloc, TvPopularState>(
    'should emit [Loading, Error] when tv popular data is gotten unsuccessful',
    build: () {
      when(mockGetPopularTvSeries.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return tvPopularBloc;
    },
    act: (bloc) => bloc.add(FetchTvPopular()),
    expect: () => [
      TvPopularLoading(),
      const TvPopularError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetPopularTvSeries.execute());
    },
  );
}
