import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tvseries/domain/entities/tv.dart';
import 'package:tvseries/domain/entities/tv_detail.dart';
import 'package:tvseries/domain/usecase/get_watchlist_tv.dart';
import 'package:tvseries/domain/usecase/get_watchlist_tv_status.dart';
import 'package:tvseries/domain/usecase/remove_tv_watchlist.dart';
import 'package:tvseries/domain/usecase/save_tv_watchlist.dart';

part 'tv_watchlist_event.dart';
part 'tv_watchlist_state.dart';

class TvWatchlistBloc extends Bloc<TvWatchlistEvent, TvWatchlistState> {
  final GetWatchlistTvSeries _getWatchlistTvSeries;
  final GetWatchListTvStatus _getWatchListTvStatus;
  final SaveTvWatchlist _saveTvWatchlist;
  final RemoveTvWatchlist _removeTvWatchlist;

  TvWatchlistBloc(
    this._getWatchlistTvSeries,
    this._getWatchListTvStatus,
    this._saveTvWatchlist,
    this._removeTvWatchlist,
  ) : super(TvWatchlistEmpty()) {
    on<FetchTvWatchlist>((event, emit) async {
      emit(TvWatchlistLoading());
      final result = await _getWatchlistTvSeries.execute();

      result.fold((failure) {
        emit(TvWatchlistError(failure.message));
      }, (data) {
        emit(TvWatchlistHasData(data));
      });
    });

    on<StatusTvWatchlist>((event, emit) async {
      final id = event.id;
      final result = await _getWatchListTvStatus.execute(id);

      emit(TvWatchlistStatus(result));
    });

    on<AddTvWatchlist>((event, emit) async {
      final tvSeriesDetail = event.tvSeriesDetail;

      final result = await _saveTvWatchlist.execute(tvSeriesDetail);

      result.fold((failure) {
        emit(TvWatchlistFailure(failure.message));
      }, (succsess) {
        emit(const TvWatchlistSuccess('Added to Tv Watchlist'));
      });
      add(StatusTvWatchlist(tvSeriesDetail.id));
    });

    on<RemoveTvWatchlistEvent>((event, emit) async {
      final tvSeriesDetail = event.tvSeriesDetail;

      final result = await _removeTvWatchlist.execute(tvSeriesDetail);

      result.fold((failure) {
        emit(TvWatchlistError(failure.message));
      }, (succsess) {
        emit(const TvWatchlistSuccess('Removed From Tv Watchlist'));
      });
      add(StatusTvWatchlist(tvSeriesDetail.id));
    });
  }
}
