part of 'map_page.dart';

class _LoadErrorInfo extends StatelessWidget {
  const _LoadErrorInfo({required this.mapCubit});

  final MapCubit mapCubit;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Brak dostępu do lokalizacji'),
          ElevatedButton(
            onPressed: mapCubit.loadUserLocation,
            child: const Text('Spróbuj ponownie'),
          ),
        ],
      ),
    );
  }
}
