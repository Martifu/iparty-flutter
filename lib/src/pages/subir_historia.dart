
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:IParty/src/models/negocio_model.dart';
import 'package:IParty/src/models/usuario_info_model.dart';
import 'package:IParty/src/providers/negocio_provider.dart';
import 'package:IParty/src/providers/publitio_provider.dart';
import 'package:provider/provider.dart';
import 'package:search_choices/search_choices.dart';
 

class SubirHistoria extends StatefulWidget {
  @override
  _SubirHistoriaState createState() => _SubirHistoriaState();
}


class _SubirHistoriaState extends State<SubirHistoria> {

   bool _imagePickerActive = false;
  bool _uploading = false;
  String descripcion;
  int idNegocio;
  var scrollController;
  Historia historia;
   PickedFile videoFile;
  UsuarioInfo usuario = Get.arguments;
  var selectedValueSingleDialog;

  @override
  void initState() {
    scrollController = ScrollController();
    super.initState();
  }

  void _takeVideo(UsuarioInfo usuario) async {

    print(usuario.id);

    if (_imagePickerActive) return;

    final _picker = ImagePicker();
    _imagePickerActive = true;
     videoFile =
        await _picker.getVideo(source: ImageSource.camera);
    _imagePickerActive = false;
    if (videoFile == null) {
      return ;
    }



    setState(() {
    });

    
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: BackButton(color: Colors.black, onPressed: () => Get.back(),),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        floatingActionButton: Padding(
                  padding: EdgeInsets.only(right: 3),
                  child:  _botonGuardar(),
            ),
        body: Padding(
          padding:  EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            controller: scrollController,
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
               SizedBox(height: Get.height * .05,),
               _botonElegir(),
               SizedBox(height: Get.height * .05,),
              _elegirNegocio(),
               SizedBox(height: Get.height * .05,),
              _comentarios(),
              SizedBox(height: 200,),

              ],
            ),
          ),
        ),
    );
  }

  _comentarios() {

    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Text('Agrega una descripción', style: GoogleFonts.roboto(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 22),),
          ],
        ),
        SizedBox(height: 10,),
        Row(
          children: <Widget>[
           Container(
             width: Get.width * .8,

             child: TextFormField( 
               onTap: () {
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
                      descripcion = value;
                    });
                  },
                ),
           ),
          ],
        ),

      ],
    );
  }

  _botonGuardar() {
    final negocioProvider = Provider.of<NegocioProvider>(context, listen: false);

    return ButtonTheme(
      minWidth: Get.width * .9,
      height: Get.height * .08,
      child:  RaisedButton(
        onPressed: () async {
          if (selectedValueSingleDialog == null || videoFile== null ) {
            
            Get.snackbar('Ups!', 'Complete todos los campos',
             snackPosition: SnackPosition.TOP,
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              borderColor:Colors.red,
              borderWidth: 1,
              
              );
       
          } else {
                Get.dialog(
                  Center(child: CircularProgressIndicator()),
                  barrierDismissible: false
                );
                setState(() {
                  _uploading = true;
                });

                try {
                  
                  historia = await PublitioProvider.uploadVideo(videoFile);
                  
                  historia.idUsuario = usuario.id;
                  historia.idNegocio = selectedValueSingleDialog;
                  historia.descripcion = descripcion; 
                  final resp = await negocioProvider.guardarHistoria(historia);
                  if (resp==200) {
                    Get.offAllNamed('home');
                    Get.snackbar('Listo!', 'Tu historia se ha subido, revisala en las historias del negocio',
                      backgroundColor: Colors.white,
                        snackPosition: SnackPosition.TOP,
                          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                          borderColor:Colors.red,
                          borderWidth: 1,
                      );
                  } else {
                    Get.snackbar('Error', 'Algo ha salido mal',
                      backgroundColor: Colors.white,
                        snackPosition: SnackPosition.TOP,
                          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                          borderColor:Colors.red,
                          borderWidth: 1,
                      );
                  }
                  
                } on PlatformException catch (e) {
                  print('${e.code}: ${e.message}');
                  //result = 'Platform Exception: ${e.code} ${e.details}';
                } finally {
                  setState(() {
                    videoFile =null;
                    _uploading = false;
                  });
                }
             

          }
        },
        color: Color(0xffff5722),
        textColor: Colors.red,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        child: (!_uploading) ? Text('SUBIR', style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: .5
        ),) : 
         Text('SUBIENDO...', style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: .5
        ),),
        
        ),
    );  
  }

  _botonElegir() {
    return GestureDetector(
      onTap: () => _takeVideo(usuario),
      child: Container(
        width: Get.width * .8,
        height: Get.height * .07,
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xffff5722), width: 2),
          borderRadius: BorderRadius.circular(25)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
             Text('Elige una historia', style:  GoogleFonts.roboto(
               fontWeight: FontWeight.bold, fontSize: 20
             ),),
             SizedBox(width: 5,),
              Icon(FontAwesomeIcons.camera, size: 15,)
          ],
        ),
      ),
    );
  }

  _elegirNegocio() {
    final negocioProvider = Provider.of<NegocioProvider>(context);
    List<DropdownMenuItem> items =
      negocioProvider.todos.map((exNum) {
      return (DropdownMenuItem(child: Text(exNum.nombre), value: exNum.id));
    }).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Text('¿Dónde estás de fiesta?', style: GoogleFonts.roboto(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 22),),
          ],
        ),
        SizedBox(height: 10,),
        Container(
            width: Get.width * .8,
            height: Get.height * .1,
          decoration: BoxDecoration(
            border: Border.all(width: 2, color: Color(0xffff5722)),
            borderRadius: BorderRadius.circular(25)
          ),
          child: SearchChoices.single(
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),
              items: items,
              value: selectedValueSingleDialog,
              hint: "Selecciona un lugar",
              underline: Container(),
              searchHint: "Selecciona un lugar",
              onChanged: (value) {
                setState(() {
                  selectedValueSingleDialog = value;
                });
                print(selectedValueSingleDialog);
              },
              isExpanded: true,
            ),
        ),
      ],
    );
  }
}