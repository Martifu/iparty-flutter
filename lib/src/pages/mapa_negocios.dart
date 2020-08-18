import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:IParty/src/components/mapa_viewer.dart';
import 'package:IParty/src/models/negocio_model.dart';

class MapaNegociosPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    List<NegocioModel> negocios = Get.arguments;

    return InteractiveMapsMarker( 
      items:  negocios.map((negocio) => MarkerItem(id: negocio.id, latitude: negocio.lat, longitude:negocio.lng)
                            ).toList(),
      center: LatLng(negocios[0].lat,negocios[0].lng),
      zoom: 15,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            
            Get.toNamed('detalles', arguments: negocios[index]);
          },
                  child: Material(
            borderRadius: BorderRadius.circular(25),
            color: Colors.black,
            child: Container( 
              width: Get.width * 1,
              child: Row(
                children: <Widget>[
                  Container(
                  width: 140,
                  decoration: BoxDecoration(
                    image: DecorationImage(image: NetworkImage(negocios[index].foto), fit: BoxFit.cover),
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left:8.0, top: 8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(negocios[index].nombre, style: GoogleFonts.roboto(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                      Text(negocios[index].ubicacion, style: GoogleFonts.roboto(color: Colors.white, fontSize: 14)),
                      _estrellas(5),
                    ],
                  ),
                )
                ],
              )
            ),
          ),
        );
      },
    );

  }

   Widget _estrellas(int rank) {
    List<Widget> list = new List<Widget>();
    for(var i = 0; i < rank; i++){
        list.add(Icon(EvaIcons.star, color: Color(0xffff5722), size: 17,));
    }
    return new Row(children: list);
  }
}