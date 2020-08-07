// To parse this JSON data, do
//
//     final negociocategoriasModel = negociocategoriasModelFromJson(jsonString);

import 'dart:convert';

NegociocategoriasModel negociocategoriasModelFromJson(String str) => NegociocategoriasModel.fromJson(json.decode(str));

String negociocategoriasModelToJson(NegociocategoriasModel data) => json.encode(data.toJson());

class NegociocategoriasModel {
    NegociocategoriasModel({
        this.categoria,
    });

    List<Catego> categoria;

    factory NegociocategoriasModel.fromJson(Map<String, dynamic> json) => NegociocategoriasModel(
        categoria: List<Catego>.from(json["Catego"].map((x) => Catego.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "Catego": List<dynamic>.from(categoria.map((x) => x.toJson())),
    };
}

class Catego {
    Catego({
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
        this.comentarios,
        this.fotos,
        this.horarios,
        this.categoriaNegocio,
        this.menu,
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
    dynamic updatedAt;
    int popularidad;
    List<Comentario> comentarios;
    List<Foto> fotos;
    List<Horario> horarios;
    Categoria categoriaNegocio;
    List<Menu> menu;

    factory Catego.fromJson(Map<String, dynamic> json) => Catego(
        id: json["id"],
        foto: json["foto"],
        nombre: json["nombre"],
        ubicacion: json["ubicacion"],
        informacion: json["informacion"],
        lat: json["lat"].toDouble(),
        lng: json["lng"].toDouble(),
        idCategoria: json["id_categoria"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        popularidad: json["popularidad"],
        comentarios: List<Comentario>.from(json["comentarios"].map((x) => Comentario.fromJson(x))),
        fotos: List<Foto>.from(json["fotos"].map((x) => Foto.fromJson(x))),
        horarios: List<Horario>.from(json["horarios"].map((x) => Horario.fromJson(x))),
        categoriaNegocio: Categoria.fromJson(json["categoria_negocio"]),
        menu: List<Menu>.from(json["menu"].map((x) => Menu.fromJson(x))),
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
        "updated_at": updatedAt,
        "popularidad": popularidad,
        "comentarios": List<dynamic>.from(comentarios.map((x) => x.toJson())),
        "fotos": List<dynamic>.from(fotos.map((x) => x.toJson())),
        "horarios": List<dynamic>.from(horarios.map((x) => x.toJson())),
        "categoria_negocio": categoriaNegocio.toJson(),
        "menu": List<dynamic>.from(menu.map((x) => x.toJson())),
    };
}

class Categoria {
    Categoria({
        this.id,
        this.categoria,
        this.createdAt,
        this.updatedAt,
        this.nombre,
    });

    int id;
    String categoria;
    dynamic createdAt;
    dynamic updatedAt;
    String nombre;

    factory Categoria.fromJson(Map<String, dynamic> json) => Categoria(
        id: json["id"],
        categoria: json["categoria"] == null ? null : json["categoria"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        nombre: json["nombre"] == null ? null : json["nombre"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "categoria": categoria == null ? null : categoria,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "nombre": nombre == null ? null : nombre,
    };
}

class Comentario {
    Comentario({
        this.id,
        this.idNegocio,
        this.idUsuario,
        this.comentario,
        this.calificacion,
        this.createdAt,
        this.updatedAt,
        this.usuario,
    });

    int id;
    int idNegocio;
    int idUsuario;
    String comentario;
    int calificacion;
    dynamic createdAt;
    dynamic updatedAt;
    Usuario usuario;

    factory Comentario.fromJson(Map<String, dynamic> json) => Comentario(
        id: json["id"],
        idNegocio: json["id_negocio"],
        idUsuario: json["id_usuario"],
        comentario: json["comentario"],
        calificacion: json["calificacion"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        usuario: Usuario.fromJson(json["usuario"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "id_negocio": idNegocio,
        "id_usuario": idUsuario,
        "comentario": comentario,
        "calificacion": calificacion,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "usuario": usuario.toJson(),
    };
}

class Usuario {
    Usuario({
        this.id,
        this.email,
        this.nombre,
        this.foto,
        this.fechaNacimiento,
        this.createdAt,
        this.updatedAt,
    });

    int id;
    Email email;
    Nombre nombre;
    String foto;
    DateTime fechaNacimiento;
    DateTime createdAt;
    DateTime updatedAt;

    factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
        id: json["id"],
        email: emailValues.map[json["email"]],
        nombre: nombreValues.map[json["nombre"]],
        foto: json["foto"],
        fechaNacimiento: DateTime.parse(json["fecha_nacimiento"]),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "email": emailValues.reverse[email],
        "nombre": nombreValues.reverse[nombre],
        "foto": foto,
        "fecha_nacimiento": fechaNacimiento.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}

enum Email { ADMIN_ADMIN_MX, MARTIFU_UTT_EDU_MX, TIFUH_UTT_EDU_MX }

final emailValues = EnumValues({
    "admin@admin.mx": Email.ADMIN_ADMIN_MX,
    "martifu@utt.edu.mx": Email.MARTIFU_UTT_EDU_MX,
    "tifuh@utt.edu.mx": Email.TIFUH_UTT_EDU_MX
});

enum Nombre { ADMIN, MARTIFU_HERNANDES, TIFU_HERNANDEZ }

final nombreValues = EnumValues({
    "Admin": Nombre.ADMIN,
    "Martifu Hernandes": Nombre.MARTIFU_HERNANDES,
    "Tifu Hernandez": Nombre.TIFU_HERNANDEZ
});

class Foto {
    Foto({
        this.id,
        this.foto,
        this.idNegocio,
        this.createdAt,
        this.updatedAt,
    });

    int id;
    String foto;
    int idNegocio;
    dynamic createdAt;
    dynamic updatedAt;

    factory Foto.fromJson(Map<String, dynamic> json) => Foto(
        id: json["id"],
        foto: json["foto"],
        idNegocio: json["id_negocio"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "foto": foto,
        "id_negocio": idNegocio,
        "created_at": createdAt,
        "updated_at": updatedAt,
    };
}

class Horario {
    Horario({
        this.id,
        this.idNegocio,
        this.lunes,
        this.martes,
        this.miercoles,
        this.jueves,
        this.viernes,
        this.sabado,
        this.domingo,
        this.createdAt,
        this.updatedAt,
    });

    int id;
    int idNegocio;
    String lunes;
    String martes;
    String miercoles;
    String jueves;
    String viernes;
    String sabado;
    String domingo;
    dynamic createdAt;
    dynamic updatedAt;

    factory Horario.fromJson(Map<String, dynamic> json) => Horario(
        id: json["id"],
        idNegocio: json["id_negocio"],
        lunes: json["lunes"],
        martes: json["martes"],
        miercoles: json["miercoles"],
        jueves: json["jueves"],
        viernes: json["viernes"],
        sabado: json["sabado"],
        domingo: json["domingo"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "id_negocio": idNegocio,
        "lunes": lunes,
        "martes": martes,
        "miercoles": miercoles,
        "jueves": jueves,
        "viernes": viernes,
        "sabado": sabado,
        "domingo": domingo,
        "created_at": createdAt,
        "updated_at": updatedAt,
    };
}

class Menu {
    Menu({
        this.id,
        this.idNegocio,
        this.idCategoria,
        this.nombre,
        this.informacion,
        this.createdAt,
        this.updatedAt,
        this.categoria,
    });

    int id;
    int idNegocio;
    int idCategoria;
    String nombre;
    String informacion;
    dynamic createdAt;
    dynamic updatedAt;
    Categoria categoria;

    factory Menu.fromJson(Map<String, dynamic> json) => Menu(
        id: json["id"],
        idNegocio: json["id_negocio"],
        idCategoria: json["id_categoria"],
        nombre: json["nombre"],
        informacion: json["informacion"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        categoria: Categoria.fromJson(json["categoria"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "id_negocio": idNegocio,
        "id_categoria": idCategoria,
        "nombre": nombre,
        "informacion": informacion,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "categoria": categoria.toJson(),
    };
}

class EnumValues<T> {
    Map<String, T> map;
    Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
        if (reverseMap == null) {
            reverseMap = map.map((k, v) => new MapEntry(v, k));
        }
        return reverseMap;
    }
}
