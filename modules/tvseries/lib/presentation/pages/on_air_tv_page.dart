import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tvseries/presentation/bloc/tv_on_air/tv_on_air_bloc.dart';

import '../widget/tv_card.dart';

class OnAirTvPage extends StatefulWidget {
  static const ROUTE_NAME = '/onair-tv-series';

  const OnAirTvPage({Key? key}) : super(key: key);

  @override
  State<OnAirTvPage> createState() => _OnAirTvPageState();
}

class _OnAirTvPageState extends State<OnAirTvPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => BlocProvider.of<TvOnAirBloc>(context, listen: false)
          .add(FetchTvOnAir()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('On Air Tv Series'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TvOnAirBloc, TvOnAirState>(
          builder: (context, state) {
            if (state is TvOnAirLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is TvOnAirHasData) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tv = state.result[index];
                  return TvCard(tv);
                },
                itemCount: state.result.length,
              );
            } else if (state is TvOnAirError) {
              return Center(
                key: Key('error_message'),
                child: Text(state.message),
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
