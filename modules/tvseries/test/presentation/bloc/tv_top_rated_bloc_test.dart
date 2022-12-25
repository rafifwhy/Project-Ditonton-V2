import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:tvseries/domain/usecase/get_top_rated_tv.dart';
import 'package:tvseries/presentation/bloc/tv_top_rated/tv_top_rated_bloc.dart';

import '../../dummy_data/tv_dummy_object.dart';
import 'tv_top_rated_bloc_test.mocks.dart';

@GenerateMocks([GetTopRatedTvSeries])
void main() {
  late TvTopRatedBloc tvTopRatedBloc;
  late MockGetTopRatedTvSeries mockGetTopRatedTvSeries;

  setUp(() {
    mockGetTopRatedTvSeries = MockGetTopRatedTvSeries();
    tvTopRatedBloc = TvTopRatedBloc(mockGetTopRatedTvSeries);
  });

  test('initial state should be empty', () {
    expect(tvTopRatedBloc.state, TvTopRatedEmpty());
  });

  blocTest<TvTopRatedBloc, TvTopRatedState>(
    'should emit [Loading, HasData] when tv top rated data is gotten unsuccessful',
    build: () {
      when(mockGetTopRatedTvSeries.execute())
          .thenAnswer((_) async => Right(testTvSeriesList));
      return tvTopRatedBloc;
    },
    act: (bloc) => bloc.add(FetchTvTopRated()),
    expect: () => [
      TvTopRatedLoading(),
      TvTopRatedHasData(testTvSeriesList),
    ],
    verify: (bloc) {
      verify(mockGetTopRatedTvSeries.execute());
    },
  );

  blocTest<TvTopRatedBloc, TvTopRatedState>(
    'should emit [Loading, Error] when tv top rated data is gotten successfuly',
    build: () {
      when(mockGetTopRatedTvSeries.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return tvTopRatedBloc;
    },
    act: (bloc) => bloc.add(FetchTvTopRated()),
    expect: () => [
      TvTopRatedLoading(),
      const TvTopRatedError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetTopRatedTvSeries.execute());
    },
  );
}
