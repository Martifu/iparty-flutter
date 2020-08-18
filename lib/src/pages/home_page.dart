
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:IParty/src/components/nogocioCard_horizontal.dart';
import 'package:IParty/src/providers/info_user_provider.dart';
import 'package:IParty/src/providers/negocio_provider.dart';
import 'package:IParty/src/providers/publitio_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final primary = Colors.black;
  final secondary = Color(0xffff5722);
 
  

  @override
  void initState()  { 
    
    super.initState();
    PublitioProvider.configurePublitio();
  }

  
  @override
  void dispose() {
    super.dispose();
  }
  
  
  @override
  Widget build(BuildContext context) {

    final info = Provider.of<UsuarioInfoProvider>(context);
    final negocioProvider = Provider.of<NegocioProvider>(context);
    
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: primary,
      appBar: AppBar(
        elevation: 0,
        backgroundColor:  primary,
        title: Image.asset('assets/img/logo.png',width: Get.width * .05,),
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
      body: Stack(
        children: <Widget>[
            Container(
          width: size.width,
          height: size.height,
          child: NotificationListener<OverscrollIndicatorNotification>(
            // ignore: missing_return
            onNotification: (overscroll) {
                overscroll.disallowGlow();
              },
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  _barraBusqueda(),
                  (negocioProvider.populares.isEmpty) ?Container() : _showPopulares() ,
                  (negocioProvider.bares.isEmpty) ? Container() : _showBares() ,
                  (negocioProvider.antros.isEmpty) ? Container() : _showAntros() ,
                  (negocioProvider.cantinas.isEmpty) ?  Container() :_showCantinas(),
                ],
              ),
            ),
          ),
        ),
        ],
            
      )
    );
  }


  Widget _showPopulares() {
        final negocioProvider = Provider.of<NegocioProvider>(context);


    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      padding: EdgeInsets.only(bottom: 10 ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                child: Text('Populares', style: GoogleFonts.roboto(fontSize: 20,color: Colors.white, fontWeight: FontWeight.bold))
              ),
              RaisedButton(
                color: Colors.black,
                highlightColor: secondary,
                splashColor: secondary,
                  child: Row(
                    children: <Widget>[
                      Text("Verlos en mapa", style: GoogleFonts.roboto(color: Colors.white),),
                      SizedBox(width: 5,),
                      CircleAvatar( child: Icon(FontAwesomeIcons.arrowRight, size: 10,), minRadius: 2, maxRadius:10, backgroundColor: secondary, ),
                    ],
                  ),
                  onPressed: (){ Get.toNamed('mapa_negocios', arguments: negocioProvider.populares); },
                  shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0))
                )
            ],
          ),
           (negocioProvider.populares != null) ? Container(
            width: Get.width * 6,
            height: Get.height *.25,
            child: NegocioHorizontal(negocios: negocioProvider.populares)
          ) : Center(
            child: CircularProgressIndicator(),
          )
        ],
      ),
    );
  }

Widget _showBares() {
        final negocioProvider = Provider.of<NegocioProvider>(context);


    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      padding: EdgeInsets.only(bottom: 10 ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                child: Text('Bares', style: GoogleFonts.roboto(fontSize: 20,color: Colors.white, fontWeight: FontWeight.bold))
              ),
              RaisedButton(
                color: Colors.black,
                highlightColor: secondary,
                splashColor: secondary,
                  child: Row(
                    children: <Widget>[
                      Text("Verlos en mapa", style: GoogleFonts.roboto(color: Colors.white),),
                      SizedBox(width: 5,),
                      CircleAvatar( child: Icon(FontAwesomeIcons.arrowRight, size: 10,), minRadius: 2, maxRadius:10, backgroundColor: secondary, ),
                    ],
                  ),
                  onPressed: (){ Get.toNamed('mapa_negocios', arguments: negocioProvider.bares); },
                  shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0))
                )
            ],
          ),
           (negocioProvider.bares!= null) ? Container(
            width: Get.width * 6,
            height: Get.height *.25,
            child: NegocioHorizontal(negocios: negocioProvider.bares)
          ) : Center(
            child: CircularProgressIndicator(),
          )
        ],
      ),
    );
  }
  
  Widget _showAntros() {
        final negocioProvider = Provider.of<NegocioProvider>(context);


    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      padding: EdgeInsets.only(bottom: 10 ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                child: Text('Antros', style: GoogleFonts.roboto(fontSize: 20,color: Colors.white, fontWeight: FontWeight.bold))
              ),
              RaisedButton(
                color: Colors.black,
                highlightColor: secondary,
                splashColor: secondary,
                  child: Row(
                    children: <Widget>[
                      Text("Verlos en mapa", style: GoogleFonts.roboto(color: Colors.white),),
                      SizedBox(width: 5,),
                      CircleAvatar( child: Icon(FontAwesomeIcons.arrowRight, size: 10,), minRadius: 2, maxRadius:10, backgroundColor: secondary, ),
                    ],
                  ),
                  onPressed: (){ Get.toNamed('mapa_negocios', arguments: negocioProvider.antros); },
                  shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0))
                )
            ],
          ),
           (negocioProvider.bares!= null) ? Container(
            width: Get.width * 6,
            height: Get.height *.25,
            child: NegocioHorizontal(negocios: negocioProvider.antros)
          ) : Center(
            child: CircularProgressIndicator(),
          )
        ],
      ),
    );
  }
  

    Widget _showCantinas() {
        final negocioProvider = Provider.of<NegocioProvider>(context);


    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      padding: EdgeInsets.only(bottom: 10 ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                child: Text('Cantinas', style: GoogleFonts.roboto(fontSize: 20,color: Colors.white, fontWeight: FontWeight.bold))
              ),
              RaisedButton(
                color: Colors.black,
                highlightColor: secondary,
                splashColor: secondary,
                  child: Row(
                    children: <Widget>[
                      Text("Verlos en mapa", style: GoogleFonts.roboto(color: Colors.white),),
                      SizedBox(width: 5,),
                      CircleAvatar( child: Icon(FontAwesomeIcons.arrowRight, size: 10,), minRadius: 2, maxRadius:10, backgroundColor: secondary, ),
                    ],
                  ),
                  onPressed: (){ Get.toNamed('mapa_negocios', arguments: negocioProvider.cantinas); },
                  shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0))
                )
            ],
          ),
           (negocioProvider.bares!= null) ? Container(
            width: Get.width * 6,
            height: Get.height *.25,
            child: NegocioHorizontal(negocios: negocioProvider.cantinas)
          ) : Center(
            child: CircularProgressIndicator(),
          )
        ],
      ),
    );
  }
  Widget _barraBusqueda() {
    final info = Provider.of<UsuarioInfoProvider>(context);

    return Row(
      children: <Widget>[
        Hero(
          tag: 'busqueda',
              child: Padding(
            padding: EdgeInsets.only(left: Get.width * .05, top: Get.height * .01, bottom:  Get.height * .01 ),
            child: GestureDetector(
              onTap: () =>{
                Get.toNamed('busqueda')
              },
              child: Container(
                width: Get.width*.8,
                height: Get.height * .06,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.white10,
                  border: Border.all(color: Colors.white10, width: 1)
                ),
                child: Row(
                  children: <Widget>[
                    SizedBox(width: Get.width * .05,),
                    Icon(EvaIcons.search, color: Colors.white30,),
                    SizedBox(width: Get.width * .04,),
                    Material(type: MaterialType.transparency,child: Text('Buscar', style: GoogleFonts.roboto(fontSize: 20, color: Colors.white30)))
                  ],
                ),
              ),
            ),
          ),
        ),
          IconButton(highlightColor: Color(0xffff5722), splashColor:  Color(0xffff5722), icon: Icon(FontAwesomeIcons.camera , color: Colors.white38 ), onPressed: ()=>Get.toNamed('subir_historia', arguments: info.usuarioInfo)
        )
      ],
    );
  }
}

