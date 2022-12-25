import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:search/presentation/bloc/tvsearch/tvsearch_bloc.dart';
import 'package:search/search.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:tvseries/domain/entities/tv.dart';

import 'search_tv_bloc_test.mocks.dart';

@GenerateMocks([SearchTvSeries])
void main() {
  late TvsearchBloc tvsearchBloc;
  late MockSearchTvSeries mockSearchTvSeries;

  setUp(() {
    mockSearchTvSeries = MockSearchTvSeries();
    tvsearchBloc = TvsearchBloc(mockSearchTvSeries);
  });

  test('initial state should be empty', () {
    expect(tvsearchBloc.state, TvSearchEmpty());
  });

  final tTvModel = TvSeries(
      backdropPath: '/rkB4LyZHo1NHXFEDHl9vSD9r1lI.jpg',
      genreIds: [16, 10765, 10759, 18],
      id: 94605,
      name: 'Arcane',
      originCountry: ['US'],
      originalName: "Arcane",
      overview:
          "Amid the stark discord of twin cities Piltover and Zaun, two sisters fight on rival sides of a war between magic technologies and clashing convictions.",
      popularity: 88.071,
      posterPath: '/xQ6GijOFnxTyUzqiwGpVxgfcgqI.jpg',
      voteAverage: 8.7,
      voteCount: 2622);
  final tTvList = <TvSeries>[tTvModel];
  final tQuery = 'arcane';

  blocTest<TvsearchBloc, TvsearchState>(
      'shoulds emits [Loading, HasData] when data is gotten successfuly.',
      build: () {
        when(mockSearchTvSeries.execute(tQuery))
            .thenAnswer((_) async => Right(tTvList));
        return tvsearchBloc;
      },
      act: (bloc) => bloc.add(OnTvQueryChanged(tQuery)),
      wait: const Duration(milliseconds: 500),
      expect: () => [
            TvSearchLoading(),
            TvSearchHasData(tTvList),
          ],
      verify: (bloc) {
        verify(mockSearchTvSeries.execute(tQuery));
      });

  blocTest<TvsearchBloc, TvsearchState>(
      'Should emit [Loading, Error] when get search is unsuccessful.',
      build: () {
        when(mockSearchTvSeries.execute(tQuery)).thenAnswer(
            (realInvocation) async => Left(ServerFailure('Server failure')));
        return tvsearchBloc;
      },
      act: (bloc) => bloc.add(OnTvQueryChanged(tQuery)),
      wait: const Duration(milliseconds: 500),
      expect: () => [
            TvSearchLoading(),
            TvSearchError('Server failure'),
          ],
      verify: (bloc) {
        verify(mockSearchTvSeries.execute(tQuery));
      });
}
