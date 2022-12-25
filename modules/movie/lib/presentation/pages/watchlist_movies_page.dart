import 'package:core/common/utils.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/presentation/bloc/watchlist_movies/watchlist_movies_bloc.dart';
import 'package:tvseries/presentation/pages/watchlist_tv_page.dart';

import '../widget/movie_card_list.dart';

class WatchlistMoviesPage extends StatefulWidget {
  static const ROUTE_NAME = '/watchlist-movie';

  @override
  _WatchlistMoviesPageState createState() => _WatchlistMoviesPageState();
}

class _WatchlistMoviesPageState extends State<WatchlistMoviesPage>
    with RouteAware {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => BlocProvider.of<WatchlistMoviesBloc>(context, listen: false)
          .add(FetchWatchlistMovies()),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  void didPopNext() {
    BlocProvider.of<WatchlistMoviesBloc>(context, listen: false)
        .add(FetchWatchlistMovies());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Watchlist'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BlocBuilder<WatchlistMoviesBloc, WatchlistMoviesState>(
            builder: (context, state) {
              if (state is WatchlistMoviesLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is WatchlistMoviesHasData) {
                return ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final movie = state.result[index];
                    return MovieCard(movie);
                  },
                  itemCount: state.result.length,
                );
              } else if (state is WatchlistMoviesError) {
                return Center(
                  key: Key('error_message'),
                  child: Text(state.message),
                );
              } else {
                return Container();
              }
            },
          ),
        ));
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }
}
