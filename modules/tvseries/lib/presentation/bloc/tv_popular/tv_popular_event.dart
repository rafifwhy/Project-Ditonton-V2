part of 'tv_popular_bloc.dart';

abstract class TvPopularEvent extends Equatable {
  const TvPopularEvent();
}

class FetchTvPopular extends TvPopularEvent {
  @override
  List<Object> get props => [];
}
