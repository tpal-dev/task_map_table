part of 'map_page.dart';

class _ActionButtons extends StatelessWidget {
  const _ActionButtons({
    required this.mapController,
    required this.state,
  });

  final MapController mapController;
  final MapState state;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 20,
      right: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () => context.read<MapCubit>().undoLastPoint(),
            heroTag: 'undo',
            child: const Icon(Icons.undo),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () => context.read<MapCubit>().clearPolygon(),
            heroTag: 'clear',
            child: const Icon(Icons.clear),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () => context.read<MapCubit>().savePolygon(),
            heroTag: 'save',
            child: const Icon(Icons.save),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () => context.read<MapCubit>().centerOnUserLocation().then(
                  (_) => mapController.move(state.userLocation!, 15.0),
                ),
            heroTag: 'center',
            child: const Icon(Icons.my_location),
          ),
        ],
      ),
    );
  }
}
