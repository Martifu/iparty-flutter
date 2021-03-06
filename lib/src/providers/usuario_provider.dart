import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:IParty/src/models/usuario_info_model.dart';
import 'package:IParty/src/models/usuario_model.dart';
import 'package:IParty/src/utils/environment.dart';

class UsuarioProvider {
  final box = GetStorage();
  
  final _url = Environment.url;

  UsuarioInfo usuarioInfo;
  


  

  signup( UsuarioModel usuario) async {

      final url = Uri.http(_url, "/api/signup");

    
    final authData = {
        "email": usuario.email,
        "nombre": usuario.nombre,
        "foto": usuario.foto,
        "fecha_nacimiento": usuario.fechaNacimiento,
        "password": usuario.password
    };
    
    
      final resp = await http.post(url,
        headers: {'Content-type': 'application/json'}, 
      body: json.encode(authData)
    );

    Map<String, dynamic> decodedResp = json.decode(resp.body);
    

    if (decodedResp['status'] == 202) {
        return { "code": 202, "message": decodedResp['message']};
      } else {
        print(decodedResp['data']['token']['token']);
        box.write('token', decodedResp['data']['token']['token']);
        box.write('email', decodedResp['data']['email']);
        return 200;
      }
  }

  login( String email, String password) async {
      print('logeando');
      final url = Uri.http(_url, "/api/login");

      
      final authData = {
      "email": email,
      "password": password
    };

    final resp = await http.post(url,
        headers: {'Content-type': 'application/json'}, 
      body: json.encode(authData)
    );

    Map<String, dynamic> decodedResp = json.decode(resp.body);

      print(decodedResp);
    
      if (decodedResp['message'] == 'No existe este usuario') {
        return 404;
      } else if (decodedResp['status'] == 202 || decodedResp['status'] == 'error') {
        return 202;
      } else {
        box.write('token', decodedResp['data']['token']['token']);
        box.write('email', decodedResp['data']['email']);
        return 200;
      }
  }

  editarInfo( String nombre, String foto) async {

      final url = Uri.http(_url, "/api/usuario/update");

      
      final authData = {
      "email": box.read('email'),
      "nombre": nombre,
      "foto": foto
    };

    final resp = await http.post(url,
        headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${box.read('token')}',
    }, 
      body: json.encode(authData)
    );

    Map<String, dynamic> decodedResp = json.decode(resp.body);
    print(decodedResp);
    return 200;
      
  }

  


  

}