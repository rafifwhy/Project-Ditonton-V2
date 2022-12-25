part of 'tv_watchlist_bloc.dart';

abstract class TvWatchlistEvent extends Equatable {
  const TvWatchlistEvent();

  @override
  List<Object> get props => [];
}

class FetchTvWatchlist extends TvWatchlistEvent {}

class AddTvWatchlist extends TvWatchlistEvent {
  final TvSeriesDetail tvSeriesDetail;
  const AddTvWatchlist(this.tvSeriesDetail);

  @override
  List<Object> get props => [tvSeriesDetail];
}

class RemoveTvWatchlistEvent extends TvWatchlistEvent {
  final TvSeriesDetail tvSeriesDetail;
  const RemoveTvWatchlistEvent(this.tvSeriesDetail);

  @override
  List<Object> get props => [tvSeriesDetail];
}

class StatusTvWatchlist extends TvWatchlistEvent {
  final int id;
  const StatusTvWatchlist(this.id);

  @override
  List<Object> get props => [id];
}
