part of 'tv_watchlist_bloc.dart';

abstract class TvWatchlistState extends Equatable {
  const TvWatchlistState();

  @override
  List<Object> get props => [];
}

class TvWatchlistEmpty extends TvWatchlistState {}

class TvWatchlistLoading extends TvWatchlistState {}

class TvWatchlistError extends TvWatchlistState {
  final String message;
  const TvWatchlistError(this.message);

  @override
  List<Object> get props => [message];
}

class TvWatchlistHasData extends TvWatchlistState {
  final List<TvSeries> result;
  const TvWatchlistHasData(this.result);

  @override
  List<Object> get props => [result];
}

class TvWatchlistFailure extends TvWatchlistState {
  final String message;
  const TvWatchlistFailure(this.message);

  @override
  List<Object> get props => [message];
}

class TvWatchlistSuccess extends TvWatchlistState {
  final String message;
  const TvWatchlistSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class TvWatchlistStatus extends TvWatchlistState {
  final bool isAddedToWatchlist;
  const TvWatchlistStatus(this.isAddedToWatchlist);

  @override
  List<Object> get props => [isAddedToWatchlist];
}
