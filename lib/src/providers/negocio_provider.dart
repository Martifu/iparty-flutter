
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iparty/src/models/negocio_model.dart';
import 'package:http/http.dart' as http;
import 'package:iparty/src/utils/environment.dart';


class NegocioProvider extends ChangeNotifier{

   String _url = Environment.url;

    List<NegocioModel> populares= [];
    List<NegocioModel> bares= [];
    List<NegocioModel> antros= [];
    List<NegocioModel> cantinas = [];
    List<NegocioModel> favoritos = [];
    List<NegocioModel> busquedas = [];

    GetStorage box = GetStorage();
    
   NegocioProvider(){
     this.getBares();
     this.getCantinas();
     this.getAntros();
      this.getPopulares();
      if (box.read('favoritos') != []) {
        this.getFavoritos(box.read('favoritos'));
      }
      
   }

  getPopulares() async { 
      print('object');
      
      final url = Uri.https(_url, "/api/negocio/top5");

      final resp = await http.get(url);
      final decodedData =  json.decode(resp.body);

      final top = Negocios.fromJsonList(decodedData['data']);

      this.populares = top.items;
      notifyListeners();
   
    }

    getBares() async {

      
      final url = Uri.https(_url, "/api/negocio/bares");

      final resp = await http.get(url);
      final decodedData =  json.decode(resp.body);
      final bares = Negocios.fromJsonList(decodedData['data']);
      this.bares = bares.items;
      notifyListeners();
   
    }

    getAntros() async {

      
      final url = Uri.https(_url, "/api/negocio/antros");

      final resp = await http.get(url);
      final decodedData =  json.decode(resp.body);
      final antros = Negocios.fromJsonList(decodedData['data']);
      this.antros = antros.items;
      notifyListeners();
   
    }

    getCantinas() async {

      
      final url = Uri.https(_url, "/api/negocio/cantinas");

      final resp = await http.get(url);
      final decodedData =  json.decode(resp.body);
      final cantinas = Negocios.fromJsonList(decodedData['data']);
      this.cantinas = cantinas.items;
      print(this.cantinas);
      notifyListeners();
   
    }

    getFavoritos(favoritos) async {

      
      final url = Uri.https(_url, "/api/negocio/favs");

      Map<String, dynamic> favo = {
        "array": favoritos
      };
      var body = json.encode(favo);
      final resp = await http.post(
        url,
        headers: {'Content-type': 'application/json'}, 
        body: body
      );
      final decodedData =  json.decode(resp.body);

      final favs = Negocios.fromJsonList(decodedData['data']);
      print(favs.items);

      this.favoritos = favs.items;
      notifyListeners();
   
    }

    busqueda(String query) async {

      
      final url = Uri.https(_url, "/api/negocio/buscador");
      print('eject');
      Map<String, dynamic> favo = {
        "data": query
      };
      var body = json.encode(favo);
      final resp = await http.post(
        url,
        headers: {'Content-type': 'application/json'}, 
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
      
      final url = Uri.https(_url, "/api/negocio/createComentario");
      print('eject');
      Map<String, dynamic> favo = {
            "id_negocio": idnegocio,
            "id_usuario": idusuario,
            "comentario": comentario,
            "calificacion": ranking
          };
      var body = json.encode(favo);
      final resp = await http.post(
        url,
        headers: {'Content-type': 'application/json'}, 
        body: body
      );
      final decodedData =  json.decode(resp.body);
      print(decodedData);
      this.getBares();
      this.getCantinas();
      this.getAntros();
        this.getPopulares();
        if (box.read('favoritos') != []) {
          this.getFavoritos(box.read('favoritos'));
        }

    }
}