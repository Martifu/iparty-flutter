import 'package:IParty/src/models/reservacion_model.dart';
import 'package:IParty/src/providers/negocio_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';
 
class InfoReservacionPage extends StatefulWidget {

  @override
  _InfoReservacionPageState createState() => _InfoReservacionPageState();
}

class _InfoReservacionPageState extends State<InfoReservacionPage> {

  DateTime selectedDate = DateTime.now() ;

  @override
  Widget build(BuildContext context) {
    final ReservacionModel reservacion = Get.arguments;
    final negocioProvider = Provider.of<NegocioProvider>(context, listen: false);

    return  Scaffold(
        appBar: AppBar(
          leading: BackButton(color: Colors.black, onPressed: () => Get.back(),),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        floatingActionButton: Padding(
                  padding: EdgeInsets.only(right: 3),
                  //child:  _botonGuardar(reservacion),
            ),
        body: Padding(
          padding:  EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: <Widget>[
               SizedBox(height: Get.height * .1,),
               _lugar(reservacion),
               SizedBox(height: 30,),
               _fecha(reservacion),
               SizedBox(height: 30,),
              _personas(reservacion),
               SizedBox(height: 30,),
              _comentarios(reservacion),
               SizedBox(height: 100,),
              RaisedButton(
                child: Container(
                  width: Get.width *.8,
                  height: Get.height * .07,
                  //padding: EdgeInsets.symmetric( horizontal: 80.0, vertical: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Editar reservación', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                    ],
                  ),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)
                ),
                elevation: 0.0,
                color: Color(0xffFF5722),
                textColor: Colors.white, 
                onPressed: ()=>Get.toNamed('editar_reservacion', arguments: reservacion)
              ),
              SizedBox(height: 10,),
              RaisedButton(
                child: Container(
                  width: Get.width *.8,
                  height: Get.height * .07,
                  //padding: EdgeInsets.symmetric( horizontal: 80.0, vertical: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Cancelar reservación',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)
                ),
                elevation: 0.0,
                color: Colors.black,
                textColor: Colors.white, 
                onPressed: (){
                  Get.dialog(
                Material(
                  color: Colors.transparent,
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                      color: Colors.white,
                        borderRadius: BorderRadius.circular(25)
                      ),
                      width: Get.width * .7,
                      height: Get.height * .35,
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: Get.height * .09,),
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                            
                            text: '¿Seguro que\ndeseas cancelar tu\nreservación en\n',
                            style: GoogleFonts.roboto(
                                  color: Colors.black,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                            children: <TextSpan>[
                              TextSpan(
                                text: reservacion.negocio.nombre,
                                style: GoogleFonts.roboto(
                                  color: Color(0xffff5722),
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold
                                )
                              ),
                              TextSpan(
                                text: '?',
                                style: GoogleFonts.roboto(
                                  color: Colors.black,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold
                                )
                              )
                            ]
                          ) 
                          ),
                          Expanded(child: Container(),),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 25),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                FlatButton(onPressed: (){
                                  Get.back();
                                }, child: Text('No', style: GoogleFonts.roboto(fontWeight: FontWeight.bold, fontSize: 22))),

                                FlatButton(onPressed: () async {
                                  var resp = await negocioProvider.cancelarReservacion(reservacion.id);
                                  if (resp == 'Reservavion cancelada con exito') {
                                    Get.back();
                                    Get.offAllNamed('home');
                                    Get.snackbar('Listo!', 'Tu reservación ha sido cancelarda!',
                                      snackPosition: SnackPosition.TOP,
                                      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                      borderColor:Colors.red,
                                      borderWidth: 1,
                                      backgroundColor: Colors.white
                                    );
                                  } else {
                                    Get.snackbar('Error', 'Algo salió mal',
                                    snackPosition: SnackPosition.TOP,
                                      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                      borderColor:Colors.red,
                                      borderWidth: 1,
                                      );
                                  }
                                  
                                }, child: Text('Sí', style: GoogleFonts.roboto(fontWeight: FontWeight.bold, fontSize: 22))),
                              ],
                            ),
                          )
                        ],
                      ),
                      
                      ),
                  ),
                )
              );
                }
              ),
              ],
            ),
          ),
        ),
    );
  }

  _lugar(ReservacionModel reservacion) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Text('LUGAR', style: GoogleFonts.roboto(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 22),),
          ],
        ),
        Row(
          children: <Widget>[
            Text(reservacion.negocio.nombre, style: GoogleFonts.roboto(color: Color(0xffff5722), fontWeight: FontWeight.bold, fontSize: 32),),
          ],
        ),

      ],
    );
  }

  _fecha(ReservacionModel reservacion) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Text('FECHA', style: GoogleFonts.roboto(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 22),),
          ],
        ),
        Row(
          children: <Widget>[
            Text(Jiffy(reservacion.dia).yMMMEdjm, style: GoogleFonts.roboto(color: Color(0xffff5722), fontWeight: FontWeight.bold, fontSize: 32),),
            /*Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black12,width: 1.5  ),
                borderRadius: BorderRadius.circular(5)
              ),
              child: FlatButton(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: Get.width*.2),
                onPressed: () {
                    DatePicker.showDateTimePicker(context,
                      theme: DatePickerTheme(
                        doneStyle: TextStyle(color: Colors.red)
                      ),
                      showTitleActions: true,
                      minTime: reservacion.dia, 
                      onChanged: (date) {
                    print('change $date');
                  }, onConfirm: (date) {
                    
                    setState(() {
                      selectedDate = date; 
                    });
                  }, currentTime: DateTime.now(), locale: LocaleType.es);
                },
                child: (selectedDate == null) ? Text(
                    'Selecciona tu hora de reservación',
                    style: TextStyle(color: Colors.red),
                ) : Text(
                   Jiffy(selectedDate).yMMMEdjm,
                    style: TextStyle(color: Colors.red),
                )),
            ),*/
          ],
        ),

      ],
    );
  }

  _personas(ReservacionModel reservacion) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Text('N° DE PERSONAS', style: GoogleFonts.roboto(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 22),),
          ],
        ),
        Row(
          children: <Widget>[
            Text(reservacion.personas.toString(), style: GoogleFonts.roboto(color: Color(0xffff5722), fontWeight: FontWeight.bold, fontSize: 32),),
          ],
        ),

      ],
    );
  }

  _comentarios(ReservacionModel reservacion) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Text('COMENTARIOS', style: GoogleFonts.roboto(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 22),),
          ],
        ),
        Row(
          children: <Widget>[
            (reservacion.zona != null ) ? Text(reservacion.zona, style: GoogleFonts.roboto(color: Color(0xffff5722), fontWeight: FontWeight.bold, fontSize: 32),): Text('N/A', style: GoogleFonts.roboto(color: Color(0xffff5722), fontWeight: FontWeight.bold, fontSize: 32),),
          ],
        ),

      ],
    );
  }
}