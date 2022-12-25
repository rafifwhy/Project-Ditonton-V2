part of 'watchlist_movies_bloc.dart';

abstract class WatchlistMoviesState extends Equatable {
  const WatchlistMoviesState();

  @override
  List<Object> get props => [];
}

class WatchlistMoviesEmpty extends WatchlistMoviesState {}

class WatchlistMoviesLoading extends WatchlistMoviesState {}

class WatchlistMoviesError extends WatchlistMoviesState {
  final String message;
  const WatchlistMoviesError(this.message);

  @override
  List<Object> get props => [message];
}

class WatchlistMoviesHasData extends WatchlistMoviesState {
  final List<Movie> result;
  const WatchlistMoviesHasData(this.result);

  @override
  List<Object> get props => [result];
}

class WatchlistFailure extends WatchlistMoviesState {
  final String message;
  const WatchlistFailure(this.message);

  @override
  List<Object> get props => [message];
}

class WatchlistSuccess extends WatchlistMoviesState {
  final String message;
  const WatchlistSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class WatchlistStatus extends WatchlistMoviesState {
  final bool isAddedToWatchlist;
  const WatchlistStatus(this.isAddedToWatchlist);

  @override
  List<Object> get props => [isAddedToWatchlist];
}
