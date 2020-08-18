import 'dart:convert';

List<Message> mensajesModelFromJson(String str) => List<Message>.from(json.decode(str).map((x) => Message.fromJson(x)));

String mensajesModelToJson(List<Message> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Mensajes {
 
    List<Message> items = new List();

    Mensajes();  

    Mensajes.fromJsonList(List<dynamic> jsonList){
      if (jsonList==null) return;

      for (var item in jsonList) {
          final negocio = new Message.fromJson(item);
          items.add(negocio); 
        
      }
    }

}

class Message {
  final int idnegocio,to, from,conversacion;
  final String  nombre, mensaje, foto,   idsocket;
  final DateTime createdAt;

  Message({this.createdAt, this.from, this.to, this.nombre, this.mensaje, this.foto, this.idnegocio, this.conversacion, this.idsocket});

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        conversacion:int.parse(json["conversacion"]),
        to: int.parse(json["to"]),
        from: int.parse(json["from"]),
        mensaje: json["mensaje"],
        idnegocio: int.parse(json["idnegocio"]),
        foto: json["foto"],
        nombre:json["nombre"],
    );

    Map<String, dynamic> toJson() => {
        "conversacion": conversacion,
        "to": to,
        "from": from,
        "mensaje": mensaje,
        "idnegocio": idnegocio,
        "foto": foto,
        "nombre": nombre,
    };
}