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
  String _indexValue = 'Movie';
  List<String> _pageList = ['Movie', 'Tv Series'];

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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                icon: const Icon(Icons.arrow_downward),
                value: _indexValue,
                elevation: 16,
                style: TextStyle(color: Colors.white),
                items: _pageList
                    .map((valueItem) => DropdownMenuItem(
                          child: Text(
                            valueItem,
                            style: kHeading6,
                          ),
                          value: valueItem,
                        ))
                    .toList(),
                onChanged: (String? val) {
                  setState(() {
                    _indexValue = val!;
                  });
                },
              ),
            ),
          ),
        ],
      ),
      body: _indexValue == 'Movie'
          ? Padding(
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
            )
          : WatchlistTvPage(),
    );
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }
}
