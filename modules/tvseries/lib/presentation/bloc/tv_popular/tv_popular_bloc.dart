import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tvseries/domain/usecase/get_popular_tv.dart';

import '../../../domain/entities/tv.dart';

part 'tv_popular_event.dart';
part 'tv_popular_state.dart';

class TvPopularBloc extends Bloc<TvPopularEvent, TvPopularState> {
  final GetPopularTvSeries _getPopularTvSeries;

  TvPopularBloc(this._getPopularTvSeries) : super(TvPopularEmpty()) {
    on<FetchTvPopular>((event, emit) async {
      emit(TvPopularLoading());
      final result = await _getPopularTvSeries.execute();

      result.fold((failure) {
        emit(TvPopularError(failure.message));
      }, (data) {
        emit(TvPopularHasData(data));
      });
    });
  }
}
