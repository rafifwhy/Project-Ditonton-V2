import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tvseries/domain/usecase/get_recommendations_tv.dart';

import '../../../domain/entities/tv.dart';

part 'tv_recommendation_event.dart';
part 'tv_recommendation_state.dart';

class TvRecommendationBloc
    extends Bloc<TvRecommendationEvent, TvRecommendationState> {
  final GetRecommendationsTvSeries _getRecommendationsTvSeries;

  TvRecommendationBloc(this._getRecommendationsTvSeries)
      : super(TvRecommendationEmpty()) {
    on<FetchTvRecommendation>((event, emit) async {
      emit(TvRecommendationLoading());
      final id = event.id;
      final result = await _getRecommendationsTvSeries.execute(id);

      result.fold((failure) {
        emit(TvRecommendationError(failure.message));
      }, (data) {
        emit(TvRecommendationHasData(data));
      });
    });
  }
}
