import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:tvseries/domain/usecase/get_on_air_tv.dart';
import 'package:tvseries/presentation/bloc/tv_on_air/tv_on_air_bloc.dart';

import '../../dummy_data/tv_dummy_object.dart';
import 'tv_on_air_bloc_test.mocks.dart';

@GenerateMocks([GetOnAirTvSeries])
void main() {
  late TvOnAirBloc tvOnAirBloc;
  late MockGetOnAirTvSeries mockGetOnAirTvSeries;

  setUp(() {
    mockGetOnAirTvSeries = MockGetOnAirTvSeries();
    tvOnAirBloc = TvOnAirBloc(mockGetOnAirTvSeries);
  });

  test('initial state should be empty', () {
    expect(tvOnAirBloc.state, TvOnAirEmpty());
  });

  blocTest<TvOnAirBloc, TvOnAirState>(
    'should emit [Loading, HasData] when tv on air data is gotten successfuly',
    build: () {
      when(mockGetOnAirTvSeries.execute())
          .thenAnswer((_) async => Right(testTvSeriesList));
      return tvOnAirBloc;
    },
    act: (bloc) {
      bloc.add(FetchTvOnAir());
    },
    expect: () => [
      TvOnAirLoading(),
      TvOnAirHasData(testTvSeriesList),
    ],
    verify: (bloc) {
      verify(mockGetOnAirTvSeries.execute());
    },
  );

  blocTest<TvOnAirBloc, TvOnAirState>(
    'should emit [Loading, Error] when tv on air data is gotten unsuccessful',
    build: () {
      when(mockGetOnAirTvSeries.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return tvOnAirBloc;
    },
    act: (bloc) {
      bloc.add(FetchTvOnAir());
    },
    expect: () => [
      TvOnAirLoading(),
      const TvOnAirError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetOnAirTvSeries.execute());
    },
  );
}
