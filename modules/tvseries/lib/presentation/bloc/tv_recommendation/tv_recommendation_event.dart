part of 'tv_recommendation_bloc.dart';

abstract class TvRecommendationEvent extends Equatable {
  const TvRecommendationEvent();
}

class FetchTvRecommendation extends TvRecommendationEvent {
  final int id;
  const FetchTvRecommendation(this.id);

  @override
  List<Object> get props => [id];
}
