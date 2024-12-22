import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'dart:math' as math;
import 'package:task/core/custom_snackbar.dart';

part 'map_state.dart';

class MapCubit extends Cubit<MapState> {
  MapCubit() : super(const MapState(isLoading: true));

  Future<void> loadUserLocation() async {
    try {
      emit(state.copyWith(isLoading: true));

      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await Geolocator.openLocationSettings();
        CustomSnackbar.show(message: 'Usługi lokalizacji zostały wyłączone.');
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          CustomSnackbar.show(message: 'Brak uprawnień do lokalizacji.');
          return;
        }
      }

      Position position = await Geolocator.getCurrentPosition();
      emit(state.copyWith(
        isLoading: false,
        userLocation: LatLng(position.latitude, position.longitude),
      ));
    } catch (e) {
      CustomSnackbar.show(message: 'Błąd: ${e.toString()}');
    }
  }

  void addPoint(LatLng point) {
    if (state.userLocation != null) {
      final updatedPolygon = List<LatLng>.from(state.currentPolygon)..add(point);
      emit(state.copyWith(currentPolygon: updatedPolygon));
    }
  }

  void undoLastPoint() {
    if (state.userLocation != null && state.currentPolygon.isNotEmpty) {
      final updatedPolygon = List<LatLng>.from(state.currentPolygon)..removeLast();
      emit(state.copyWith(currentPolygon: updatedPolygon));
    }
  }

  void clearPolygon() {
    if (state.userLocation != null) {
      emit(state.copyWith(currentPolygon: []));
    }
  }

  void savePolygon() {
    if (state.userLocation != null && state.currentPolygon.length >= 3) {
      if (_isPolygonValid(state.currentPolygon)) {
        final updatedSavedPolygons = List<List<LatLng>>.from(state.savedPolygons)..add(state.currentPolygon);
        emit(state.copyWith(currentPolygon: [], savedPolygons: updatedSavedPolygons));
      } else {
        CustomSnackbar.show(message: 'Poligon jest nieprawidłowy: krawędzie przecinają się.');
      }
    } else {
      CustomSnackbar.show(message: 'Poligon musi mieć co najmniej 3 punkty.');
    }
  }

  Future<void> centerOnUserLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition();
      emit(state.copyWith(
        userLocation: LatLng(position.latitude, position.longitude),
      ));
    } catch (e) {
      CustomSnackbar.show(message: 'Błąd centrowania: ${e.toString()}');
    }
  }

  bool _isPolygonValid(List<LatLng> polygon) {
    bool edgesIntersect(LatLng a, LatLng b, LatLng c, LatLng d) {
      // Funkcja pomocnicza do sprawdzania, czy dwie linie się przecinają
      double crossProduct(LatLng p, LatLng q, LatLng r) {
        return (q.latitude - p.latitude) * (r.longitude - p.longitude) -
            (q.longitude - p.longitude) * (r.latitude - p.latitude);
      }

      bool isOnSegment(LatLng p, LatLng q, LatLng r) {
        return q.latitude <= math.max(p.latitude, r.latitude) &&
            q.latitude >= math.min(p.latitude, r.latitude) &&
            q.longitude <= math.max(p.longitude, r.longitude) &&
            q.longitude >= math.min(p.longitude, r.longitude);
      }

      double d1 = crossProduct(a, b, c);
      double d2 = crossProduct(a, b, d);
      double d3 = crossProduct(c, d, a);
      double d4 = crossProduct(c, d, b);

      if (d1 * d2 < 0 && d3 * d4 < 0) return true;

      if (d1 == 0 && isOnSegment(a, c, b)) return true;
      if (d2 == 0 && isOnSegment(a, d, b)) return true;
      if (d3 == 0 && isOnSegment(c, a, d)) return true;
      if (d4 == 0 && isOnSegment(c, b, d)) return true;

      return false;
    }

    if (polygon.length < 3) return false;

    // Sprawdź, czy krawędzie się przecinają
    for (int i = 0; i < polygon.length; i++) {
      for (int j = i + 2; j < polygon.length; j++) {
        // Ignorujemy sąsiadujące krawędzie i zamykające krawędzie
        if (i == 0 && j == polygon.length - 1) continue;

        if (edgesIntersect(polygon[i], polygon[i + 1], polygon[j], polygon[(j + 1) % polygon.length])) {
          return false;
        }
      }
    }
    return true;
  }
}
