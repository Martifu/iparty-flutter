import 'package:IParty/src/models/reservacion_model.dart';
import 'package:IParty/src/providers/info_user_provider.dart';
import 'package:IParty/src/providers/negocio_provider.dart';
import 'package:IParty/src/utils/socket_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:IParty/src/models/negocio_model.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';
 
 
class CrearReservacion extends StatefulWidget {
  @override
  _CrearReservacionState createState() => _CrearReservacionState();
}
 
class _CrearReservacionState extends State<CrearReservacion> {
  DateTime selectedDate = DateTime.now() ;
  int personas;
  String zona;
  String comentarios;
  final _socketClient = SocketClient(); 
  ReservacionModel reservacionModel = ReservacionModel();




  TextEditingController personasController = new TextEditingController();
  var scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    connectSocket();
  }

  @override
  void dispose() {
    super.dispose();
    _socketClient.disconnect();

  }

  connectSocket() async {
    final usuario = Provider.of<UsuarioInfoProvider>(context, listen: false);
    await _socketClient.connect(usuario.usuarioInfo.id.toString());
    
  }

  

  @override
  Widget build(BuildContext context) {

    final NegocioModel negocio = Get.arguments;

    return  Scaffold(
        appBar: AppBar(
          leading: BackButton(color: Colors.black, onPressed: () => Get.back(),),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        floatingActionButton: Padding(
                  padding: EdgeInsets.only(right: 3),
                  child:  _botonGuardar(negocio),
            ),
        body: Padding(
          padding:  EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            controller: scrollController,
            scrollDirection: Axis.vertical,
            child: Column(
              children: <Widget>[
               SizedBox(height: Get.height * .1,),
               _lugar(negocio),
               SizedBox(height: 40,),
               _horayfecha(negocio),
               SizedBox(height: 40,),
              _personas(),
              SizedBox(height: 40,),
              _comentarios(),
              SizedBox(height: 200,),

              ],
            ),
          ),
        ),
    );
  }

  _botonGuardar(NegocioModel negocio) {
    final usuario = Provider.of<UsuarioInfoProvider>(context, listen: false);
    final negocioProvider = Provider.of<NegocioProvider>(context);

    return ButtonTheme(
      minWidth: Get.width * .9,
      height: Get.height * .08,
      child: RaisedButton(
        onPressed: (){
          if (personasController.text.isEmpty) {
            
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
                                text: negocio.nombre,
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
                                FlatButton(onPressed: ()async {
                                  Get.back();
                                }, child: Text('Editar', style: GoogleFonts.roboto(fontWeight: FontWeight.bold, fontSize: 22))),

                                FlatButton(onPressed: () async {
                                  reservacionModel.idNegocio = negocio.id;
                                  reservacionModel.idUsuario = usuario.usuarioInfo.id;
                                  reservacionModel.personas = personas;
                                  reservacionModel.zona = comentarios;
                                  reservacionModel.dia = selectedDate;
                                  _socketClient.reservacion(reservacionModel, usuario.usuarioInfo.nombre, negocio.id.toString()+negocio.nombre);
                                  Get.back();
                                  Get.offAllNamed('home');
                                  await negocioProvider.getReservaciones();

                                  Get.snackbar('Listo!', 'Tu reservación ha sido recibida!',
                                  snackPosition: SnackPosition.TOP,
                                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                    borderColor:Colors.red,
                                    borderWidth: 1,
                                    backgroundColor: Colors.white
                                    );
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
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text('ENVIAR', style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: .5
        ),),
        ),
    );  
  }

  _lugar(NegocioModel negocio) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Text('LUGAR', style: GoogleFonts.roboto(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 22),),
          ],
        ),
        Row(
          children: <Widget>[
            Text(negocio.nombre, style: GoogleFonts.roboto(color: Color(0xffff5722), fontWeight: FontWeight.bold, fontSize: 32),),
          ],
        ),

      ],
    );
  }

  _horayfecha(NegocioModel negocio) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Text('HORA Y FECHA', style: GoogleFonts.roboto(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 22),),
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
            ),
          ],
        ),

      ],
    );
  }

  _personas() {

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
                  controller: personasController,
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
                      personas = int.parse(value);
                    });
                  },
                ),
           ),
          ],
        ),

      ],
    );
    
  }

  _comentarios() {

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
               onTap: () {
                  scrollController.jumpTo(1200,
                      duration: Duration(milliseconds: 500), curve: Curves.ease);
                 /*_scrollController.animateTo(
                    scrollPosition.maxScrollExtent,
                    duration: new Duration(milliseconds: 200),
                    curve: Curves.easeOut,
                  );*/
               },
               maxLines: 8,
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
                      comentarios = value;
                    });
                  },
                ),
           ),
          ],
        ),

      ],
    );
  }
}