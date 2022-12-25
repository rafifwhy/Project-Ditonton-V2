import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:movie/domain/entities/movie_detail.dart';
import 'package:movie/domain/usecase/get_watchlist_movies.dart';
import 'package:movie/domain/usecase/get_watchlist_status.dart';
import 'package:movie/domain/usecase/remove_watchlist.dart';
import 'package:movie/domain/usecase/save_watchlist.dart';

import '../../../domain/entities/movie.dart';

part 'watchlist_movies_event.dart';
part 'watchlist_movies_state.dart';

class WatchlistMoviesBloc
    extends Bloc<WatchlistMoviesEvent, WatchlistMoviesState> {
  final GetWatchlistMovies _getWatchlistMovies;
  final GetWatchListStatus _getWatchListStatus;
  final SaveWatchlist _saveWatchlist;
  final RemoveWatchlist _removeWatchlist;

  WatchlistMoviesBloc(this._getWatchlistMovies, this._getWatchListStatus,
      this._saveWatchlist, this._removeWatchlist)
      : super(WatchlistMoviesEmpty()) {
    on<FetchWatchlistMovies>((event, emit) async {
      emit(WatchlistMoviesLoading());
      final result = await _getWatchlistMovies.execute();

      result.fold((failure) {
        emit(WatchlistMoviesError(failure.message));
      }, (data) {
        emit(WatchlistMoviesHasData(data));
      });
    });

    on<LoadWatchlistStatus>(((event, emit) async {
      final id = event.id;
      final result = await _getWatchListStatus.execute(id);

      emit(WatchlistStatus(result));
    }));

    on<AddWatchlist>((event, emit) async {
      final movie = event.movieDetail;
      final result = await _saveWatchlist.execute(movie);

      result.fold((failure) {
        emit(WatchlistFailure(failure.message));
      }, (success) {
        emit(const WatchlistSuccess('Added to Watchlist'));
      });
      add(LoadWatchlistStatus(movie.id));
    });

    on<RemoveFromWatchlist>(
      (event, emit) async {
        final movie = event.movieDetail;
        final result = await _removeWatchlist.execute(movie);
        result.fold((failure) {
          emit(WatchlistFailure(failure.message));
        }, (success) {
          emit(WatchlistSuccess(success));
        });
        add(LoadWatchlistStatus(movie.id));
      },
    );
  }
}
