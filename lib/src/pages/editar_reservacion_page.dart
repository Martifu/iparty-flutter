import 'package:IParty/src/models/reservacion_model.dart';
import 'package:IParty/src/providers/negocio_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';
 
class EditarReservacionPage extends StatefulWidget {

  @override
  _EditarReservacionPageState createState() => _EditarReservacionPageState();
}

class _EditarReservacionPageState extends State<EditarReservacionPage> {

 DateTime selectedDate = DateTime.now() ;
  int personas;
  String zona;
  String comentarios;
  ReservacionModel reservacionModel = ReservacionModel();

  TextEditingController personasController = new TextEditingController();
  var scrollController;

  @override
  Widget build(BuildContext context) {
    final ReservacionModel reservacion = Get.arguments;

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
               SizedBox(height: Get.height * .08,),
               _lugar(reservacion),
                SizedBox(height: Get.height * .03,),
               _fecha(reservacion),
                SizedBox(height: Get.height * .03,),
              _personas(reservacion),
               SizedBox(height: Get.height * .03,),
              _comentarios(reservacion),
              SizedBox(height: Get.height * .1,),

              _botonGuardar(reservacion)
              ],
            ),
          ),
        ),
    );
  }

  _botonGuardar(ReservacionModel reservacion) {
    final negocioProvider = Provider.of<NegocioProvider>(context, listen: false);


    return ButtonTheme(
      minWidth: Get.width * .9,
      height: Get.height * .08,
      child: RaisedButton(
        onPressed: (){
          if (reservacion.personas == null) {
            
            Get.snackbar('Ups!', 'Complete todos los campos',
             snackPosition: SnackPosition.TOP,
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              borderColor:Colors.red,
              borderWidth: 1,
              
              );
       
          } else {
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
                            
                            text: '¿Es correcta la\ninformación de tu\nreservación en\n',
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
                                }, child: Text('Editar', style: GoogleFonts.roboto(fontWeight: FontWeight.bold, fontSize: 22))),

                                FlatButton(onPressed: () async{
                                  var resp = await negocioProvider.editarReservacion(reservacion);
                                  if (resp == 'Reservavion editada con exito') {
                                    Get.back(); 
                                    Get.offAllNamed('home');
                                    Get.snackbar('Listo!', 'Tu reservación ha sido editada con exito!',
                                    snackPosition: SnackPosition.TOP,
                                      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                      borderColor:Colors.red,
                                      borderWidth: 1,
                                      backgroundColor: Colors.white
                                    );
                                  } else {
                                    Get.back(); 
                                    Get.snackbar('Error!', 'Algo salio mal!',
                                    snackPosition: SnackPosition.TOP,
                                      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                      borderColor:Colors.red,
                                      borderWidth: 1,
                                    );
                                  }
                                  
                                }, child: Text('Enviar', style: GoogleFonts.roboto(fontWeight: FontWeight.bold, fontSize: 22))),
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
        },
        color: Color(0xffff5722),
        textColor: Colors.red,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text('GUARDAR', style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: .5
        ),),
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


  _personas(ReservacionModel reservacion) {

    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Text('NÚMERO DE PERSONAS', style: GoogleFonts.roboto(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 22),),
          ],
        ),
        Row(
          children: <Widget>[
           Container(
             width: Get.width * .2,

             child: TextFormField( 
               initialValue: reservacion.personas.toString(),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                      WhitelistingTextInputFormatter.digitsOnly
                  ],
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffff5722), width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black12, width: 1.5),
                    ),
                    border: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffff5722), width: 2.0),
                    ),
                    hintText: '',
                    labelStyle: TextStyle(color: Colors.black, fontSize: 12),
                  ),
                  onChanged: (value) {
                    setState(() {
                      reservacion.personas= int.parse(value);
                    });
                  },
                ),
           ),
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
           Container(
             width: Get.width * .8,

             child: TextFormField(
               initialValue: reservacion.zona, 
               onTap: () {
                  scrollController.jumpTo(1200,
                      duration: Duration(milliseconds: 500), curve: Curves.ease);
                 /*_scrollController.animateTo(
                    scrollPosition.maxScrollExtent,
                    duration: new Duration(milliseconds: 200),
                    curve: Curves.easeOut,
                  );*/
               },
               maxLines: 5,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffff5722), width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black12, width: 1.5),
                    ),
                    border: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffff5722), width: 2.0),
                    ),
                    hintText: '',
                    labelStyle: TextStyle(color: Colors.black, fontSize: 12),
                  ),
                  onChanged: (value) {
                    setState(() {
                      reservacion.zona = value;
                    });
                  },
                ),
           ),
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
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black12,width: 1.5  ),
                borderRadius: BorderRadius.circular(5)
              ),
              child: FlatButton(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: Get.width*.2),
                onPressed: () {
                  print(reservacion.dia);
                    DatePicker.showDateTimePicker(context,
                      theme: DatePickerTheme(
                        doneStyle: TextStyle(color: Colors.red)
                      ),
                      showTitleActions: true,
                      minTime: DateTime.now(), 
                      onChanged: (date) {
                    print('change $date');
                  }, onConfirm: (date) {
                    
                    setState(() {
                      reservacion.dia = date; 
                    });
                  }, currentTime: reservacion.dia, locale: LocaleType.es);
                },
                child: (reservacion.dia == null) ? Text(
                    'Selecciona tu hora de reservación',
                    style: TextStyle(color: Colors.red),
                ) : Text(
                   Jiffy(reservacion.dia).yMMMEdjm,
                    style: TextStyle(color: Colors.red),
                )),
            ),
          ],
        ),

      ],
    );
  }

  
}