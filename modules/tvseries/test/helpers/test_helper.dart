import 'package:core/common/network_info.dart';
import 'package:core/data/datasources/db/database_helper.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:tvseries/data/datasource/tv_local_data_source.dart';
import 'package:tvseries/data/datasource/tv_remote_data_source.dart';
import 'package:tvseries/domain/repositories/tv_repository.dart';

@GenerateMocks([
  TvRemoteDataSource,
  TvSeriesLocalDataSource,
  TvSeriesRepository,
  NetworkInfo,
  DatabaseHelper
], customMocks: [
  MockSpec<http.Client>(as: #MockHttpClient)
])
void main() {}
