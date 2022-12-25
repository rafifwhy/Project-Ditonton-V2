import 'package:core/domain/entities/genre.dart';
import 'package:tvseries/data/models/tv_series_table.dart';
import 'package:tvseries/domain/entities/tv.dart';
import 'package:tvseries/domain/entities/tv_detail.dart';

final testTvSeriesTable = TvSeriesTable(
  id: 1,
  name: 'name',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testTvSeries = TvSeries(
  backdropPath: 'backdropPath.jpg',
  genreIds: [1],
  id: 1,
  name: 'name',
  originCountry: ['originCountry'],
  originalName: 'originalName',
  overview: 'overview',
  popularity: 1,
  posterPath: 'posterPath',
  voteAverage: 1,
  voteCount: 1,
);

final testTvSeriesList = [testTvSeries];

final testWatchlistTvSeries = TvSeries.watchlist(
  id: 1,
  name: 'name',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testTvSeriesMap = {
  'id': 1,
  'overview': 'overview',
  'posterPath': 'posterPath',
  'name': 'name',
};

final testTvSeriesCache = TvSeriesTable(
  id: 84773,
  overview:
      'Beginning in a time of relative peace, we follow an ensemble cast of characters as they confront the re-emergence of evil to Middle-earth. From the darkest depths of the Misty Mountains, to the majestic forests of Lindon, to the breathtaking island kingdom of Númenor, to the furthest reaches of the map, these kingdoms and characters will carve out legacies that live on long after they are gone.',
  posterPath: '/mYLOqiStMxDK3fYZFirgrMt8z5d.jpg',
  name: 'The Lord of the Rings: The Rings of Power',
);

final testTvSeriesCacheMap = {
  'id': 84773,
  'overview':
      'Beginning in a time of relative peace, we follow an ensemble cast of characters as they confront the re-emergence of evil to Middle-earth. From the darkest depths of the Misty Mountains, to the majestic forests of Lindon, to the breathtaking island kingdom of Númenor, to the furthest reaches of the map, these kingdoms and characters will carve out legacies that live on long after they are gone.',
  'posterPath': '/mYLOqiStMxDK3fYZFirgrMt8z5d.jpg',
  'name': 'The Lord of the Rings: The Rings of Power',
};

final testTvSeriesFromCache = TvSeries.watchlist(
  id: 84773,
  overview:
      'Beginning in a time of relative peace, we follow an ensemble cast of characters as they confront the re-emergence of evil to Middle-earth. From the darkest depths of the Misty Mountains, to the majestic forests of Lindon, to the breathtaking island kingdom of Númenor, to the furthest reaches of the map, these kingdoms and characters will carve out legacies that live on long after they are gone.',
  posterPath: "/mYLOqiStMxDK3fYZFirgrMt8z5d.jpg",
  name: 'The Lord of the Rings: The Rings of Power',
);

final testTvSeriesDetail = TvSeriesDetail(
  adult: false,
  backdropPath: "backdrop.jpg",
  episodeRunTime: [60],
  firstAirDate: DateTime.parse("2022-09-01"),
  genres: [
    Genre(id: 10765, name: "Sci-Fi & Fantasy"),
  ],
  homepage: "https://www.amazon.com/dp/B09QHC2LZM",
  id: 1,
  inProduction: true,
  languages: ["en"],
  lastAirDate: DateTime.parse("2022-10-06"),
  name: 'name',
  numberOfEpisodes: 1,
  numberOfSeasons: 1,
  originCountry: ["US"],
  originalLanguage: 'originalLanguage',
  originalName: 'originalName',
  overview: 'overview',
  popularity: 1,
  posterPath: 'posterPath',
  status: 'status',
  tagline: 'tagline',
  type: 'type',
  voteAverage: 1,
  voteCount: 1,
);
