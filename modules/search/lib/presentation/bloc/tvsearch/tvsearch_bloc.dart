import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/transformers.dart';
import 'package:search/domain/usecases/search_tv_series.dart';
import 'package:tvseries/domain/entities/tv.dart';

part 'tvsearch_event.dart';
part 'tvsearch_state.dart';

class TvsearchBloc extends Bloc<TvsearchEvent, TvsearchState> {
  final SearchTvSeries _searchTvSeries;

  EventTransformer<T> debounce<T>(Duration duration) {
    return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
  }

  TvsearchBloc(this._searchTvSeries) : super(TvSearchEmpty()) {
    on<OnTvQueryChanged>((event, emit) async {
      final query = event.query;

      emit(TvSearchLoading());
      final result = await _searchTvSeries.execute(query);

      result.fold(
        (failure) {
          emit(TvSearchError(failure.message));
        },
        (data) {
          emit(TvSearchHasData(data));
        },
      );
    }, transformer: debounce(const Duration(milliseconds: 500)));
  }
}
