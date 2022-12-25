import 'package:core/common/network_info.dart';
import 'package:core/data/datasources/db/database_helper.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:movie/data/datasource/movie_local_data_source.dart';
import 'package:movie/data/datasource/movie_remote_data_source.dart';
import 'package:movie/domain/repositories/movie_repository.dart';
import 'package:search/domain/usecases/search_movies.dart';
import 'package:tvseries/data/datasource/tv_local_data_source.dart';
import 'package:tvseries/data/datasource/tv_remote_data_source.dart';
import 'package:tvseries/domain/repositories/tv_repository.dart';

@GenerateMocks([
  MovieRepository,
  MovieRemoteDataSource,
  MovieLocalDataSource,
  TvRemoteDataSource,
  TvSeriesLocalDataSource,
  TvSeriesRepository,
  NetworkInfo,
  DatabaseHelper,
  SearchMovies,
], customMocks: [
  MockSpec<http.Client>(as: #MockHttpClient)
])
void main() {}
