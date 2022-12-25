import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:tvseries/domain/usecase/get_detail_tv.dart';
import 'package:tvseries/presentation/bloc/tv_detail/tv_detail_bloc.dart';

import '../../dummy_data/tv_dummy_object.dart';
import 'tv_detail_bloc_test.mocks.dart';

@GenerateMocks([GetDetailTvSeries])
void main() {
  late TvDetailBloc tvDetailBloc;
  late MockGetDetailTvSeries mockGetDetailTvSeries;

  setUp(() {
    mockGetDetailTvSeries = MockGetDetailTvSeries();
    tvDetailBloc = TvDetailBloc(mockGetDetailTvSeries);
  });

  const tId = 1;

  test('initial state should be empty', () {
    expect(tvDetailBloc.state, TvDetailEmpty());
  });

  blocTest<TvDetailBloc, TvDetailState>(
      'Should emit [Loading, HasData] when detail tv series detail data is gotten successfuly',
      build: () {
        when(mockGetDetailTvSeries.execute(tId))
            .thenAnswer((_) async => Right(testTvSeriesDetail));
        return tvDetailBloc;
      },
      act: (bloc) => bloc.add(const FetchTvDetail(tId)),
      expect: () => [
            TvDetailLoading(),
            TvDetailHasData(testTvSeriesDetail),
          ],
      verify: (bloc) {
        verify(mockGetDetailTvSeries.execute(tId));
      });

  blocTest<TvDetailBloc, TvDetailState>(
      'Should emit [Loading, Error] when detail tv series detail data is gotten unsuccessful',
      build: () {
        when(mockGetDetailTvSeries.execute(tId))
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return tvDetailBloc;
      },
      act: (bloc) => bloc.add(const FetchTvDetail(tId)),
      expect: () => [
            TvDetailLoading(),
            const TvDetailError('Server Failure'),
          ],
      verify: (bloc) {
        verify(mockGetDetailTvSeries.execute(tId));
      });
}
