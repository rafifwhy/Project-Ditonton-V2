import '../repositories/tv_repository.dart';

class GetWatchListTvStatus {
  final TvSeriesRepository repository;

  GetWatchListTvStatus(this.repository);

  Future<bool> execute(int id) async {
    return repository.isAddedToTvWatchlist(id);
  }
}
