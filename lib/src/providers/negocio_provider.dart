
import 'dart:convert';

import 'package:IParty/src/models/reservacion_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:IParty/src/models/negocio_model.dart';
import 'package:http/http.dart' as http;
import 'package:IParty/src/utils/environment.dart';


class NegocioProvider extends ChangeNotifier{

   String _url = Environment.url;

    List<NegocioModel> populares= [];
    List<NegocioModel> bares= [];
    List<NegocioModel> antros= [];
    List<NegocioModel> cantinas = [];
    List<NegocioModel> favoritos = [];
    List<NegocioModel> busquedas = [];
    List<NegocioModel> todos = [];
    List<ReservacionModel> reservaciones = [];

    GetStorage box = GetStorage();
    
   NegocioProvider(){
     this.getBares();
     this.getTodos();
     this.getCantinas();
     this.getAntros();
     this.getReservaciones();
      this.getPopulares();
      if (box.read('favoritos') != []) {
        this.getFavoritos(box.read('favoritos'));
      }
      
   }

  getPopulares() async { 
      
      final url = Uri.http(_url, "/api/negocio/top5");

      final resp = await http.get(url,headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${box.read('token')}',
    });
      final decodedData =  json.decode(resp.body);

      final top = Negocios.fromJsonList(decodedData['data']);

      this.populares = top.items;
      notifyListeners();
   
    }

    getBares() async {

      
      final url = Uri.http(_url, "/api/negocio/bares");

      final resp = await http.get(url,
        headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${box.read('token')}',
      });
      final decodedData =  json.decode(resp.body);
      final bares = Negocios.fromJsonList(decodedData['data']);
      this.bares = bares.items;
      notifyListeners();
   
    }

    getAntros() async {

      
      final url = Uri.http(_url, "/api/negocio/antros");

      final resp = await http.get(url, 
        headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${box.read('token')}',
      });
      final decodedData =  json.decode(resp.body);
      final antros = Negocios.fromJsonList(decodedData['data']);
      this.antros = antros.items;
      notifyListeners();
   
    }

    getCantinas() async {

      
      final url = Uri.http(_url, "/api/negocio/cantinas");

      final resp = await http.get(url,
        headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${box.read('token')}',
      });
      final decodedData =  json.decode(resp.body);
      final cantinas = Negocios.fromJsonList(decodedData['data']);
      this.cantinas = cantinas.items;
      notifyListeners();
   
    }

    getFavoritos(favoritos) async {

      
      final url = Uri.http(_url, "/api/negocio/favs");

      Map<String, dynamic> favo = {
        "array": favoritos
      };
      var body = json.encode(favo);
      final resp = await http.post(
        url,
        headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${box.read('token')}',
      }, 
        body: body
      );
      final decodedData =  json.decode(resp.body);

      final favs = Negocios.fromJsonList(decodedData['data']);

      this.favoritos = favs.items;
      notifyListeners();
   
    }

    busqueda(String query) async {

      
      final url = Uri.http(_url, "/api/negocio/buscador");
      Map<String, dynamic> favo = {
        "data": query
      };
      var body = json.encode(favo);
      final resp = await http.post(
        url,
        headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${box.read('token')}',
      }, 
        body: body
      );
      final decodedData =  json.decode(resp.body);
      print(body);

      final busq = Negocios.fromJsonList(decodedData['data']);
      this.busquedas = busq.items;
      notifyListeners();
   
    }

    borrarBusqueda()  {
      this.busquedas = [];
      notifyListeners();
    }

    comentario(idnegocio, idusuario, comentario, ranking) async {
      
      final url = Uri.http(_url, "/api/negocio/createComentario");
      Map<String, dynamic> favo = {
            "id_negocio": idnegocio,
            "id_usuario": idusuario,
            "comentario": comentario,
            "calificacion": ranking
          };
      var body = json.encode(favo);
      final resp = await http.post(
        url,
        headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${box.read('token')}',
      }, 
        body: body
      );
      //final decodedData =  json.decode(resp.body);
      this.getBares();
     this.getTodos();
      this.getCantinas();
      this.getAntros();
        this.getPopulares();
        if (box.read('favoritos') != []) {
          this.getFavoritos(box.read('favoritos'));
        }
      notifyListeners();

    }

    guardarHistoria(Historia historia) async {

      
      final url = Uri.http(_url, "/api/negocio/historia");
      Map<String, dynamic> hist = {
          "id_usuario": historia.idUsuario, 
          "id_negocio": historia.idNegocio, 
          "duracion": historia.duracion, 
          "url_file": historia.urlFile ,
          "tipo":historia.tipo,
          "url_miniatura": historia.urlMiniatura,
          "descripcion": historia.descripcion
        };
      var body = json.encode(hist);
      final resp = await http.post(
        url,
        headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${box.read('token')}',
      }, 
        body: body
      );
      //final decodedData =  json.decode(resp.body);
      //final guardada = Historias.fromJsonList(decodedData['data']);
      this.getBares();
     this.getTodos();
      this.getCantinas();
      this.getAntros();
        this.getPopulares();
        if (box.read('favoritos') != []) {
          this.getFavoritos(box.read('favoritos'));
        }
      notifyListeners();
      return 200;
    }

     getTodos() async { 
      
      final url = Uri.http(_url, "/api/negocio/all");

      final resp = await http.get(url,
        headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${box.read('token')}',
      });
      final decodedData =  json.decode(resp.body);

      final top = Negocios.fromJsonList(decodedData['data']);
      print(decodedData);
      this.todos = top.items;
      notifyListeners();
   
    }


  getReservaciones( ) async {

      final url = Uri.http(_url, "/api/usuario/reservaciones");
  
      
      final authData = {
        "id": box.read('id')
      };


      var body = json.encode(authData);
      final resp = await http.post(
        url,
        headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${box.read('token')}',
      }, 
        body: body
      );
      final decodedData =  json.decode(resp.body);

      final reser = Reservaciones.fromJsonList(decodedData['data']);
      print(decodedData);
      this.reservaciones = reser.items;

      print(this.reservaciones);
      notifyListeners();
      
  }

  cancelarReservacion(int id ) async {

      final url = Uri.http(_url, "/api/negocio/cancelarReservacion");
  
      
      final authData = {
      "id": id
    };


      var body = json.encode(authData);
      final resp = await http.post(
        url,
        headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${box.read('token')}',
      }, 
        body: body
      );
      final decodedData =  json.decode(resp.body);



      this.getReservaciones();
      
      print(this.reservaciones);
      notifyListeners();
      return decodedData['message'];
  }

  editarReservacion(ReservacionModel reservacion ) async {

      final url = Uri.http(_url, "/api/negocio/updateReservacion");
  
      
      final authData = {
        "id": reservacion.id,
        "dia": reservacion.dia.toString().substring(0,21),
        "personas": reservacion.personas,
        "zona": reservacion.zona,
      };


      var body = json.encode(authData);
      final resp = await http.post(
        url,
        headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${box.read('token')}',
      }, 
        body: body
      );
      final decodedData =  json.decode(resp.body);

      print(decodedData);

      this.getReservaciones();
      
      //print(this.reservaciones);
      notifyListeners();
      return decodedData['message'];
  }
}