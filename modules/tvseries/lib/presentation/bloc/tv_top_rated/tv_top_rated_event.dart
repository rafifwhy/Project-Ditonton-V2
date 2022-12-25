part of 'tv_top_rated_bloc.dart';

abstract class TvTopRatedEvent extends Equatable {
  const TvTopRatedEvent();
}

class FetchTvTopRated extends TvTopRatedEvent {
  @override
  List<Object> get props => [];
}
