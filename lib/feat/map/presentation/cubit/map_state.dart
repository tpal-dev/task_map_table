part of 'map_cubit.dart';

/// Na co dzień używam freezed, ale w tym zadaniu chciałem ograniczyć liczbę dodatkowych paczek i uniknąć korzystania z build_runner.
class MapState extends Equatable {
  final bool isLoading;
  final LatLng? userLocation;
  final List<LatLng> currentPolygon;
  final List<List<LatLng>> savedPolygons;

  const MapState({
    this.isLoading = false,
    this.userLocation,
    this.currentPolygon = const [],
    this.savedPolygons = const [],
  });

  @override
  List<Object?> get props => [
        isLoading,
        userLocation,
        currentPolygon,
        savedPolygons,
      ];

  MapState copyWith({
    bool? isLoading,
    LatLng? userLocation,
    List<LatLng>? currentPolygon,
    List<List<LatLng>>? savedPolygons,
  }) {
    return MapState(
      isLoading: isLoading ?? this.isLoading,
      userLocation: userLocation ?? this.userLocation,
      currentPolygon: currentPolygon ?? this.currentPolygon,
      savedPolygons: savedPolygons ?? this.savedPolygons,
    );
  }
}
