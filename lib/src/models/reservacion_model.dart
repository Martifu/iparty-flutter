import 'dart:convert';

ReservacionModel reservacionModelFromJson(String str) => ReservacionModel.fromJson(json.decode(str));

String reservacionModelToJson(ReservacionModel data) => json.encode(data.toJson());


class Reservaciones {
 
    List<ReservacionModel> items = new List();

    Reservaciones();  

    Reservaciones.fromJsonList(List<dynamic> jsonList){
      if (jsonList==null) return;

      for (var item in jsonList) {
        final negocio = new ReservacionModel.fromJson(item);
          items.add(negocio); 
      }
    }

}

class ReservacionModel {
    ReservacionModel({
        this.id,
        this.idUsuario,
        this.idNegocio,
        this.dia,
        this.confirmacion,
        this.personas,
        this.zona,
        this.negocio,
    });

    int id;
    int idUsuario;
    int idNegocio;
    DateTime dia;
    String confirmacion;
    int personas;
    String zona;
    Negocio negocio;

    factory ReservacionModel.fromJson(Map<String, dynamic> json) => ReservacionModel(
        id: json["id"],
        idUsuario: json["id_usuario"],
        idNegocio: json["id_negocio"],
        dia: DateTime.parse(json["dia"]),
        confirmacion: json["confirmacion"],
        personas: json["personas"],
        zona: json["zona"],
        negocio: Negocio.fromJson(json["negocio"]),
    );


    Map<String, dynamic> toJson() => {
        "id": id,
        "id_usuario": idUsuario,
        "id_negocio": idNegocio,
        "dia": dia.toIso8601String(),
        "confirmacion": confirmacion,
        "personas": personas,
        "zona": zona,
        "negocio": negocio.toJson(),
    };
}

class Negocio {
    Negocio({
        this.id,
        this.foto,
        this.nombre,
        this.ubicacion,
        this.informacion,
        this.lat,
        this.lng,
        this.idCategoria,
        this.createdAt,
        this.updatedAt,
        this.popularidad,
    });

    int id;
    String foto;
    String nombre;
    String ubicacion;
    String informacion;
    double lat;
    double lng;
    int idCategoria;
    dynamic createdAt;
    DateTime updatedAt;
    int popularidad;

    factory Negocio.fromJson(Map<String, dynamic> json) => Negocio(
        id: json["id"],
        foto: json["foto"],
        nombre: json["nombre"],
        ubicacion: json["ubicacion"],
        informacion: json["informacion"],
        lat: json["lat"].toDouble(),
        lng: json["lng"].toDouble(),
        idCategoria: json["id_categoria"],
        createdAt: json["created_at"],
        updatedAt: DateTime.parse(json["updated_at"]),
        popularidad: json["popularidad"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "foto": foto,
        "nombre": nombre,
        "ubicacion": ubicacion,
        "informacion": informacion,
        "lat": lat,
        "lng": lng,
        "id_categoria": idCategoria,
        "created_at": createdAt,
        "updated_at": updatedAt.toIso8601String(),
        "popularidad": popularidad,
    };
}
