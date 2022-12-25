part of 'tvsearch_bloc.dart';

abstract class TvsearchState extends Equatable {
  const TvsearchState();

  @override
  List<Object> get props => [];
}

class TvSearchEmpty extends TvsearchState {}

class TvSearchLoading extends TvsearchState {}

class TvSearchError extends TvsearchState {
  final String message;
  const TvSearchError(this.message);

  @override
  List<Object> get props => [message];
}

class TvSearchHasData extends TvsearchState {
  final List<TvSeries> result;
  const TvSearchHasData(this.result);

  @override
  List<Object> get props => [result];
}
