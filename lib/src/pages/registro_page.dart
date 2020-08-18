import 'dart:io';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:IParty/src/bloc/provider_registro.dart';
import 'package:IParty/src/bloc/registro_bloc.dart';
import 'package:IParty/src/components/image_picker_handler.dart';
import 'package:IParty/src/models/negocio_model.dart';
import 'package:IParty/src/models/usuario_model.dart';
import 'package:IParty/src/providers/info_user_provider.dart';
import 'package:IParty/src/providers/publitio_provider.dart';
import 'package:IParty/src/providers/usuario_provider.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';

class RegistroPage extends StatefulWidget {

  @override
  _RegistroPageState createState() => _RegistroPageState();
}

class _RegistroPageState extends State<RegistroPage>   with TickerProviderStateMixin,ImagePickerListener {
  final usuarioProvider = new UsuarioProvider();
  File _image;
  AnimationController _controller;
  ImagePickerHandler imagePicker;
  bool _isLoading = false;
  String selectedDate = '' ;


  @override
  void initState() { 
    PublitioProvider.configurePublitio();
    super.initState();
    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    imagePicker=new ImagePickerHandler(this,_controller);
    imagePicker.init();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(icon: Icon(FontAwesomeIcons.arrowLeft, color: Colors.white), onPressed: () => Navigator.of(context).pop()),
        elevation: 0,
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Image.asset('assets/img/logo.png', height: 25,),
      ),
      body: Stack(
        children: <Widget>[
          (_isLoading) ? Container(color: Colors.black12 ,width: Get.width, height: Get.height, child: Center(child: CircularProgressIndicator(),),) :_loginForm( context ),
        ],
      )
    );
  }

  Widget _loginForm(BuildContext context) {

    final bloc = ProviderRegistro.of(context);

    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SizedBox( height: 20.0 ),
          Text('¡Bienvenido!', style: GoogleFonts.roboto(
            textStyle: TextStyle(fontSize: 26, fontWeight: FontWeight.bold) 
          )),
          SizedBox( height: 20.0 ),
          _crearImagenPicker(context),
          Container(
            width: size.width,
            padding: EdgeInsets.symmetric( vertical: 20.0 ),
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
                children: <Widget>[
                  SizedBox( height: 40.0 ),
                   _crearNombre(bloc),
                  SizedBox( height: 10.0 ),
                  _crearEmail( bloc ),
                  SizedBox( height: 10.0 ),
                  _crearPassword( bloc ),
                  SizedBox( height: 10.0 ),
                  _crearFecha(),
                  SizedBox( height: 30.0 ),
                  _crearBoton( bloc ),
                  SizedBox( height: 10.0 ),
                  _crearIniciar(context)
                ],
              ),
            
          ), 
          SizedBox( height: 100.0 )
        ],
      ),
    );


  }

  Widget _crearEmail(RegistroBloc bloc) {

    return StreamBuilder(
      stream: bloc.emailStream,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
           Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Text('CORREO ELECTRÓNICO', style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Container(
              child: TextField( 

                keyboardType: TextInputType.emailAddress,
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
                  hintText: 'ejemplo@correo.com',
                  labelStyle: TextStyle(color: Colors.black, fontSize: 12),
                  errorText: snapshot.error,
                ),
                onChanged: bloc.changeEmail,
              ),
            ),

          ),
        ],
      );


      },
    );


  }

  Widget _crearPassword(RegistroBloc bloc) {

    return StreamBuilder(
      stream: bloc.passwordStream,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Text('CONTRASEÑA', style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                obscureText: true,
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
                    hintText: 'Ingresa tu contraseña',
                    errorText: snapshot.error
                  ),
                onChanged: bloc.changePassword,
              ),

            ),
          ],
        );

      },
    );
  }


  Widget _crearBoton( RegistroBloc bloc) {

    // formValidStream
    // snapshot.hasData
    //  true ? algo si true : algo si false

    return StreamBuilder(
      stream: bloc.formValidStream,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        
        return RaisedButton(
          child: Container(
            padding: EdgeInsets.symmetric( horizontal: 80.0, vertical: 15.0),
            child: Text('Resgistrarme'),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0)
          ),
          elevation: 0.0,
          color: Color(0xffff5722),
          textColor: Colors.white,
          onPressed: snapshot.hasData ? ()=> _register(bloc, context, _image) : null
        );
      },
    );
  }

  _register(RegistroBloc bloc, BuildContext context, File image) async {
        Get.dialog(
        Center(child: CircularProgressIndicator()),
        barrierDismissible: false
         );
        FocusScope.of(context).requestFocus(new FocusNode());
          print(image);
          if (image == null) {
            UsuarioModel usuario = new UsuarioModel();
            usuario.nombre = bloc.nombre;
            usuario.email = bloc.email;
            usuario.password = bloc.password;
            usuario.fechaNacimiento = selectedDate;
            usuario.foto = 'https://media.publit.io/file/no-image.png';
            final status = await usuarioProvider.signup(usuario);
            if (status==200) {
              Get.offAllNamed('home');
            } else if (status['code'] == 202) {
              Get.back();
              Get.snackbar('Error', status['message'], snackPosition: SnackPosition.BOTTOM, margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              borderWidth: 1, borderColor: Colors.orange);
            }
          } else {
            Historia imagen = await PublitioProvider.uploadProfile(image);
            UsuarioModel usuario = new UsuarioModel();
            usuario.nombre = bloc.nombre;
            usuario.email = bloc.email;
            usuario.password = bloc.password;
            usuario.fechaNacimiento = selectedDate;
            usuario.foto = imagen.urlFile;
            final status = await usuarioProvider.signup(usuario);
            if (status==200) {
              Get.offAllNamed('home');
              Provider.of<UsuarioInfoProvider>(context, listen: false).clearInfo();
              Provider.of<UsuarioInfoProvider>(context, listen: false).getInfo();
            } else if (status['code'] == 202) {
              Get.back();
              Get.snackbar('Error', status['message'], snackPosition: SnackPosition.BOTTOM, margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              borderWidth: 1, borderColor: Colors.orange);
            }
          }  
  }

  Widget _crearImagenPicker(context) {
    final size = MediaQuery.of(context).size;

    return  Stack(
        children: <Widget>[
          _image == null ? GestureDetector(
            onTap:  () => {
                imagePicker.showDialog(context),
                print('object')
              },
             child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
              color: Colors.black12,
              ),
              width: size.width * .35,
              height: size.height* .18,
              child: Icon(EvaIcons.person, size: 50, color: Colors.white,),
            ),
          ) : Container(
                  height: 140.0,
                  width: 140.0,
                  decoration: new BoxDecoration(
                    color: const Color(0xff7c94b6),
                    image: new DecorationImage(
                      image: new FileImage(_image),
                      fit: BoxFit.cover,
                    ),
                    border:
                        Border.all(color: Color(0xffff5722), width: 2.0),
                    borderRadius:
                        new BorderRadius.all(const Radius.circular(80.0)),
                  ),
                ),
          Positioned(
            right: 1,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xffff5722),
              ),
              child: IconButton( 
                icon: Icon(EvaIcons.cameraOutline, size: 25, color: Colors.white,), onPressed: (){
                   imagePicker.showDialog(context);
                }
                )
         ),
          )
        ],
    );
  }

  Widget _crearNombre(RegistroBloc bloc) {
    return StreamBuilder(
      stream: bloc.nombreStream,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
           Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Text('NOMBRE Y APELLIDOS', style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Container(
              child: TextField( 

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
                  hintText: 'Ingresa tu nombre completo',
                  labelStyle: TextStyle(color: Colors.black, fontSize: 12),
                  errorText: snapshot.error,
                ),
                onChanged: bloc.changeNombre,
              ),
            ),

          ),
        ],
      );


      },
    );
  }

  Widget _crearIniciar(BuildContext context) {
    return Material(
      color: Colors.white,
          child: InkWell(
            onTap: (){
              Get.toNamed('login');
            },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child:  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('¿Ya tienes una cuenta? ', style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: 15), fontWeight: FontWeight.bold)), 
                        Text('Inicia sesión', style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: 15), fontWeight: FontWeight.bold, color: Color(0xffff5722)) ), 
                      ],
                    ),
                  )
          ),
    );
  }

  @override
  userImage(File _image) {
    setState(() {
      this._image = _image;
    });
  }

  _crearFecha() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Text('FECHA DE NACIMIENTO', style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
          ),
        Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black12,width: 1.5  ),
                borderRadius: BorderRadius.circular(5)
              ),
              child: FlatButton(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 100),
                onPressed: () {
                    DatePicker.showDatePicker(context,
                                          theme: DatePickerTheme(
                                            doneStyle: TextStyle(color: Colors.red)
                                          ),
                                          showTitleActions: true,
                                          minTime: DateTime(1900, 3, 5),
                                          maxTime: DateTime.now(), 
                                          onChanged: (date) {
                                        print('change $date');
                                      }, onConfirm: (date) {
                                        if (date.month < 10 && date.day < 10) {
                                          
                                          selectedDate = date.year.toString()+"-0"+date.month.toString()+"-0"+date.day.toString();
                                          setState(() {
                                            
                                          });
                                        } else if (date.day < 10) {
                                            selectedDate = date.year.toString()+"-"+date.month.toString()+"-0"+date.day.toString();
                                            setState(() {
                                            
                                          });
                                          } else if (date.month < 10) {
                                            selectedDate = date.year.toString()+"-0"+date.month.toString()+"-"+date.day.toString();
                                            setState(() {
                                            
                                          });
                                          }
                                        print(selectedDate);
                                      }, currentTime: DateTime.now(), locale: LocaleType.es);
                },
                child: (selectedDate == '') ? Text(
                    'Selecciona tu fecha de nacimiento',
                    style: TextStyle(color: Colors.red),
                ) : Text(
                   Jiffy(selectedDate).yMMMMd,
                    style: TextStyle(color: Colors.red),
                )),
            ),
      ],
    );
  }

 

 
}