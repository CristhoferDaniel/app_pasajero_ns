import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GeocodingService {
  Future<String> getAddressName(LatLng coords) async {
    try {
      final resp =
          await placemarkFromCoordinates(coords.latitude, coords.longitude);
      // await Future.delayed(Duration(seconds: 5));
      if (resp.isNotEmpty && resp.first.street != null) {
        final String nomCalle = resp.first.street!;
        return (nomCalle == 'Unnamed Road') ? 'Calle S/N' : nomCalle;
      } else {
        return 'Dirección S/N';
      }
    } catch (e) {
      // Helpers.logger.e('No se pudo obtener el nombre de calle.');
      // Helpers.logger.e(e.toString());
      return 'Dirección S/N';
    }
  }
}
