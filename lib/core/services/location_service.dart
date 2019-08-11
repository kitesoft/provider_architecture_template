import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:provider_start/core/models/user_location.dart';
import 'package:provider_start/core/services/key_storage_service.dart';
import 'package:provider_start/locator.dart';

class LocationService {
  var geolocator = Geolocator();

  final _locationController = StreamController<UserLocation>();
  Stream<UserLocation> get locationStream => _locationController.stream;

  var locationOptions = LocationOptions(
    accuracy: LocationAccuracy.high,
    distanceFilter: 10,
  );

  LocationService() {
    // Request permission to use location
    if (!locator<KeyStorageService>().locationGranted) return;

    // If granted listen to the onLocationChanged stream and emit over our controller
    geolocator.getPositionStream(locationOptions).listen((Position position) {
      if (position != null) {
        _locationController.add(UserLocation(
          latitude: position.latitude,
          longitude: position.longitude,
        ));
      }
    });
  }
}
