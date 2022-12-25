import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tvseries/domain/usecase/get_on_air_tv.dart';

import '../../../domain/entities/tv.dart';

part 'tv_on_air_event.dart';
part 'tv_on_air_state.dart';

class TvOnAirBloc extends Bloc<TvOnAirEvent, TvOnAirState> {
  final GetOnAirTvSeries _getOnAirTvSeries;

  TvOnAirBloc(this._getOnAirTvSeries) : super(TvOnAirEmpty()) {
    on<FetchTvOnAir>((event, emit) async {
      emit(TvOnAirLoading());
      final result = await _getOnAirTvSeries.execute();

      result.fold((failure) {
        emit(TvOnAirError(failure.message));
      }, (data) {
        emit(TvOnAirHasData(data));
      });
    });
  }
}
