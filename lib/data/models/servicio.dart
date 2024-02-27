// To parse this JSON data, do
//
//     final servicioResponse = servicioResponseFromJson(jsonString);

import 'dart:convert';

ServicioResponse servicioResponseFromJson(String str) =>
    ServicioResponse.fromJson(json.decode(str));

String servicioResponseToJson(ServicioResponse data) =>
    json.encode(data.toJson());

class ServicioResponse {
  ServicioResponse({
    required this.success,
    this.data,
  });

  bool success;
  ServicioDto? data;

  factory ServicioResponse.fromJson(Map<String, dynamic> json) =>
      ServicioResponse(
        success: json["success"],
        data: ServicioDto.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data?.toJson(),
      };
}

class ServicioDto {
  ServicioDto({
    required this.idServicio,
    this.fechaSalida,
    this.horaSalida,
    this.fechaLlegada,
    this.horaLlegada,
    this.costo,
    this.descuento,
    this.total,
    this.idVehiculo,
    this.idRuta,
    this.idRutaFinal,
    this.idTipoServicio,
    this.idEstadoServicio,
    this.valoracionCliente,
    this.valoracionConductor,
    this.comentario,
    this.cantPasajeros,
    this.idSolicitud,
    this.idConductor,
    this.totalFinal,
    this.idTipoVehiculo,
    this.cantAdultosPasajeros,
    this.cantNinosPasajeros,
    this.cantBebesPasajeros,
    this.cantMaletasGrandes,
    this.cantMaletasMedianas,
    this.cantMochilas,
  });

  final int idServicio;
  DateTime? fechaSalida;
  final String? horaSalida;
  DateTime? fechaLlegada;
  final String? horaLlegada;
  final double? costo;
  final int? descuento;
  final int? total;
  int? idVehiculo;
  final int? idRuta;
  final int? idRutaFinal;
  final int? idTipoServicio;
  int? idEstadoServicio;
  final int? valoracionCliente;
  final int? valoracionConductor;
  String? comentario;
  int? cantPasajeros;
  final int? idSolicitud;
  int? idConductor;
  final int? totalFinal;
  int? idTipoVehiculo;
  int? cantAdultosPasajeros;
  int? cantNinosPasajeros;
  int? cantBebesPasajeros;
  int? cantMaletasGrandes;
  int? cantMaletasMedianas;
  int? cantMochilas;

  ServicioDto copyWith({
    int? idServicio,
    DateTime? fechaSalida,
    String? horaSalida,
    DateTime? fechaLlegada,
    String? horaLlegada,
    double? costo,
    int? descuento,
    int? total,
    int? idVehiculo,
    int? idRuta,
    int? idRutaFinal,
    int? idTipoServicio,
    int? idEstadoServicio,
    int? valoracionCliente,
    int? valoracionConductor,
    String? comentario,
    int? cantPasajeros,
    int? idSolicitud,
    int? idConductor,
    int? totalFinal,
    int? idTipoVehiculo,
    int? cantAdultosPasajeros,
    int? cantNinosPasajeros,
    int? cantBebesPasajeros,
    int? cantMaletasGrandes,
    int? cantMaletasMedianas,
    int? cantMochilas,
  }) =>
      ServicioDto(
        idServicio: idServicio ?? this.idServicio,
        fechaSalida: fechaSalida ?? this.fechaSalida,
        horaSalida: horaSalida ?? this.horaSalida,
        fechaLlegada: fechaLlegada ?? this.fechaLlegada,
        horaLlegada: horaLlegada ?? this.horaLlegada,
        costo: costo ?? this.costo,
        descuento: descuento ?? this.descuento,
        total: total ?? this.total,
        idVehiculo: idVehiculo ?? this.idVehiculo,
        idRuta: idRuta ?? this.idRuta,
        idRutaFinal: idRutaFinal ?? this.idRutaFinal,
        idTipoServicio: idTipoServicio ?? this.idTipoServicio,
        idEstadoServicio: idEstadoServicio ?? this.idEstadoServicio,
        valoracionCliente: valoracionCliente ?? this.valoracionCliente,
        valoracionConductor: valoracionConductor ?? this.valoracionConductor,
        comentario: comentario ?? this.comentario,
        cantPasajeros: cantPasajeros ?? this.cantPasajeros,
        idSolicitud: idSolicitud ?? this.idSolicitud,
        idConductor: idConductor ?? this.idConductor,
        totalFinal: totalFinal ?? this.totalFinal,
        idTipoVehiculo: idTipoVehiculo ?? this.idTipoVehiculo,
        cantAdultosPasajeros: cantAdultosPasajeros ?? this.cantAdultosPasajeros,
        cantNinosPasajeros: cantNinosPasajeros ?? this.cantNinosPasajeros,
        cantBebesPasajeros: cantBebesPasajeros ?? this.cantBebesPasajeros,
        cantMaletasGrandes: cantMaletasGrandes ?? this.cantMaletasGrandes,
        cantMaletasMedianas: cantMaletasMedianas ?? this.cantMaletasMedianas,
        cantMochilas: cantMochilas ?? this.cantMochilas,
      );

  factory ServicioDto.fromJson(Map<String, dynamic> json) => ServicioDto(
        idServicio: json["idServicio"],
        fechaSalida: json["fechaSalida"] != null
            ? DateTime.parse(json["fechaSalida"])
            : null,
        horaSalida: json["horaSalida"],
        fechaLlegada: json["fechaLlegada"] != null
            ? DateTime.parse(json["fechaLlegada"])
            : null,
        horaLlegada: json["horaLlegada"],
        costo: json["costo"]?.toDouble(),
        descuento: json["descuento"],
        total: json["total"],
        idVehiculo: json["idVehiculo"],
        idRuta: json["idRuta"],
        idRutaFinal: json["idRutaFinal"],
        idTipoServicio: json["idTipoServicio"],
        idEstadoServicio: json["idEstadoServicio"],
        valoracionCliente: json["valoracionCliente"],
        valoracionConductor: json["valoracionConductor"],
        comentario: json["comentario"],
        cantPasajeros: json["cantPasajeros"],
        idSolicitud: json["idSolicitud"],
        idConductor: json["idConductor"],
        totalFinal: json["totalFinal"],
        idTipoVehiculo: json["idTipoVehiculo"],
        cantAdultosPasajeros: json["cantAdultosPasajeros"],
        cantNinosPasajeros: json["cantNinosPasajeros"],
        cantBebesPasajeros: json["cantBebesPasajeros"],
        cantMaletasGrandes: json["cantMaletasGrandes"],
        cantMaletasMedianas: json["cantMaletasMedianas"],
        cantMochilas: json["cantMochilas"],
      );

  Map<String, dynamic> toJson() => {
        "idServicio": idServicio,
        "fechaSalida": fechaSalida?.toIso8601String(),
        "horaSalida": horaSalida,
        "fechaLlegada": fechaLlegada?.toIso8601String(),
        "horaLlegada": horaLlegada,
        "costo": costo,
        "descuento": descuento,
        "total": total,
        "idVehiculo": idVehiculo,
        "idRuta": idRuta,
        "idRutaFinal": idRutaFinal,
        "idTipoServicio": idTipoServicio,
        "idEstadoServicio": idEstadoServicio,
        "valoracionCliente": valoracionCliente,
        "valoracionConductor": valoracionConductor,
        "comentario": comentario,
        "cantPasajeros": cantPasajeros,
        "idSolicitud": idSolicitud,
        "idConductor": idConductor,
        "totalFinal": totalFinal,
        "idTipoVehiculo": idTipoVehiculo,
        "cantAdultosPasajeros": cantAdultosPasajeros,
        "cantNinosPasajeros": cantNinosPasajeros,
        "cantBebesPasajeros": cantBebesPasajeros,
        "cantMaletasGrandes": cantMaletasGrandes,
        "cantMaletasMedianas": cantMaletasMedianas,
        "cantMochilas": cantMochilas,
      };
}

// *******************************************
// ********************************************
// To parse this JSON data, do
//
//     final servicioListResponse = servicioListResponseFromJson(jsonString);

ServicioListResponse servicioListResponseFromJson(String str) =>
    ServicioListResponse.fromJson(json.decode(str));

String servicioListResponseToJson(ServicioListResponse data) =>
    json.encode(data.toJson());

class ServicioListResponse {
  ServicioListResponse({
    required this.pageNumber,
    required this.pageSize,
    required this.numberOfElements,
    required this.totalElements,
    required this.content,
  });

  final int pageNumber;
  final int pageSize;
  final int numberOfElements;
  final int totalElements;
  final List<ServicioModel> content;

  factory ServicioListResponse.fromJson(Map<String, dynamic> json) =>
      ServicioListResponse(
        pageNumber: json["pageNumber"],
        pageSize: json["pageSize"],
        numberOfElements: json["numberOfElements"],
        totalElements: json["totalElements"],
        content: List<ServicioModel>.from(
            json["content"].map((x) => ServicioModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "pageNumber": pageNumber,
        "pageSize": pageSize,
        "numberOfElements": numberOfElements,
        "totalElements": totalElements,
        "content": List<dynamic>.from(content.map((x) => x.toJson())),
      };
}

class ServicioModel {
  ServicioModel({
    required this.idServicio,
    required this.fechaSalida,
    required this.horaSalida,
    required this.fechaLlegada,
    required this.horaLlegada,
    required this.costo,
    required this.descuento,
    required this.total,
    this.idVehiculo,
    required this.idRuta,
    this.idRutaFinal,
    required this.idTipoServicio,
    required this.idEstadoServicio,
    required this.valoracionCliente,
    required this.valoracionConductor,
    this.comentario,
    this.cantPasajeros,
    required this.idSolicitud,
    this.idConductor,
    required this.totalFinal,
    this.idTipoVehiculo,
    this.cantAdultosPasajeros,
    this.cantNinosPasajeros,
    this.cantBebesPasajeros,
    this.cantMaletasGrandes,
    this.cantMaletasMedianas,
    this.cantMochilas,
    this.ruta,
    this.tipoServicio,
    // this.rutaFinal,
    // this.conductor,
  });

  final int idServicio;
  final DateTime fechaSalida;
  final String horaSalida;
  final DateTime fechaLlegada;
  final String horaLlegada;
  final double costo;
  final int descuento;
  final int total;
  final int? idVehiculo;
  final int idRuta;
  final int? idRutaFinal;
  final int idTipoServicio;
  final int idEstadoServicio;
  final int valoracionCliente;
  final int valoracionConductor;
  String? comentario;
  int? cantPasajeros;
  final int idSolicitud;
  final int? idConductor;
  final int totalFinal;
  int? idTipoVehiculo;
  int? cantAdultosPasajeros;
  int? cantNinosPasajeros;
  int? cantBebesPasajeros;
  int? cantMaletasGrandes;
  int? cantMaletasMedianas;
  int? cantMochilas;
  final Ruta? ruta;
  final TipoServicio? tipoServicio;
  // final dynamic rutaFinal;
  // final dynamic conductor;

  factory ServicioModel.fromJson(Map<String, dynamic> json) => ServicioModel(
        idServicio: json["idServicio"],
        fechaSalida: DateTime.parse(json["fechaSalida"]),
        horaSalida: json["horaSalida"],
        fechaLlegada: DateTime.parse(json["fechaLlegada"]),
        horaLlegada: json["horaLlegada"],
        costo: json["costo"].toDouble(),
        descuento: json["descuento"],
        total: json["total"],
        idVehiculo: json["idVehiculo"],
        idRuta: json["idRuta"],
        idRutaFinal: json["idRutaFinal"],
        idTipoServicio: json["idTipoServicio"],
        idEstadoServicio: json["idEstadoServicio"],
        valoracionCliente: json["valoracionCliente"],
        valoracionConductor: json["valoracionConductor"],
        comentario: json["comentario"],
        cantPasajeros: json["cantPasajeros"],
        idSolicitud: json["idSolicitud"],
        idConductor: json["idConductor"],
        totalFinal: json["totalFinal"],
        idTipoVehiculo: json["idTipoVehiculo"],
        cantAdultosPasajeros: json["cantAdultosPasajeros"],
        cantNinosPasajeros: json["cantNinosPasajeros"],
        cantBebesPasajeros: json["cantBebesPasajeros"],
        cantMaletasGrandes: json["cantMaletasGrandes"],
        cantMaletasMedianas: json["cantMaletasMedianas"],
        cantMochilas: json["cantMochilas"],
        ruta: json["ruta"] == null ? null : Ruta.fromJson(json["ruta"]),
        tipoServicio: json["tipoServicio"] == null
            ? null
            : TipoServicio.fromJson(json["tipoServicio"]),
        // rutaFinal: json["rutaFinal"],
        // conductor: json["conductor"],
      );

  Map<String, dynamic> toJson() => {
        "idServicio": idServicio,
        "fechaSalida": fechaSalida.toIso8601String(),
        "horaSalida": horaSalida,
        "fechaLlegada": fechaLlegada.toIso8601String(),
        "horaLlegada": horaLlegada,
        "costo": costo,
        "descuento": descuento,
        "total": total,
        "idVehiculo": idVehiculo,
        "idRuta": idRuta,
        "idRutaFinal": idRutaFinal,
        "idTipoServicio": idTipoServicio,
        "idEstadoServicio": idEstadoServicio,
        "valoracionCliente": valoracionCliente,
        "valoracionConductor": valoracionConductor,
        "comentario": comentario,
        "cantPasajeros": cantPasajeros,
        "idSolicitud": idSolicitud,
        "idConductor": idConductor,
        "totalFinal": totalFinal,
        "idTipoVehiculo": idTipoVehiculo,
        "cantAdultosPasajeros": cantAdultosPasajeros,
        "cantNinosPasajeros": cantNinosPasajeros,
        "cantBebesPasajeros": cantBebesPasajeros,
        "cantMaletasGrandes": cantMaletasGrandes,
        "cantMaletasMedianas": cantMaletasMedianas,
        "cantMochilas": cantMochilas,
        "ruta": ruta?.toJson(),
        "tipoServicio": tipoServicio?.toJson(),
        // "rutaFinal": rutaFinal,
        // "conductor": conductor,
      };
}

class Ruta {
  Ruta({
    required this.idRuta,
    required this.nombreOrigen,
    required this.nombreDestino,
    required this.distancia,
    required this.duracion,
    required this.polyline,
    required this.coordenadaOrigen,
    required this.coordenadaDestino,
  });

  final int idRuta;
  final String nombreOrigen;
  final String nombreDestino;
  final int distancia;
  final int duracion;
  final String polyline;
  final String coordenadaOrigen;
  final String coordenadaDestino;

  factory Ruta.fromJson(Map<String, dynamic> json) => Ruta(
        idRuta: json["idRuta"],
        nombreOrigen: json["nombreOrigen"],
        nombreDestino: json["nombreDestino"],
        distancia: json["distancia"],
        duracion: json["duracion"],
        polyline: json["polyline"],
        coordenadaOrigen: json["coordenadaOrigen"],
        coordenadaDestino: json["coordenadaDestino"],
      );

  Map<String, dynamic> toJson() => {
        "idRuta": idRuta,
        "nombreOrigen": nombreOrigen,
        "nombreDestino": nombreDestino,
        "distancia": distancia,
        "duracion": duracion,
        "polyline": polyline,
        "coordenadaOrigen": coordenadaOrigen,
        "coordenadaDestino": coordenadaDestino,
      };
}

class TipoServicio {
  TipoServicio({
    required this.idTipoServicio,
    required this.nombre,
    required this.enable,
  });

  final int idTipoServicio;
  final String nombre;
  final int enable;

  factory TipoServicio.fromJson(Map<String, dynamic> json) => TipoServicio(
        idTipoServicio: json["idTipoServicio"],
        nombre: json["nombre"],
        enable: json["enable"],
      );

  Map<String, dynamic> toJson() => {
        "idTipoServicio": idTipoServicio,
        "nombre": nombre,
        "enable": enable,
      };
}

ServicioList2Response servicioList2ResponseFromJson(String str) =>
    ServicioList2Response.fromJson(json.decode(str));

String servicioList2ResponseToJson(ServicioList2Response data) =>
    json.encode(data.toJson());

class ServicioList2Response {
  ServicioList2Response({
    required this.pageNumber,
    required this.pageSize,
    required this.numberOfElements,
    required this.totalElements,
    required this.content,
  });

  final int pageNumber;
  final int pageSize;
  final int numberOfElements;
  final int totalElements;
  final List<ServicioModelItem> content;

  factory ServicioList2Response.fromJson(Map<String, dynamic> json) =>
      ServicioList2Response(
        pageNumber: json["pageNumber"],
        pageSize: json["pageSize"],
        numberOfElements: json["numberOfElements"],
        totalElements: json["totalElements"],
        content: List<ServicioModelItem>.from(
            json["content"].map((x) => ServicioModelItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "pageNumber": pageNumber,
        "pageSize": pageSize,
        "numberOfElements": numberOfElements,
        "totalElements": totalElements,
        "content": List<dynamic>.from(content.map((x) => x.toJson())),
      };
}

class ServicioModelItem {
  ServicioModelItem({
    required this.idServicio,
    required this.fechaSalida,
    required this.horaSalida,
    this.fechaLlegada,
    required this.horaLlegada,
    required this.costo,
    required this.descuento,
    required this.total,
    this.idVehiculo,
    required this.idRuta,
    this.idRutaFinal,
    required this.idTipoServicio,
    required this.idEstadoServicio,
    required this.valoracionCliente,
    required this.valoracionConductor,
    this.comentario,
    this.cantPasajeros,
    required this.idSolicitud,
    this.idConductor,
    required this.totalFinal,
    this.idTipoVehiculo,
    this.cantAdultosPasajeros,
    this.cantNinosPasajeros,
    this.cantBebesPasajeros,
    this.cantMaletasGrandes,
    this.cantMaletasMedianas,
    this.cantMochilas,
    this.ruta,
    this.tipoServicio,
    // this.rutaFinal,
    // this.conductor,
  });

  final int idServicio;
  final DateTime fechaSalida;
  final String horaSalida;
  DateTime? fechaLlegada;
  final String horaLlegada;
  final num costo;
  final num descuento;
  final num total;
  final int? idVehiculo;
  final int idRuta;
  final int? idRutaFinal;
  final int idTipoServicio;
  final int idEstadoServicio;
  final int valoracionCliente;
  final int valoracionConductor;
  String? comentario;
  int? cantPasajeros;
  final int idSolicitud;
  final int? idConductor;
  final int totalFinal;
  int? idTipoVehiculo;
  int? cantAdultosPasajeros;
  int? cantNinosPasajeros;
  int? cantBebesPasajeros;
  int? cantMaletasGrandes;
  int? cantMaletasMedianas;
  int? cantMochilas;
  final Ruta? ruta;
  final TipoServicio? tipoServicio;
  // final dynamic rutaFinal;
  // final dynamic conductor;

  factory ServicioModelItem.fromJson(Map<String, dynamic> json) =>
      ServicioModelItem(
        idServicio: json["idServicio"],
        fechaSalida: DateTime.parse(json["fechaSalida"]),
        horaSalida: json["horaSalida"],
        // fechaLlegada: DateTime.parse(json["fechaLlegada"]),
        fechaLlegada: json["fechaLlegada"] == null
            ? null
            : DateTime.parse(json["fechaLlegada"]),
        horaLlegada: json["horaLlegada"],
        costo: json["costo"].toDouble(),
        descuento: json["descuento"],
        total: json["total"],
        idVehiculo: json["idVehiculo"],
        idRuta: json["idRuta"],
        idRutaFinal: json["idRutaFinal"],
        idTipoServicio: json["idTipoServicio"],
        idEstadoServicio: json["idEstadoServicio"],
        valoracionCliente: json["valoracionCliente"],
        valoracionConductor: json["valoracionConductor"],
        comentario: json["comentario"],
        cantPasajeros: json["cantPasajeros"],
        idSolicitud: json["idSolicitud"],
        idConductor: json["idConductor"],
        totalFinal: json["totalFinal"],
        idTipoVehiculo: json["idTipoVehiculo"],
        cantAdultosPasajeros: json["cantAdultosPasajeros"],
        cantNinosPasajeros: json["cantNinosPasajeros"],
        cantBebesPasajeros: json["cantBebesPasajeros"],
        cantMaletasGrandes: json["cantMaletasGrandes"],
        cantMaletasMedianas: json["cantMaletasMedianas"],
        cantMochilas: json["cantMochilas"],
        ruta: json["ruta"] == null ? null : Ruta.fromJson(json["ruta"]),
        tipoServicio: json["tipoServicio"] == null
            ? null
            : TipoServicio.fromJson(json["tipoServicio"]),
        // rutaFinal: json["rutaFinal"],
        // conductor: json["conductor"],
      );

  Map<String, dynamic> toJson() => {
        "idServicio": idServicio,
        "fechaSalida": fechaSalida.toIso8601String(),
        "horaSalida": horaSalida,
        "fechaLlegada": fechaLlegada?.toIso8601String(),
        "horaLlegada": horaLlegada,
        "costo": costo,
        "descuento": descuento,
        "total": total,
        "idVehiculo": idVehiculo,
        "idRuta": idRuta,
        "idRutaFinal": idRutaFinal,
        "idTipoServicio": idTipoServicio,
        "idEstadoServicio": idEstadoServicio,
        "valoracionCliente": valoracionCliente,
        "valoracionConductor": valoracionConductor,
        "comentario": comentario,
        "cantPasajeros": cantPasajeros,
        "idSolicitud": idSolicitud,
        "idConductor": idConductor,
        "totalFinal": totalFinal,
        "idTipoVehiculo": idTipoVehiculo,
        "cantAdultosPasajeros": cantAdultosPasajeros,
        "cantNinosPasajeros": cantNinosPasajeros,
        "cantBebesPasajeros": cantBebesPasajeros,
        "cantMaletasGrandes": cantMaletasGrandes,
        "cantMaletasMedianas": cantMaletasMedianas,
        "cantMochilas": cantMochilas,
        "ruta": ruta?.toJson(),
        "tipoServicio": tipoServicio?.toJson(),
        // "rutaFinal": rutaFinal,
        // "conductor": conductor,
      };
}
