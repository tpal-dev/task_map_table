part of 'map_page.dart';

class _Map extends StatelessWidget {
  const _Map({
    required this.mapController,
    required this.state,
  });

  final MapController mapController;
  final MapState state;

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        initialCenter: state.userLocation!,
        initialZoom: 15.0,
        onTap: (tapPosition, point) => context.read<MapCubit>().addPoint(point),
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.task.flutter_map.example',
        ),
        CurrentLocationLayer(),
        PolygonLayer(
          polygons: [
            if (state.currentPolygon.length >= 2)
              Polygon(
                points: state.currentPolygon,
                color: Colors.blue.withValues(alpha: 0.4),
                borderColor: Colors.blue,
                borderStrokeWidth: 2,
              ),
            ...state.savedPolygons.map(
              (polygon) => Polygon(
                points: polygon,
                color: Colors.green.withValues(alpha: 0.4),
                borderColor: Colors.green,
                borderStrokeWidth: 2,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
