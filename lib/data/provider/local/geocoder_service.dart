/* import 'package:geocoder/geocoder.dart';
import 'package:geocoder/services/base.dart';

class GeocoderService {
  Geocoding geocoding = Geocoder.local;

  Future<List<Address>> findAddressesFromCoordinates(
      double latitude, double longitude) async {
    var results = await geocoding
        .findAddressesFromCoordinates(new Coordinates(latitude, longitude));
    return results;
  }
} */
