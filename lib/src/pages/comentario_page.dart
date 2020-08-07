import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iparty/src/models/negocio_model.dart';
import 'package:iparty/src/providers/info_user_provider.dart';
import 'package:iparty/src/providers/negocio_provider.dart';
import 'package:provider/provider.dart';
 
 
class ComentarioPage extends StatefulWidget {
  @override
  _ComentarioPageState createState() => _ComentarioPageState();
}

class _ComentarioPageState extends State<ComentarioPage> {


  int rat = 0;
  String comentarios;
  TextEditingController comentariosController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    final info = Provider.of<UsuarioInfoProvider>(context);
    final NegocioModel negocio = Get.arguments;
    final negocioProvider = Provider.of<NegocioProvider>(context);
    
    GetStorage box = GetStorage();
    return Scaffold(
      backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(color: Colors.black, icon: Icon(FontAwesomeIcons.arrowLeft, color: Colors.black,), onPressed: () => Get.back(),),
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: Text('Dános tu comentario', style: GoogleFonts.roboto(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),),
        ),
        body: SingleChildScrollView(
                  child: Padding(
            padding:  EdgeInsets.symmetric(vertical: 20, horizontal: 30),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                          width: Get.width * .13,
                          height: Get.width * .13,
                          decoration: BoxDecoration(
                            image: DecorationImage(image: NetworkImage(box.read('foto')), fit: BoxFit.cover),
                            shape: BoxShape.circle,
                            border: Border.all(color: Color(0xffDA4720), width: 2)
                          ),
                    ),
                    SizedBox(width: 30,),
                    RatingBar(
                      initialRating: 0,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: false,
                      itemCount: 5,
                      glowColor: Color(0xffff5722).withOpacity(.5),
                      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => Icon(
                        EvaIcons.star,
                        color: Color(0xffff5722),
                      ),
                      onRatingUpdate: (rating) {
                        rat = rating.toInt();
                        setState(() {
                          
                        });
                        print(rat.toString());
                      },
                    )
                  ],
                ),
                SizedBox(height: 30,),
                _comentarios(),
                SizedBox(height: 20,),
                RaisedButton(
                  child: Container(
                    padding: EdgeInsets.symmetric( horizontal:100.0, vertical: 20.0),
                    child: Text('Publicar comentario'),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40.0)
                  ),
                  elevation: 0.0,
                  color: Colors.black,
                  textColor: Colors.white, 
                  onPressed: ()=>{
                    
                    if (rat == 0 ) {
                      Get.snackbar('Ups!', 'Complete todos los campos',
                      snackPosition: SnackPosition.TOP,
                        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        borderColor:Colors.red,
                        borderWidth: 1,
                        )
                    } else if (comentariosController.text.length < 6 || comentariosController.text.isEmpty) {
                      Get.snackbar('Dinos más', 'Tu comentario debe tener mas de 6 caracteres',
                      snackPosition: SnackPosition.TOP,
                        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        borderColor:Colors.red,
                        borderWidth: 1,
                        )
                    } else {
                       
                        FocusScope.of(context).requestFocus(new FocusNode()),
                       negocioProvider.comentario(negocio.id, info.usuarioInfo.id, comentarios, rat),
                        Get.back(),
                        Get.snackbar('Listo!', 'Gracias por tus comentarios',
                        backgroundColor: Colors.white,
                          snackPosition: SnackPosition.TOP,
                            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                            borderColor:Colors.red,
                            borderWidth: 1,
                        ),

                    }
                  }
                )
              ],
            ),
          ),
        )
    );
  }

  _comentarios() {

    return Column(
      children: <Widget>[
        
        Row(
          children: <Widget>[
           Container(
             width: Get.width * .85,

             child: TextFormField( 
              
              controller: comentariosController,
               maxLines: 8,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffff5722), width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black38, width: 1.5),
                    ),
                    border: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffff5722), width: 2.0),
                    ),
                    hintText: 'Escribe aquí tu opinión...',
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