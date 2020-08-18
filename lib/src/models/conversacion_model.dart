// To parse this JSON data, do
//
//     final conversacionModel = conversacionModelFromJson(jsonString);

import 'dart:convert';

ConversacionModel conversacionModelFromJson(String str) => ConversacionModel.fromJson(json.decode(str));

String conversacionModelToJson(ConversacionModel data) => json.encode(data.toJson());

class Conversaciones {
 
    List<Last> items = new List();

    Conversaciones();  

    Conversaciones.fromJsonList(List<dynamic> jsonList){
      if (jsonList==null) return;

      for (var item in jsonList) {
          final negocio = new Last.fromJson(item['last']);
          items.add(negocio); 
      
      }
    }

}

class ConversacionModel {
    ConversacionModel({
        this.id,
        this.last,
    });

    String id;
    Last last;

    factory ConversacionModel.fromJson(Map<String, dynamic> json) => ConversacionModel(
        id: json["_id"],
        last: Last.fromJson(json["last"]),
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "last": last.toJson(),
    };
}

class Last {
    Last({
        this.id,
        this.to,
        this.from,
        this.mensaje,
        this.idnegocio,
        this.foto,
        this.nombre,
        this.createdAt,
        this.result,
    });

    String id;
    String to;
    String from;
    String mensaje;
    String idnegocio;
    String foto;
    String nombre;
    DateTime createdAt;
    bool result;

    factory Last.fromJson(Map<String, dynamic> json) => Last(
        id: json["_id"],
        to: json["to"],
        from: json["from"],
        mensaje: json["mensaje"],
        idnegocio: json["idnegocio"],
        foto: json["foto"],
        nombre: json["nombre"],
        result: json["result"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "to": to,
        "from": from,
        "mensaje": mensaje,
        "idnegocio": idnegocio,
        "foto": foto,
        "nombre": nombre,
        "createdAt": createdAt.toIso8601String(),
        "result": result,
    };
}
