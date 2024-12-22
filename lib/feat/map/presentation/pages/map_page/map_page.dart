import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:task/feat/map/presentation/cubit/map_cubit.dart';

part '_action_buttons.dart';
part '_map.dart';
part '_load_error_info.dart';

class MapPage extends StatefulWidget {
  const MapPage({
    super.key,
    required this.mapCubit,
  });

  static const routeName = '/map';

  final MapCubit mapCubit;

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final _mapController = MapController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => widget.mapCubit..loadUserLocation(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Mapa z Poligonami')),
        body: BlocBuilder<MapCubit, MapState>(builder: (context, state) {
          if (state.isLoading) return const Center(child: CircularProgressIndicator());
          if (state.userLocation == null) return _LoadErrorInfo(mapCubit: widget.mapCubit);

          return Stack(
            children: [
              _Map(mapController: _mapController, state: state),
              _ActionButtons(mapController: _mapController, state: state),
            ],
          );
        }),
      ),
    );
  }
}
