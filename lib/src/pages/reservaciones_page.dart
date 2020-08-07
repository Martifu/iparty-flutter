import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iparty/src/providers/info_user_provider.dart';
import 'package:provider/provider.dart';
 
 
class ReservacionesPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final info = Provider.of<UsuarioInfoProvider>(context);

    return Scaffold(
      backgroundColor: Colors.black,
        appBar: AppBar(
        elevation: 0,
        backgroundColor:  Colors.black,
        title: Text('Mis Reservaciones', style: GoogleFonts.roboto(
          color: Colors.white, 
          fontWeight: FontWeight.bold,
          fontSize: 24
        ),),
        centerTitle: true,
        leading:(info.usuarioInfo != null ) ?  GestureDetector(
          onTap: () => Get.toNamed('perfil'),
          child:  Hero(
            tag: info.usuarioInfo.id,
               child: Padding(
                padding: const EdgeInsets.all(9.0),
                child:  Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(image: NetworkImage(info.usuarioInfo.foto), fit: BoxFit.cover),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2)
                  ),
                ),
              ),
          )  
        ): Padding(
                padding: const EdgeInsets.all(9.0),
                child:  Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white10,
                    border: Border.all(color: Colors.white, width: 2)
                  ),
                ),
              ),
        actions: <Widget>[
          IconButton(icon: Icon( EvaIcons.messageCircleOutline, color: Colors.white, size: 28,), onPressed: () => Get.toNamed('chat_page'),)
        ],
      ), 
        body: Center(
          child: Container(
            child: Text('Hello World'),
          ),
        ),
    );
  }
}