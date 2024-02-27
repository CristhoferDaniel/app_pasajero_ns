import 'package:app_pasajero_ns/data/models/travel_info.dart';
import 'package:app_pasajero_ns/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';

class TravelInfoProvider {
  CollectionReference? _ref;

  TravelInfoProvider() {
    _ref = FirebaseFirestore.instance.collection('TravelInfo');
  }

  final getOptions = GetOptions(source: Source.server);

  Stream<DocumentSnapshot> getByIdStreamWithMetaChanges(String id) {
    return _ref!.doc(id).snapshots(includeMetadataChanges: true);
  }

  Future<TravelInfo?> getByUidClient(String uidClient) async {
    DocumentSnapshot document = await _ref!.doc(uidClient).get(getOptions);
    if (document.exists) {
      TravelInfo travelInfo =
          TravelInfo.fromJson(document.data()! as Map<String, dynamic>);
      return travelInfo;
    } else {
      return null;
    }
  }

  final DioClient _dioClient = Get.find<DioClient>();
  final String _endpoint = '/servicio';

  Future<void> putRatingDriver(int id, double calificacion) async {
    String? errorMessage;
    try {
      final resp = await _dioClient.put(
          '$_endpoint/calificacionconductor?id=$id&calificacion=$calificacion');
      return resp;
    } catch (e) {
      return null;
    }
  }

  /* Future<TravelInfo?> getById(String id) async {
    DocumentSnapshot document =
        await _ref!.doc(id).get(GetOptions(source: source));
    if (document.exists) {
      TravelInfo travelInfo =
          TravelInfo.fromJson(document.data()! as Map<String, dynamic>);
      return travelInfo;
    } else {
      return null;
    }
  } */

  Future<void> create(TravelInfo travelInfo) async {
    String? errorMessage;

    try {
      return _ref!.doc(travelInfo.uidClient).set(
            travelInfo.toJson(),
          );
    } on FirebaseException catch (e) {
      errorMessage = e.message;
    } catch (e) {
      errorMessage = 'Hubo un error desconocido';
    }

    if (errorMessage != null) {
      return Future.error(errorMessage);
    }
  }

  Future<void> update(User user, Map<String, dynamic> data, String id) {
    if (user.uid != id) {
      print('no es el dueño');
      if (!data.containsKey('hash')) {
        throw BusinessException(
            'El update se está enviando sin el hashTravel (hash)');
      }
    }
    return _ref!.doc(id).update(data);
  }

  Future<void> setCodeValidated(bool isCodeValid, String id) {
    final data = {'codeValidated': isCodeValid};
    return _ref!.doc(id).update(data);
  }

  Future<void> delete(String id) {
    return _ref!.doc(id).delete();
  }
}
