import 'package:IParty/src/models/usuario_info_model.dart';
import 'package:IParty/src/providers/chat_provider.dart';
import 'package:IParty/src/providers/negocio_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ChatListPage extends StatefulWidget {
  @override
  _ChatListPageState createState() => _ChatListPageState();
}
  UsuarioInfo usuarioInfo = Get.arguments;

  



class _ChatListPageState extends State<ChatListPage> {
  
  @override
  void initState() { 
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final negocioProvider = Provider.of<NegocioProvider>(context);
    final chats = Provider.of<ChatProvider>(context);
    
    return  Scaffold(
      backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: BackButton(color: Colors.white, onPressed: () => Get.back(),),
          title: Text('Conversaciones', style: GoogleFonts.roboto(
            color: Colors.white,
            fontSize: 20,
          fontWeight: FontWeight.bold
          ),), 
        ),
        body: ListView.builder(
          itemCount: chats.conversaciones.length,
          itemBuilder: (context, index) {
            final todos = negocioProvider.todos;
            final negocio = todos.firstWhere((element) => element.id.isEqual(num.parse(chats.conversaciones[index].idnegocio)), );
            print(chats.conversaciones[index].mensaje);
            if (chats.conversaciones[index].from == negocio.id.toString()) {
              return ListTile(
                  onTap: () {
                    Get.toNamed('chat_page', arguments: negocio);
                  },
                  leading:  CircleAvatar(
                      backgroundImage: NetworkImage(negocio.foto),
                    ),
                  title: Text(negocio.nombre, style: GoogleFonts.roboto(
                    color: Color(0xffFF5722),
                    fontSize: 20,
                  fontWeight: FontWeight.bold
                  )),
                      subtitle: Text(chats.conversaciones[index].mensaje,style: GoogleFonts.roboto(
                    color: Colors.white,
                    fontSize: 18,
                  )),
                );
            } else {
              return ListTile(
                  onTap: () {
                    Get.toNamed('chat_page', arguments: negocio);
                  },
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(negocio.foto),
                  ),
                  title: Text(negocio.nombre, style: GoogleFonts.roboto(
                    color: Colors.white,
                    fontSize: 20,
                  fontWeight: FontWeight.bold
                  )),
                      subtitle: Text("↷ Tu: "+chats.conversaciones[index].mensaje,style: GoogleFonts.roboto(
                    color: Colors.white,
                    fontSize: 18,
                  )),
                );
            }
            
          },
        ),
    );
  }
}