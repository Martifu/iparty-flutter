import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iparty/src/models/negocio_model.dart';


 
class EventoView extends StatelessWidget {

  final Evento evento = Get.arguments;
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.black,
        body: Container(
          width: Get.width,
          height: Get.height,
          child: Image(
            image: NetworkImage(evento.foto),
          ),
        ),
      );
  }
}