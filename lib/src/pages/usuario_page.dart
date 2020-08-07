import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iparty/src/providers/info_user_provider.dart';
import 'package:iparty/src/providers/negocio_provider.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';


class UsuarioPage extends StatelessWidget {
  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    final info = Provider.of<UsuarioInfoProvider>(context);
    final negocioProvider = Provider.of<NegocioProvider>(context);

    
  
    return Scaffold(
        backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: <Widget>[
          GestureDetector(
            onTap: (){
              box.erase();
              negocioProvider.favoritos = [];
              Get.offAllNamed('login');
            },
            child: Container(
              child: Row(
                children: <Widget>[
                  Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
                    child: Text('Cerrar sesión', style: GoogleFonts.roboto(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
      body: Container(

        width: Get.width ,
        height: Get.height ,
        child: SingleChildScrollView(
          child:  Column( 
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 40,),
                  (info.usuarioInfo.foto != null ) ? Hero(
                    tag: info.usuarioInfo.id,
                    child: Container(
                        width: Get.width * .4,
                        height: Get.width * .4,
                        decoration: BoxDecoration(
                          image:  DecorationImage(image: NetworkImage(info.usuarioInfo.foto), fit: BoxFit.cover) ,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2)
                        ),
                      ),
                  ) : CircularProgressIndicator(),
                  SizedBox(height: 20,),
                    Text(info.usuarioInfo.nombre, style: GoogleFonts.roboto(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold
                    ),),
                  SizedBox(height: 20,),
                  Divider(color: Colors.white24,),
                  SizedBox(height: 20,),
                  Text('Email', style: GoogleFonts.roboto(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold
                    ),),
                  SizedBox(height: 5,),
                  Text(info.usuarioInfo.email, style: GoogleFonts.roboto(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold
                    ),),
                  SizedBox(height: 20,),
                  
                  Text('Fecha de nacimiento', style: GoogleFonts.roboto(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold
                    ),),
                  SizedBox(height: 5,),
                  Text(Jiffy(info.usuarioInfo.fechaNacimiento.toIso8601String().substring(0,10)).yMMMMd, style: GoogleFonts.roboto(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold
                    ),),
                  SizedBox(height: Get.height * .2,),
                    RaisedButton(
                      child: Container(
                        padding: EdgeInsets.symmetric( horizontal: 80.0, vertical: 15.0),
                        child: Text('Editar perfil'),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0)
                      ),
                      elevation: 0.0,
                      color: Color(0xffFF5722),
                      textColor: Colors.white, 
                      onPressed: ()=>Get.toNamed('editar', arguments: info.usuarioInfo)
                    )
                    
                  
                  
                ],
              )
        ),
      ),
    );
  }
}