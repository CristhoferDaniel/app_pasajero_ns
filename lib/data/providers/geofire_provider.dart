import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';

class GeofireProvider {
  CollectionReference? _ref;
  final GeoFlutterFire _geo = GeoFlutterFire();

  GeofireProvider() {
    _ref = FirebaseFirestore.instance.collection('Locations');
  }

  final getOptions = GetOptions(source: Source.server);

  Stream<List<DocumentSnapshot>> getNearbyDriversStream(
      double lat, double lng, double kmRadius) {
    GeoFirePoint center = _geo.point(latitude: lat, longitude: lng);
    return _geo
        .collection(
            collectionRef:
                _ref!.where('status', isEqualTo: 'drivers_available'))
        .within(center: center, radius: kmRadius, field: 'position');
  }

  Future<List<DocumentSnapshot>> getNearbyDriversList(
      double lat, double lng, double kmRadius) async {
    GeoFirePoint center = _geo.point(latitude: lat, longitude: lng);

    return await _geo
        .collection(
            collectionRef:
                _ref!.where('status', isEqualTo: 'drivers_available'))
        .within(center: center, radius: kmRadius, field: 'position')
        .first;
  }

  Future<DocumentSnapshot> getLocationById(String id) async {
    DocumentSnapshot document = await _ref!.doc(id).get(getOptions);
    return document;
  }

  Stream<DocumentSnapshot> getLocationByIdStreamWithMetadata(String id) {
    return _ref!.doc(id).snapshots(includeMetadataChanges: true);
  }

  Future<bool> checkIfDriverExists(String id) async {
    DocumentSnapshot document = await _ref!.doc(id).get();
    return document.exists;
  }

  Future<void> create(String id, double lat, double lng, double heading) {
    GeoFirePoint myLocation = _geo.point(latitude: lat, longitude: lng);
    return _ref!.doc(id).set({
      'heading': '$heading',
      'lastUpdate': FieldValue.serverTimestamp(),
      'position': myLocation.data,
      'serviceNow': null,
      'status': 'drivers_available',
    });
  }

  Future<void> updateOnlyLocation(
      String id, double lat, double lng, double heading) {
    GeoFirePoint myLocation = _geo.point(latitude: lat, longitude: lng);
    return _ref!.doc(id).update({
      'heading': '$heading',
      'lastUpdate': FieldValue.serverTimestamp(),
      'position': myLocation.data,
    });
  }

  Future<void> createWorking(
      String id, double lat, double lng, double heading, String serviceNow) {
    GeoFirePoint myLocation = _geo.point(latitude: lat, longitude: lng);
    return _ref!.doc(id).set({
      'heading': '$heading',
      'lastUpdate': FieldValue.serverTimestamp(),
      'position': myLocation.data,
      'serviceNow': serviceNow,
      'status':
          'drivers_available', // cambiar luego  o evaluar 'drivers_working'
    });
  }

  Future<void> delete(String id) {
    return _ref!.doc(id).delete();
  }
}
