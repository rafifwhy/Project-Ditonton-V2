import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tvseries/domain/entities/tv_detail.dart';
import 'package:tvseries/domain/usecase/get_detail_tv.dart';

part 'tv_detail_event.dart';
part 'tv_detail_state.dart';

class TvDetailBloc extends Bloc<TvDetailEvent, TvDetailState> {
  final GetDetailTvSeries _getDetailTvSeries;

  TvDetailBloc(this._getDetailTvSeries) : super(TvDetailEmpty()) {
    on<FetchTvDetail>((event, emit) async {
      final id = event.id;

      emit(TvDetailLoading());
      final result = await _getDetailTvSeries.execute(id);

      result.fold((failure) {
        emit(TvDetailError(failure.message));
      }, (data) {
        emit(TvDetailHasData(data));
      });
    });
  }
}
