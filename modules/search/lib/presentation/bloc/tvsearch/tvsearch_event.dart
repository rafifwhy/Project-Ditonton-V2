part of 'tvsearch_bloc.dart';

abstract class TvsearchEvent extends Equatable {
  const TvsearchEvent();

  @override
  List<Object> get props => [];
}

class OnTvQueryChanged extends TvsearchEvent {
  final String query;
  const OnTvQueryChanged(this.query);

  @override
  List<Object> get props => [query];
}
