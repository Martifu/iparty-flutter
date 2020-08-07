import 'dart:convert';

UsuarioModel usuarioModelFromJson(String str) => UsuarioModel.fromJson(json.decode(str));

String usuarioModelToJson(UsuarioModel data) => json.encode(data.toJson());

class UsuarioModel {
    UsuarioModel({
        this.email,
        this.nombre,
        this.apellidoP,
        this.apellidoM,
        this.foto,
        this.fechaNacimiento,
        this.password,
    });

    String email;
    String nombre;
    String apellidoP;
    String apellidoM;
    String foto;
    String fechaNacimiento;
    String password;

    factory UsuarioModel.fromJson(Map<String, dynamic> json) => UsuarioModel(
        email: json["email"],
        nombre: json["nombre"],
        apellidoP: json["apellidoP"],
        apellidoM: json["apellidoM"],
        foto: json["foto"],
        fechaNacimiento: json["fecha_nacimiento"],
        password: json["password"],
    );

    Map<String, dynamic> toJson() => {
        "email": email,
        "nombre": nombre,
        "apellidoP": apellidoP,
        "apellidoM": apellidoM,
        "foto": foto,
        "fecha_nacimiento": fechaNacimiento,
        "password": password,
    };
}
