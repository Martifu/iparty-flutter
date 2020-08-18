import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:IParty/src/components/chat.dart';
import 'package:IParty/src/models/mesagge_model.dart';
import 'package:IParty/src/models/negocio_model.dart';
import 'package:IParty/src/providers/chat_provider.dart';
import 'package:IParty/src/providers/info_user_provider.dart';
import 'package:IParty/src/utils/socket_client.dart';
import 'package:provider/provider.dart';



 
class ChatPage extends StatefulWidget {

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final box = new GetStorage();
  final _socketClient = SocketClient(); 
  final _chatKey = GlobalKey<ChatState>();
  ChatProvider _chat;

  NegocioModel negocio = Get.arguments;


  _connectSocket() async {
      final chatPr = Provider.of<ChatProvider>(context, listen: false);
      final usuario = Provider.of<UsuarioInfoProvider>(context, listen: false);
      await chatPr.getConversaciones(usuario.usuarioInfo.id, negocio.id);
    await _socketClient.connect(usuario.usuarioInfo.id.toString());
    _socketClient.onNewMessage = (data) {
        print("homePage new-message: ${data.toString()}");

         final message = Message(
              from: data['from'],
              conversacion: data['conversacion'],
              mensaje: data['mensaje'],
              nombre: data['nombre'],
              foto: data['foto'],
              to: data['to'],
              idnegocio: data['idnegocio'],
              idsocket: data['idsocket'],
            );
      _chat.getMessagesUser(box.read('id'));
      if (message.from == negocio.id) {
        _chat.addMessage(message);
        _chatKey.currentState.checkUnread();
      } else {
        print('no es el mismo');
      }
      
    };
  }

    _sendMessage(String text) {
      

      final usuario = Provider.of<UsuarioInfoProvider>(context, listen: false); 

      Message message = Message(
            from: usuario.usuarioInfo.id,
            conversacion: usuario.usuarioInfo.id,
            mensaje: text,
            nombre: usuario.usuarioInfo.nombre,
            foto: usuario.usuarioInfo.foto,
            to: negocio.id,
            idnegocio: negocio.id,
            idsocket: negocio.id.toString()+negocio.nombre, 
            );

            print(message.idsocket);

    _socketClient.emit('message', message);

    _chat.addMessage(message);
    _chat.getMessagesUser(box.read('id'));

    _chatKey.currentState?.goToEnd();
  }

  

  @override
  void dispose() {
    _chat.clearMessages();

    super.dispose();
  }

  @override
  void initState() { 
    _connectSocket();
    super.initState();
    
  }

   @override
  Widget build(BuildContext context) {
    final usuario = Provider.of<UsuarioInfoProvider>(context);

    _chat = ChatProvider.of(context);

    return SafeArea(
          child: Scaffold(
        backgroundColor: Colors.black,
        
        appBar: AppBar(
          leading: IconButton(icon: Icon(FontAwesomeIcons.arrowLeft, color: Colors.white), onPressed: (){
            _socketClient.disconnect();
            _chat.clearMessages();
            Get.back();
          }),
          backgroundColor: Colors.black,
          brightness: Brightness.light,
          title: Row(
            children: <Widget>[
              Container(
                width: Get.width * .08,
                height: Get.width * .08,
                decoration: BoxDecoration(
                  image:  DecorationImage(image: NetworkImage(negocio.foto), fit: BoxFit.cover) ,
                  shape: BoxShape.circle,
                ),
              ),
                        SizedBox(width: 5,),
              Text(
                negocio.nombre.toUpperCase(),
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          actions: <Widget>[
            PopupMenuButton(
              icon: Icon(
                Icons.more_vert,
                color: Colors.black,
              ),
              onSelected: (String value) {
                if (value == "exit") {
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: "share",
                  child: Text("Share App"),
                ),
                PopupMenuItem(
                  value: "exit",
                  child: Text("Exit App"),
                )
              ],
            )
          ],
          elevation: 0,
        ),
        body: SafeArea(
          child: Chat(
            usuario.usuarioInfo.id,
            key: _chatKey,
            onSend: _sendMessage,
            messages: _chat.messages,
          ),
        ),
      ),
    );
  }
}