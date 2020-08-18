
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:IParty/src/controllers/historia_controller.dart';
import 'package:IParty/src/models/negocio_model.dart';
import 'package:IParty/src/utils/utils_historia.dart';

import 'hiostoria_viewer.dart';

class HistoriasHorizontal extends StatelessWidget {

  final  List<Historia> historias;
  final Color primayColor = Color(0xff5c6cfc);
    final Color secondaryColor = Color(0xff0ebc7d);
    final Color primaryDark = Color(0xff2d304e);
    final Color lightColor = Color(0xffededf1);
   HistoriasHorizontal({@required this.historias});

   final pageController = new PageController(
          initialPage: 1,
          viewportFraction: .35,
        );

  @override
  Widget build(BuildContext context) {

    

    return Container(
      child: PageView(
        pageSnapping: false,
        controller: PageController(
          initialPage: 1,
          viewportFraction: .3,
        ),
        children: _tarjetas(context),
      ),
    );
  }

  List<Widget> _tarjetas(BuildContext context) {
    return historias.map((historia){
      return  GestureDetector(
        onTap: () =>  Navigator.of(context).pushNamed('ver_historia', arguments: historia ),
            child: Stack(
              children: <Widget>[
                 Hero(
                tag: historia.id,
                  child: Container(
                    width: Get.width,
                  padding: EdgeInsets.symmetric(horizontal: Get.width * .01),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                        child: Container(
                          width: Get.width,
                          height: Get.height,
                          child: Image(
                              image: NetworkImage(historia.urlMiniatura),
                              fit: BoxFit.cover,
                            ),
                            ),
                        ),
                    ),
                  ),
                  Positioned(
                    bottom: 1, 
                    left: 5,
                    child: Container(
                      width: Get.width,
                      padding: EdgeInsets.symmetric(vertical: Get.height * .01, horizontal: Get.width * .08),
                      child: Row(
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                width: Get.width * .11,
                                height: Get.width * .11, 
                                padding: EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  image: DecorationImage(image: NetworkImage(historia.usuario.foto), fit: BoxFit.cover),
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 2)
                                ),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
              ],
            ),
      );
      
      
    }).toList();
  }

 
}


class MoreStories extends StatefulWidget {
  @override
  _MoreStoriesState createState() => _MoreStoriesState();
}

class _MoreStoriesState extends State<MoreStories> {
  final storyController = StoryController();
  @override
  void dispose() {
    storyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Historia historia = ModalRoute.of(context).settings.arguments;
    
    return Stack(
      children: <Widget>[
        Scaffold(
          body: StoryView(
                    controller: storyController,
                    onVerticalSwipeComplete: (direction) {
                        if (direction == Direction.down) {
                          Get.back();
                        }
                      } ,
                    storyItems: (historia.tipo == 'video') ? [
                      StoryItem.pageVideo(historia.urlFile, imagen: historia.usuario.foto, nombreUsuario: historia.usuario.nombre.toString(), controller: storyController,duration: Duration(seconds: historia.duracion.toInt()), caption: historia.descripcion, shown: true),
                       
                    ] :  [StoryItem.pageImage(url : historia.urlFile, imagen: historia.usuario.foto, nombreUsuario: historia.usuario.nombre.toString(), controller: storyController,duration: Duration(seconds: 5), caption: historia.descripcion, shown: true) ],
                    onStoryShow: (s) {
                      print("Showing a story");
                    },
                    onComplete: () {
                        Get.back();
                    },
                    progressPosition: ProgressPosition.top,
                    repeat: false,
                    inline: true,
                  )  
        ),
        
      ],
    );
  }
}