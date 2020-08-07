// To parse this JSON data, do
//
//     final usuarioModel = usuarioModelFromJson(jsonString);

import 'dart:convert';

UsuarioInfo usuarioInfoFromJson(String str) => UsuarioInfo.fromJson(json.decode(str));

String usuarioInfoToJson(UsuarioInfo data) => json.encode(data.toJson());

class UsuarioInfo {
    UsuarioInfo({
        this.id,
        this.email,
        this.nombre,
        this.foto,
        this.fechaNacimiento,
        this.createdAt,
        this.updatedAt,
    });

    int id;
    String email;
    String nombre;
    String foto;
    DateTime fechaNacimiento;
    DateTime createdAt;
    DateTime updatedAt;

    factory UsuarioInfo.fromJson(Map<String, dynamic> json) => UsuarioInfo(
        id: json["id"],
        email: json["email"],
        nombre: json["nombre"],
        foto: json["foto"],
        fechaNacimiento: DateTime.parse(json["fecha_nacimiento"]),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "nombre": nombre,
        "foto": foto,
        "fecha_nacimiento": fechaNacimiento.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}
