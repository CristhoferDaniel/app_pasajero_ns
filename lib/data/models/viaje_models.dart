import 'package:app_pasajero_ns/data/models/driving_request_param.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ViajePointData {
  late DrivingRequestParamType _type;
  DrivingRequestParamType get type => _type;

  LatLng? _pointLatLng;
  LatLng? get pointLatLng => _pointLatLng;

  String? _pointPlaceId;
  String? get pointPlaceId => _pointPlaceId;

  String _pointNombre = '';
  String get pointNombre => _pointNombre;

  ViajePointData(
      {required DrivingRequestParamType type,
      String pointNombre = '',
      LatLng? pointLatLng,
      String? pointPlaceId}) {
    this._type = type;

    /* if (type == DrivingRequestParamType.latLng) {
      if (pointLatLng == null)
        throw Exception('Si type es LatLng debe asignar pointLatLng');
      this._pointLatLng = pointLatLng;
      this._pointPlaceId = null;
    } else {
      if (pointPlaceId == null)
        throw Exception('Si type es LatLng debe asignar pointLatLng');
      this._pointPlaceId = pointPlaceId;
      this._pointLatLng = null;
    } */
    this._pointLatLng = pointLatLng;
    this._pointPlaceId = pointPlaceId;
    this._pointNombre = pointNombre;
  }

  void changeToLatLng({required pointNombre, required LatLng pointLatLng}) {
    this._type = DrivingRequestParamType.latLng;
    this._pointNombre = pointNombre;
    this._pointLatLng = pointLatLng;
    this._pointPlaceId = null;
  }

  void changeToPlaceId({required pointNombre, required String pointPlaceId}) {
    this._type = DrivingRequestParamType.placeId;
    this._pointNombre = pointNombre;
    this._pointPlaceId = pointPlaceId;
    this._pointLatLng = null;
  }

  bool isComplete() {
    if (this._type == DrivingRequestParamType.latLng) {
      if (this._pointLatLng == null) {
        return false;
      }
    } else {
      if (this._pointPlaceId == null) {
        return false;
      }
    }
    return true;
  }
}
