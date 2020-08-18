
import 'dart:convert';

class Negocios {
 
    List<NegocioModel> items = new List();

    Negocios();  

    Negocios.fromJsonList(List<dynamic> jsonList){
      if (jsonList==null) return;

      for (var item in jsonList) {
        if ( item['categoria_negocio'] != null ) {
          final negocio = new NegocioModel.fromJson(item);
          items.add(negocio); 
        }
      }
    }

}


NegocioModel negocioModelFromJson(String str) => NegocioModel.fromJson(json.decode(str));

String negocioModelToJson(NegocioModel data) => json.encode(data.toJson());

class NegocioModel {
    NegocioModel({
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
        this.categoriaNegocio,
        this.fotos,
        this.horarios,
        this.eventos,
        this.menu,
        this.historias,
        this.comentarios,
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
    CategoriaNegocio categoriaNegocio;
    List<Foto> fotos;
    List<Horario> horarios;
    List<Evento> eventos;
    List<Menu> menu;
    List<Historia> historias;
    List<Comentario> comentarios;

    factory NegocioModel.fromJson(Map<String, dynamic> json) => NegocioModel(
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
        categoriaNegocio: CategoriaNegocio.fromJson(json["categoria_negocio"]),
        fotos: List<Foto>.from(json["fotos"].map((x) => Foto.fromJson(x))),
        horarios: List<Horario>.from(json["horarios"].map((x) => Horario.fromJson(x))),
        eventos: List<Evento>.from(json["eventos"].map((x) => Evento.fromJson(x))),
        menu: List<Menu>.from(json["menu"].map((x) => Menu.fromJson(x))),
        historias: List<Historia>.from(json["historias"].map((x) => Historia.fromJson(x))),
        comentarios: List<Comentario>.from(json["comentarios"].map((x) => Comentario.fromJson(x))),
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
        "categoria_negocio": categoriaNegocio.toJson(),
        "fotos": List<dynamic>.from(fotos.map((x) => x.toJson())),
        "horarios": List<dynamic>.from(horarios.map((x) => x.toJson())),
        "eventos": List<dynamic>.from(eventos.map((x) => x.toJson())),
        "menu": List<dynamic>.from(menu.map((x) => x.toJson())),
        "historias": List<dynamic>.from(historias.map((x) => x.toJson())),
        "comentarios": List<dynamic>.from(comentarios.map((x) => x.toJson())),
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

class Categoria {
    Categoria({
        this.id,
        this.nombre,
        this.createdAt,
        this.updatedAt,
    });

    int id;
    String nombre;
    dynamic createdAt;
    dynamic updatedAt;

    factory Categoria.fromJson(Map<String, dynamic> json) => Categoria(
        id: json["id"],
        nombre: json["nombre"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "created_at": createdAt,
        "updated_at": updatedAt,
    };
}

class CategoriaNegocio {
    CategoriaNegocio({
        this.id,
        this.categoria,
        this.createdAt,
        this.updatedAt,
    });

    int id;
    String categoria;
    dynamic createdAt;
    dynamic updatedAt;

    factory CategoriaNegocio.fromJson(Map<String, dynamic> json) => CategoriaNegocio(
        id: json["id"],
        categoria: json["categoria"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "categoria": categoria,
        "created_at": createdAt,
        "updated_at": updatedAt,
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
    String email;
    String nombre;
    String foto;
    DateTime fechaNacimiento;
    DateTime createdAt;
    DateTime updatedAt;

    factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
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



class Evento {
    Evento({
        this.id,
        this.idNegocio,
        this.fecha,
        this.nombre,
        this.informacion,
        this.foto,
        this.createdAt,
        this.updatedAt,
        this.idCategoria,
    });

    int id;
    int idNegocio;
    DateTime fecha;
    String nombre;
    String informacion;
    String foto;
    dynamic createdAt;
    dynamic updatedAt;
    int idCategoria;

    factory Evento.fromJson(Map<String, dynamic> json) => Evento(
        id: json["id"],
        idNegocio: json["id_negocio"],
        fecha: json["fecha"] == null ? null : DateTime.parse(json["fecha"]),
        nombre: json["nombre"],
        informacion: json["informacion"],
        foto: json["foto"] == null ? null : json["foto"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        idCategoria: json["id_categoria"] == null ? null : json["id_categoria"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "id_negocio": idNegocio,
        "fecha": fecha == null ? null : fecha.toIso8601String(),
        "nombre": nombre,
        "informacion": informacion,
        "foto": foto == null ? null : foto,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "id_categoria": idCategoria == null ? null : idCategoria,
    };
}

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

class Historia {
    Historia({
        this.id,
        this.idUsuario,
        this.idNegocio,
        this.duracion,
        this.urlFile,
        this.tipo,
        this.urlMiniatura,
        this.descripcion,
        this.createdAt,
        this.updatedAt,
        this.usuario,
    });

    int id;
    int idUsuario;
    int idNegocio;
    String descripcion;
    int duracion;
    String urlFile;
    String tipo;
    String urlMiniatura;
    dynamic createdAt;
    dynamic updatedAt;
    Usuario usuario;

    factory Historia.fromJson(Map<String, dynamic> json) => Historia(
        id: json["id"],
        idUsuario: json["id_usuario"],
        idNegocio: json["id_negocio"],
        duracion: json["duracion"],
        urlFile: json["url_file"],
        tipo: json["tipo"],
        urlMiniatura: json["url_miniatura"],
        descripcion: json["descripcion"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        usuario: Usuario.fromJson(json["usuario"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "id_usuario": idUsuario,
        "id_negocio": idNegocio,
        "duracion": duracion,
        "url_file": urlFile,
        "tipo": tipo,
        "url_miniatura": urlMiniatura,
        "descripcion": descripcion,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "usuario": usuario.toJson(),
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
