import 'package:bloc_test/bloc_test.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:tvseries/domain/usecase/get_watchlist_tv.dart';
import 'package:tvseries/domain/usecase/get_watchlist_tv_status.dart';
import 'package:tvseries/domain/usecase/remove_tv_watchlist.dart';
import 'package:tvseries/domain/usecase/save_tv_watchlist.dart';
import 'package:tvseries/presentation/bloc/tv_watchlist/tv_watchlist_bloc.dart';

import '../../dummy_data/tv_dummy_object.dart';
import 'tv_watchlist_bloc_test.mocks.dart';

@GenerateMocks([
  GetWatchlistTvSeries,
  GetWatchListTvStatus,
  SaveTvWatchlist,
  RemoveTvWatchlist,
])
void main() {
  late TvWatchlistBloc tvWatchlistBloc;
  late MockGetWatchlistTvSeries mockGetWatchlistTvSeries;
  late MockGetWatchListTvStatus mockGetWatchListTvStatus;
  late MockSaveTvWatchlist mockSaveTvWatchlist;
  late MockRemoveTvWatchlist mockRemoveTvWatchlist;

  setUp(() {
    mockGetWatchlistTvSeries = MockGetWatchlistTvSeries();
    mockGetWatchListTvStatus = MockGetWatchListTvStatus();
    mockSaveTvWatchlist = MockSaveTvWatchlist();
    mockRemoveTvWatchlist = MockRemoveTvWatchlist();
    tvWatchlistBloc = TvWatchlistBloc(mockGetWatchlistTvSeries,
        mockGetWatchListTvStatus, mockSaveTvWatchlist, mockRemoveTvWatchlist);
  });

  test('initial state should be empty', () {
    expect(tvWatchlistBloc.state, TvWatchlistEmpty());
  });

  blocTest<TvWatchlistBloc, TvWatchlistState>(
    'should emit [Loading, HasData] when tv watchlist is gotten successfuly',
    build: () {
      when(mockGetWatchlistTvSeries.execute())
          .thenAnswer((_) async => Right(testTvSeriesList));
      return tvWatchlistBloc;
    },
    act: (bloc) => bloc.add(FetchTvWatchlist()),
    expect: () => [
      TvWatchlistLoading(),
      TvWatchlistHasData(testTvSeriesList),
    ],
    verify: (bloc) {
      verify(mockGetWatchlistTvSeries.execute());
    },
  );

  blocTest<TvWatchlistBloc, TvWatchlistState>(
    'should emit [Loading, Error] when tv watchlist data is gotten unsuccessful',
    build: () {
      when(mockGetWatchlistTvSeries.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return tvWatchlistBloc;
    },
    act: (bloc) => bloc.add(FetchTvWatchlist()),
    expect: () => [
      TvWatchlistLoading(),
      const TvWatchlistError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetWatchlistTvSeries.execute());
    },
  );
}
