import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:IParty/src/models/negocio_model.dart';
import 'package:IParty/src/providers/info_user_provider.dart';
import 'package:IParty/src/providers/negocio_provider.dart';
import 'package:provider/provider.dart';

class FavsPage extends StatefulWidget {
  
  @override
  _FavsPageState createState() => _FavsPageState();
}

class _FavsPageState extends State<FavsPage> {

  
  var favoritos = List<dynamic>();
  @override
  void initState() { 
    super.initState();
    _cargarPrefs();
    
    
  }

   _cargarPrefs()  {
     GetStorage prefs =  GetStorage();
     favoritos = prefs.read('favoritos');
     print(favoritos.toString());
     setState(() {
       
     });
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
        title: Text('Favoritos', style: GoogleFonts.roboto(
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
                    border: Border.all(color: Colors.white, width: 2),
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
              (negocioProvider.favoritos.length > 0) ?  _crearFavs(negocioProvider.favoritos) : Center(child: Text('No tienes favoritos agregados', style: TextStyle(color: Colors.white),)),
            ],
          ),
        ),
      ), 
    );
  }

  Widget _crearFavs(List<NegocioModel> favoritos) {

          if (favoritos.length == 0) {
           return Center(child: CircularProgressIndicator());
          } else {
           return Column(
             children: _listaJuegos(favoritos),
           ) ;
          }
        
  }

  

  List<Widget> _listaJuegos(List<NegocioModel> negocios) {
      return negocios.map((negocio){
        return Material(
          borderRadius: BorderRadius.circular(25),
          color: Colors.black,
          child: GestureDetector(
            onTap: () {
              Get.toNamed('detalles', arguments: negocio);
            },
              child: Container( 
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              width: Get.width * 2,
              height: Get.height * 0.15,
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(25)
              ),
              child: Row(
                children: <Widget>[
                  (negocio.fotos.length > 0) ? Container(
                  width: 140,
                  decoration: BoxDecoration(
                    image: DecorationImage(image: NetworkImage(negocio.foto), fit: BoxFit.cover),
                    borderRadius: BorderRadius.circular(25), 
                  ),
                ) : Container(
                  width: 140,
                  decoration: BoxDecoration(
                    image: DecorationImage(image: NetworkImage(negocio.foto), fit: BoxFit.cover),
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left:15.0, top: 8.0),
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(negocio.nombre, style: GoogleFonts.roboto(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                        Text(negocio.ubicacion, style: GoogleFonts.roboto(color: Colors.white, fontSize: 14)),
                        _estrellas(5),
                      ],
                    ),
                  ),
                )
                ],
              )
            ),
          ),
        );
      }).toList();
  }

  Widget _estrellas(int rank) {
    List<Widget> list = new List<Widget>();
    for(var i = 0; i < rank; i++){
        list.add(Icon(EvaIcons.star, color: Color(0xffff5722), size: 17,));
    }
    return new Row(children: list);
  }
  
}