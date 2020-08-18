
import 'package:IParty/src/models/reservacion_model.dart';
import 'package:IParty/src/providers/chat_provider.dart';
import 'package:adhara_socket_io/manager.dart';
import 'package:adhara_socket_io/options.dart';
import 'package:adhara_socket_io/socket.dart';
import 'package:IParty/src/models/mesagge_model.dart';
import 'package:IParty/src/utils/environment.dart';
import 'package:get_storage/get_storage.dart';


  typedef void OnNewMessage(dynamic data);

class SocketClient {

  final _manager = SocketIOManager();
  SocketIO _socket;
  OnNewMessage onNewMessage;
  ChatProvider _chat;
  GetStorage box = GetStorage();
  

  connect(room) async {

    final options = SocketOptions(Environment.socketHost);

    _socket = await _manager.createInstance(options);

      print('Se conecto');

     _socket.on('message', (data) {
      if (onNewMessage != null) {
        onNewMessage(data);
         
      }
    });

    _socket.onError((error) { 
      print('onError: ${error.toString()}');
    });

    _socket.connect();

    _socket.emit('online', [room]);
  }

  emit(String eventName,Message mensaje){
    _socket.emit(eventName, [{
      'idnegocio': mensaje.idnegocio,
      'from':mensaje.from,
      'conversacion':mensaje.conversacion,
      "nombre": mensaje.nombre,
      "foto": mensaje.foto,
      "mensaje": mensaje.mensaje,
      "to": mensaje.to,
      "idsocket": mensaje.idsocket

    }]);
  }

  reservacion(ReservacionModel reservacion, String nombre, String idSocket){
    _socket.emit('reservacion', [{
        "id_usuario": reservacion.idUsuario,
        "id_negocio": reservacion.idNegocio,
        "dia": reservacion.dia.toString(),
        "personas": reservacion.personas,
        "zona": reservacion.zona,
        "nombre": nombre,
        "id_socket": idSocket
    }]);
  }

  

 disconnect() async {
    await _manager.clearInstance(_socket);
    print('se desconecto');
  }

}