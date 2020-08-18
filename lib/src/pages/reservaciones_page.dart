import 'package:IParty/src/models/reservacion_model.dart';
import 'package:IParty/src/providers/negocio_provider.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:IParty/src/providers/info_user_provider.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';
 
 
class ReservacionesPage extends StatefulWidget {

  @override
  _ReservacionesPageState createState() => _ReservacionesPageState();
}



class _ReservacionesPageState extends State<ReservacionesPage> {


  

   @override
   void initState() { 
     super.initState();
   }

  @override
  Widget build(BuildContext context) {
    
    final negocioProvider = Provider.of<NegocioProvider>(context);
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
          IconButton(icon: Icon( EvaIcons.messageCircleOutline, color: Colors.white, size: 28,), onPressed: () => Get.toNamed('chat_list', arguments: info.usuarioInfo),)
        ],
      ), 
        body: Container(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: <Widget>[ 
              (negocioProvider.reservaciones.length > 0) ?  _crearFavs(negocioProvider.reservaciones) : Center(child: Text('No tienes reservaciones ¡Reserva ahora!', style: TextStyle(color: Colors.white),)),
            ],
          ),
        ),
      ), 
    );
  }

  Widget _crearFavs(List<ReservacionModel> favoritos) {

          if (favoritos.length == 0) {
           return Center(child: CircularProgressIndicator());
          } else {
           return Column(
             children: _listaJuegos(favoritos),
           ) ;
          }
        
  }

  

  List<Widget> _listaJuegos(List<ReservacionModel> reservaciones) {
      return reservaciones.map((reservacion){
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white10
            ),
            child: ListTile(
              onTap: () {
                Get.toNamed('info_reservacion', arguments: reservacion);
              },
              leading: CircleAvatar(backgroundImage: NetworkImage(reservacion.negocio.foto), backgroundColor: Colors.black,),
              title: Text("Reservación en: "+reservacion.negocio.nombre, style: GoogleFonts.roboto(
                color: Color(0xffFF5722),
                fontWeight: FontWeight.bold,
                fontSize: 20
              ),),
              subtitle: Text(Jiffy(reservacion.dia).yMMMEdjm +", "+reservacion.personas.toString()+" personas" ,style: GoogleFonts.roboto(
                color: Colors.white
              )),
            ),
          ),
        );
      }).toList();
  }

  
}