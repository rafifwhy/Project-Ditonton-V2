import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tvseries/domain/entities/tv.dart';
import 'package:tvseries/domain/usecase/get_top_rated_tv.dart';

part 'tv_top_rated_event.dart';
part 'tv_top_rated_state.dart';

class TvTopRatedBloc extends Bloc<TvTopRatedEvent, TvTopRatedState> {
  final GetTopRatedTvSeries _getTopRatedTvSeries;

  TvTopRatedBloc(this._getTopRatedTvSeries) : super(TvTopRatedEmpty()) {
    on<FetchTvTopRated>((event, emit) async {
      emit(TvTopRatedLoading());
      final result = await _getTopRatedTvSeries.execute();

      result.fold((failure) {
        emit(TvTopRatedError(failure.message));
      }, (data) {
        emit(TvTopRatedHasData(data));
      });
    });
  }
}
