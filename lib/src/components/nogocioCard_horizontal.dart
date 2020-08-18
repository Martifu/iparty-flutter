
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:IParty/src/models/negocio_model.dart';

class NegocioHorizontal extends StatelessWidget {

  final  List<NegocioModel> negocios;
  final Color primayColor = Color(0xff5c6cfc);
    final Color secondaryColor = Color(0xff0ebc7d);
    final Color primaryDark = Color(0xff2d304e);
    final Color lightColor = Color(0xffededf1);
   NegocioHorizontal({@required this.negocios});

   final pageController = new PageController(
          initialPage: 1,
          viewportFraction: .35,
        );

  @override
  Widget build(BuildContext context) {

    final _size = MediaQuery.of(context).size;
    
    return Container(
      height: _size.height /3.8,
      child: PageView(
        pageSnapping: true,
        controller: PageController(
          initialPage: 0,
          viewportFraction: 1,
        ),
        children: (negocios.length > 0) ? _tarjetas(context) : [Center(child: CircularProgressIndicator())] ,
      ),
    );
  }

  List<Widget> _tarjetas(BuildContext context) {
     return  negocios.map((negocio){
      return  GestureDetector(
        onTap: () => Navigator.of(context).pushNamed('detalles', arguments: negocio),
            child: Stack(
              children: <Widget>[
                  Container(
                    width: Get.width,
                  padding: EdgeInsets.symmetric(horizontal: Get.width * .05),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                        child: (negocio.fotos.length > 1) ? Container(
                          child: Image(
                              image:  NetworkImage(negocio.fotos[0].foto) ,
                              fit: BoxFit.cover,
                            ),
                            ) :Container(
                          child: Image(
                              image:  NetworkImage(negocio.foto) ,
                              fit: BoxFit.cover,
                            ),
                            )
                        ),
                    ),
                  
                  Container(
                    width: Get.width,
                  padding: EdgeInsets.symmetric(horizontal: Get.width * .05),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                        child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [Colors.black87, Colors.transparent],
                                  stops: [0.3, 1],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter
                                ),
                            ),
                          ),
                        ),
                    ),
                  Positioned(
                    bottom: 1, 
                    child: Container(
                      width: Get.width,
                      padding: EdgeInsets.symmetric(vertical: Get.height * .01, horizontal: Get.width * .08),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(negocio.nombre.toUpperCase(), overflow: TextOverflow.ellipsis, style: GoogleFonts.roboto(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),),                             
                              Text(negocio.categoriaNegocio.categoria + ' ∙ ' + negocio.ubicacion, style: GoogleFonts.roboto(color: Colors.white, fontSize: 14),), 
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              _estrellas(negocio.popularidad),
                            ],
                          )
                        ],
                      ),
                    ),
                  )
              ],
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