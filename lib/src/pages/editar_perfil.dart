import 'dart:async';
import 'dart:io';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:IParty/src/components/image_picker_handler.dart';
import 'package:IParty/src/models/negocio_model.dart';
import 'package:IParty/src/models/usuario_info_model.dart';
import 'package:IParty/src/providers/info_user_provider.dart';
import 'package:IParty/src/providers/publitio_provider.dart';
import 'package:IParty/src/providers/usuario_provider.dart';
import 'package:provider/provider.dart';

class EditarPerfilPage extends StatefulWidget {

  @override
  _EditarPerfilPageState createState() => _EditarPerfilPageState();
}

class _EditarPerfilPageState extends State<EditarPerfilPage>   with TickerProviderStateMixin,ImagePickerListener {
  final usuarioProvider = new UsuarioProvider();
  File _image;
  AnimationController _controller;
  ImagePickerHandler imagePicker;
  bool _isLoading = false;
  bool _cambio = false;
  Timer _timer;
  TextEditingController nombreController = new TextEditingController();


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

    UsuarioInfo usuario = Get.arguments;

    final size = MediaQuery.of(context).size;
    
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SizedBox( height: 20.0 ),
          Text('¡Bienvenido!', style: GoogleFonts.roboto(
            textStyle: TextStyle(fontSize: 26, fontWeight: FontWeight.bold) 
          )),
          SizedBox( height: 20.0 ),
          _crearImagenPicker(context, usuario),
          Container(
            width: size.width,
            padding: EdgeInsets.symmetric( vertical: 20.0 ),
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
                children: <Widget>[
                  SizedBox( height: 40.0 ),
                   _crearNombre(usuario),
                  SizedBox( height: 10.0 ),
                  _crearBoton( ),
                ],
              ),
            
          ), 
          SizedBox( height: 100.0 )
        ],
      ),
    );


  }

 


  Widget _crearBoton() {

    // formValidStream
    // snapshot.hasData
    //  true ? algo si true : algo si false

    return RaisedButton(
          child: Container(
          padding: EdgeInsets.symmetric(horizontal: Get.width / 2.8, vertical: 20),
            child: Text('Guardar'),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0)
          ),
          elevation: 0.0,
          color: Color(0xffff5722),
          textColor: Colors.white,
          onPressed:  (){
            if ( nombreController.text.length < 6) {
              Get.snackbar('Error', 'Tu nombre debe contener mas de 5 caracteres',
               snackPosition: SnackPosition.BOTTOM, 
               borderWidth: 1,
               borderColor: Colors.red,
               margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10));
            } else {
              print('ssss');
              _actualizar();
            }
            
          }
        );
  }

  

  Widget _crearImagenPicker(context, UsuarioInfo usuario) {
     GetStorage box = new GetStorage();
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
                image:  DecorationImage(image: NetworkImage(box.read('foto')), fit: BoxFit.cover) ,
              color: Colors.black12,
              ),
              width: Get.width * .4,
              height: Get.width * .4,
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
                icon: Icon(EvaIcons.editOutline, size: 25, color: Colors.white,), onPressed: (){
                   imagePicker.showDialog(context);
                }
                )
         ),
          )
        ],
    );
  }

  Widget _crearNombre(UsuarioInfo usuarioInfo ) {
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
              child: TextFormField( 
                controller: nombreController,
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
                  labelStyle: TextStyle(color: Colors.black, fontSize: 12),
                ),
              ),
            ),

          ),
        ],
      );
  }

 

  @override
  userImage(File _image) {
    setState(() {
      this._image = _image;
      this._cambio = true;
    });
  }

   _actualizar() async {
     GetStorage box = new GetStorage();
    if (_cambio) {
        Get.dialog(
          Center(child: CircularProgressIndicator()),
          barrierDismissible: false
        );

        Historia imagen = await PublitioProvider.uploadProfile(_image);
        usuarioProvider.editarInfo(nombreController.text, imagen.urlFile);
        Provider.of<UsuarioInfoProvider>(context, listen: false).clearInfo();
        Provider.of<UsuarioInfoProvider>(context, listen: false).getInfo();
        setState(() {
           this._cambio = true;
          
        });
        _timer = new Timer(const Duration(seconds: 3), () {
            Get.back();
            Get.offAllNamed('home');
         });
        

    } else {
      print(nombreController.text);
      Get.dialog(
          Center(child: CircularProgressIndicator()),
          barrierDismissible: false
        );
        usuarioProvider.editarInfo(nombreController.text, box.read('foto'));
        Provider.of<UsuarioInfoProvider>(context, listen: false).clearInfo();
        Provider.of<UsuarioInfoProvider>(context, listen: false).getInfo();
        _timer = new Timer(const Duration(seconds: 3), () {
            Get.back();
            Get.offAllNamed('home');
         });
    }
  }

 
  
 
}