import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iparty/src/bloc/login_bloc.dart';
import 'package:iparty/src/bloc/provider.dart';
import 'package:iparty/src/providers/info_user_provider.dart';
import 'package:iparty/src/providers/usuario_provider.dart';
import 'package:provider/provider.dart';


class LoginPage extends StatefulWidget {

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GetStorage box = GetStorage();
  @override
  void initState() {
    box.write('favoritos', []);

    super.initState();
  }
  final usuarioProvider = new UsuarioProvider();
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
           _loginForm( context ),
        ],
      )
    );
  }

  Widget _loginForm(BuildContext context) {

    final bloc = ProviderLogin.of(context);
    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            width: size.width,
            padding: EdgeInsets.symmetric( vertical: 80.0 ),
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              children: <Widget>[
                _crearLogo(),
                SizedBox( height: 60.0 ),
                _crearEmail( bloc ),
                SizedBox( height: 20.0 ),
                _crearPassword( bloc ),
                SizedBox( height: 15.0 ),
                _olvidoContrasena(),
                SizedBox( height: 40.0 ),
                _crearBoton( bloc ),
                SizedBox( height: 10.0 ),
                _crearRegistrarse(context)
              ],
            ),
          ),

          
          SizedBox( height: 100.0 )
        ],
      ),
    );


  }

  Widget _crearEmail(LoginBloc bloc) {

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

  Widget _crearPassword(LoginBloc bloc) {

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
              child: Container(
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

            ),
          ],
        );

      },
    );


  }

  Widget _crearBoton( LoginBloc bloc) {

    // formValidStream
    // snapshot.hasData
    //  true ? algo si true : algo si false

    return StreamBuilder(
      stream: bloc.formValidStream,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        
        return RaisedButton(
          child: Container(
            padding: EdgeInsets.symmetric( horizontal: 80.0, vertical: 15.0),
            child: Text('Ingresar'),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0)
          ),
          elevation: 0.0,
          color: Color(0xffFF5722),
          textColor: Colors.white,
          onPressed: snapshot.hasData ? ()=> _login(bloc, context) : null
        );
      },
    );
  }

  _login(LoginBloc bloc, BuildContext context) async {

      Get.dialog(
        Center(child: CircularProgressIndicator()),
        barrierDismissible: false
      );
      FocusScope.of(context).requestFocus(new FocusNode());
      final status = await usuarioProvider.login(bloc.email, bloc.password);
       
        if (status==200){
          Navigator.of(context).pushNamedAndRemoveUntil('home', (route) => false);
          Provider.of<UsuarioInfoProvider>(context, listen: false).clearInfo();
          Provider.of<UsuarioInfoProvider>(context, listen: false).getInfo();
          
        } else if (status==404) {
        Get.back();
        Get.snackbar('Error', 'No existe un usuario con ese email', snackPosition: SnackPosition.BOTTOM, margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        borderWidth: 1, borderColor: Colors.orange);
      } else if (status==202) {
        Get.back();
        Get.snackbar('Error', 'La contraseña que has ingresado es incorrecta', snackPosition: SnackPosition.BOTTOM, margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        borderWidth: 1, borderColor: Colors.orange);
      } 
  }

  Widget _crearLogo() {
    return Column(
      children: <Widget>[
        Image.asset('assets/img/logo.png', height: 80,),
        SizedBox(height: 10,),
        Text('IPARTY', style: GoogleFonts.shareTechMono(textStyle: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)))
      ],
    );
  }

  Widget _olvidoContrasena() {
    return Material(
      color: Colors.white,
          child: InkWell(
            onTap: (){
                  print('olvide');
            },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child:  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('¿Olvidaste tu contraseña? ', style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: 15), fontWeight: FontWeight.bold)), 
                        Text('Recupérala', style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: 15), fontWeight: FontWeight.bold, color: Color(0xffff5722)) ), 
                      ],
                    ),
                  )
          ),
    );
  }

  Widget _crearRegistrarse(BuildContext context) {
    return Material(
      color: Colors.white,
          child: InkWell(
            onTap: (){
                  Get.toNamed('registro');
            },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child:  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('¿No estás registrado? ', style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: 15), fontWeight: FontWeight.bold)), 
                        Text('Registrate aquí', style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: 15), fontWeight: FontWeight.bold, color: Color(0xffff5722)) ), 
                      ],
                    ),
                  )
          ),
    );
  }
}