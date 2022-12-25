import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/presentation/widgets/sub_heading.dart';
import 'package:core/utils/constants.dart';
import 'package:core/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:search/presentation/pages/search_tv_page.dart';
import 'package:tvseries/presentation/bloc/tv_on_air/tv_on_air_bloc.dart';
import 'package:tvseries/presentation/bloc/tv_popular/tv_popular_bloc.dart';
import 'package:tvseries/presentation/bloc/tv_top_rated/tv_top_rated_bloc.dart';
import 'package:tvseries/presentation/pages/popular_tv_page.dart';
import 'package:tvseries/presentation/pages/top_rated_tv_page.dart';
import 'package:tvseries/presentation/pages/watchlist_tv_page.dart';

import '../../domain/entities/tv.dart';
import 'detail_tv_page.dart';
import 'on_air_tv_page.dart';

class HomeTvPage extends StatefulWidget {
  @override
  State<HomeTvPage> createState() => _HomeTvPageState();
}

class _HomeTvPageState extends State<HomeTvPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      BlocProvider.of<TvTopRatedBloc>(context, listen: false)
          .add(FetchTvTopRated());
      BlocProvider.of<TvOnAirBloc>(context, listen: false).add(FetchTvOnAir());
      BlocProvider.of<TvPopularBloc>(context, listen: false)
          .add(FetchTvPopular());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            const UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/circle-g.png'),
              ),
              accountName: Text('Ditonton'),
              accountEmail: Text('ditonton@dicoding.com'),
            ),
            ListTile(
              leading: Icon(Icons.movie),
              title: Text('Movies'),
              onTap: () {
                Navigator.pushNamed(context, '/home_movie');
              },
            ),
            ListTile(
              leading: Icon(Icons.tv),
              title: Text('TV Series'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.save_alt),
              title: Text('Watchlist'),
              onTap: () {
                Navigator.pushNamed(context, WatchlistTvPage.ROUTE_NAME);
              },
            ),
            ListTile(
              onTap: () {
                Navigator.pushNamed(context, ABOUT_ROUTE);
              },
              leading: Icon(Icons.info_outline),
              title: Text('About'),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('Ditonton'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, SearchTvPage.ROUTE_NAME);
            },
            icon: Icon(Icons.search),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SubHeading(
              title: 'On Air Tv Series',
              onTap: () => Navigator.pushNamed(context, OnAirTvPage.ROUTE_NAME),
            ),
            BlocBuilder<TvOnAirBloc, TvOnAirState>(builder: (context, state) {
              if (state is TvOnAirLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is TvOnAirHasData) {
                return TvList(state.result);
              } else if (state is TvOnAirError) {
                return Center(
                  child: Text(state.message),
                );
              } else {
                return Text('Failed to load');
              }
            }),
            SubHeading(
              title: 'Popular Series',
              onTap: () =>
                  Navigator.pushNamed(context, PopularTvPage.ROUTE_NAME),
            ),
            BlocBuilder<TvPopularBloc, TvPopularState>(
              builder: (context, state) {
                if (state is TvPopularLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is TvPopularHasData) {
                  return TvList(state.result);
                } else if (state is TvPopularError) {
                  return Center(
                    child: Text(state.message),
                  );
                } else {
                  return Text('Failed to load');
                }
              },
            ),
            SubHeading(
              title: 'Top Rated Series',
              onTap: () =>
                  Navigator.pushNamed(context, TopRatedTvPage.ROUTE_NAME),
            ),
            BlocBuilder<TvTopRatedBloc, TvTopRatedState>(
              builder: (context, state) {
                if (state is TvTopRatedLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is TvTopRatedHasData) {
                  return TvList(state.result);
                } else if (state is TvTopRatedError) {
                  return Center(
                    child: Text(state.message),
                  );
                } else {
                  return Text('Failed to load');
                }
              },
            ),
          ],
        )),
      ),
    );
  }
}

class TvList extends StatelessWidget {
  final List<TvSeries> tvSeries;

  TvList(this.tvSeries);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final tv = tvSeries[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  TvDetailPage.ROUTE_NAME,
                  arguments: tv.id,
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$BASE_IMAGE_URL${tv.posterPath}',
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: tvSeries.length,
      ),
    );
  }
}
