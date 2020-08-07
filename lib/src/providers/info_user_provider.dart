import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:iparty/src/models/usuario_info_model.dart';
import 'package:iparty/src/utils/environment.dart';

class UsuarioInfoProvider extends ChangeNotifier{
  final box = GetStorage();
  
  final _url = Environment.url;

  UsuarioInfo usuarioInfo;
  
  
  


   getInfo() async {
    print('object');
      final url = Uri.https(_url, "/api/usuario");

      
      final authData = {
      "email": box.read('email'),
      };

    final resp = await http.post(url,
        headers: {'Content-type': 'application/json'}, 
      body: json.encode(authData)
    );

    Map<String, dynamic> decodedResp = json.decode(resp.body);

          print(decodedResp['data']);

          this.usuarioInfo = UsuarioInfo.fromJson(decodedResp['data']);
          box.write('foto', decodedResp['data']['foto']);
       
         notifyListeners();
   }

   clearInfo() async {
          this.usuarioInfo = null;
          box.remove('foto');
         notifyListeners();
   }


  

}