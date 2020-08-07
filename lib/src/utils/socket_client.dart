
import 'package:adhara_socket_io/manager.dart';
import 'package:adhara_socket_io/options.dart';
import 'package:adhara_socket_io/socket.dart';
import 'package:iparty/src/models/mesagge_model.dart';
import 'package:iparty/src/utils/environment.dart';


  typedef void OnNewMessage(dynamic data);

class SocketClient {

  final _manager = SocketIOManager();
  SocketIO _socket;
  OnNewMessage onNewMessage;
  

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
      "to": mensaje.to
    }]);
  }

  

 disconnect() async {
    await _manager.clearInstance(_socket);
    print('se desconecto');
  }

}