
import 'package:carousel_pro/carousel_pro.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:IParty/src/components/historias_horizontal.dart';
import 'package:IParty/src/models/negocio_model.dart';
import 'package:IParty/src/providers/negocio_provider.dart';
import 'package:provider/provider.dart';



class DetallesPage extends StatefulWidget {
  @override
  _DetallesPageState createState() => _DetallesPageState();
}

class _DetallesPageState extends State<DetallesPage> {

  ScrollController _hideButtonController;
   var _isVisible;
   List<dynamic> favoritos;
  @override
  void initState() {
    
    super.initState();
    _isVisible = false;
    _hideButtonController = new ScrollController();
    _hideButtonController.addListener((){
      if(_hideButtonController.position.userScrollDirection == ScrollDirection.reverse){
        if(_isVisible == false) {
            /* only set when the previous state is false
             * Less widget rebuilds 
             */
            setState((){
              _isVisible = true;
            });
        }
      } else {
        if(_hideButtonController.position.userScrollDirection == ScrollDirection.forward){
          if(_isVisible == true) {
              /* only set when the previous state is false
               * Less widget rebuilds 
               */
               setState((){
                 _isVisible = false;
               });
           }
        }
    }});
  }

  

  @override
  build(BuildContext context) {
    final NegocioModel negocio = ModalRoute.of(context).settings.arguments;
    
    return Theme(
      data: ThemeData(
        accentColor: Color(0xffDA4720),
        accentTextTheme: TextTheme(bodyText1: TextStyle()),
        brightness: Brightness.dark,
        primaryColor: Color(0xff219762),
        backgroundColor: Color(0xFF191719),
         
      ),
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          backgroundColor:Colors.black,
          floatingActionButton: Visibility(
            visible:  _isVisible,
            child: Padding(
                  padding: EdgeInsets.only(right: Get.width * .1),
                  child:  BotonReservacion(),
            ),
          ),
          body: Stack(
            children: <Widget>[
              NestedScrollView(
                controller: _hideButtonController,
                headerSliverBuilder: (BuildContext context, bool isScrolled) {
                  return [
                    HeaderWidget(),
                    InfoWidget(),
                    SliverAppBar(
                      backgroundColor: Colors.black,
                      pinned: true,
                      floating: false,
                      bottom: PreferredSize(
                      preferredSize: Size.fromHeight(20.0),
                        child: TabBar(
                          tabs: [
                            Tab(text: "Eventos", icon: Icon(FontAwesomeIcons.calendar)),
                            Tab(text: "Menú", icon: Icon(EvaIcons.bookOpenOutline)),
                            Tab(text: "Opiniones",icon: Icon(EvaIcons.awardOutline)),
                          ],
                        ),
                      ),
                    ),
                    
                  ];
                },
                body: TabBarView(
                  children: [
                    _eventos(negocio.eventos),
                    _menu(negocio.menu),
                    myTabContainer(negocio.comentarios),
                  ],
                ),
              ),
              
            ],
          ),
        ),
      ),
    );
  }

  Widget _eventos(List<Evento> eventos) {

    if (eventos.length == 0) {
          return Center(
            child: Text('No hay eventos todavía', style: TextStyle(color: Colors.white),),
          );
        }
     return ListView.builder(
       itemCount: eventos.length,
       itemExtent: 200,
      itemBuilder: (BuildContext context, int index) {
        
        return GestureDetector(
          onTap: (){
            Get.toNamed('evento', arguments: eventos[index]);
          },
                  child: Container(
            margin: EdgeInsets.only(bottom: 10, left: 20, right: 20),
            decoration: BoxDecoration(
              image: DecorationImage(image: NetworkImage(eventos[index].foto), fit: BoxFit.cover),
              borderRadius: BorderRadius.circular(20)
            ),
            child: ListTile(
              title: Text(eventos[index].nombre, style: GoogleFonts.roboto(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
             // subtitle: Text(eventos[index].informacion, style: GoogleFonts.roboto(color: Colors.black)),     
            ),
          ),
        );
      },
    );
      
  }

  Widget myTabContainer(List comentarios)  {
    final NegocioModel negocio = ModalRoute.of(context).settings.arguments;

    final box = GetStorage();
    
    return  ListView(
      physics: ScrollPhysics(),
      children: <Widget>[
        GestureDetector(
          onTap: () {
            Get.toNamed('comentario', arguments: negocio);
          },
              child: IntrinsicHeight(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 2,),
                    Container(
                      width: Get.width * .11,
                      height: Get.width * .11,
                      decoration: BoxDecoration(
                        image: DecorationImage(image: NetworkImage(box.read('foto')), fit: BoxFit.cover),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2)
                      ),
                    ),
                    SizedBox(height: 2,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(EvaIcons.starOutline, color:Color(0xffDA4720),size: 24,),
                        Icon(EvaIcons.starOutline, color:Color(0xffDA4720),size: 24,),
                        Icon(EvaIcons.starOutline, color:Color(0xffDA4720),size: 24,),
                        Icon(EvaIcons.starOutline, color:Color(0xffDA4720),size: 24,),
                        Icon(EvaIcons.starOutline, color:Color(0xffDA4720),size: 24,),
                      ],
                    ),
                    SizedBox(height: 2,), 
                    Text('Danos tu opinión', style: GoogleFonts.roboto(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold))
                  ],
                ),
              ),
            ),
            Divider(color: Colors.black, height: 30, indent: 5,thickness: 1.2,),
           (comentarios.length == 0) 
          ? Center(
            child: Text('No hay comentarios todavía', style: TextStyle(color: Colors.white),),
          ) :
        
        Container(
          width: Get.width,
          height: Get.height,
          child: ListView.builder(
              physics: ScrollPhysics(),
              shrinkWrap: true,
              itemCount: comentarios.length,
            itemBuilder: (BuildContext context, int index) {
              if (comentarios.length == 0) {
                Center(
                  child: Text('No hay comentarios todavía'),
                );
              }
              return Container(
               width: Get.width * .11,
                child: ListTile(
                  leading:  Container(
                        width: Get.width * .11,
                        height: Get.width * .11,
                        decoration: BoxDecoration(
                          image: DecorationImage(image: NetworkImage(comentarios[index].usuario.foto), fit: BoxFit.cover),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2)
                        ),
                      ),
                  title: Text(comentarios[index].usuario.nombre ,style: GoogleFonts.roboto(color: Theme.of(context).accentColor, fontWeight: FontWeight.bold, fontSize: 22)),    
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[ 
                      Text(comentarios[index].comentario ,style: GoogleFonts.roboto(color: Colors.white, fontWeight: FontWeight.normal, fontSize: 20)),
                      SizedBox(height: 2,),
                      _estrellasComent(comentarios[index].calificacion)
                    ],
                  ),    
                ),
              );
            },
          ),
        ),

        SizedBox(height: 80,)
      ],
    );
              
  
}

  Widget _menu(List menu) {
    if (menu.length == 0) {
          return Center(
            child: Text('No hay menú todavía', style: TextStyle(color: Colors.white),),
          );
        }
     return ListView.builder(
       itemCount: menu.length,
      itemBuilder: (BuildContext context, int index) {
        
        return Container(
          margin: EdgeInsets.only(bottom: 10, left: 20, right: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20)
          ),
          child: ListTile(
            leading: (menu[index].categoria.nombre == 'Bebidas') ? Icon(FontAwesomeIcons.beer, color: Colors.black,) :  Icon(FontAwesomeIcons.utensils, color: Colors.black,),
            title: Text(menu[index].nombre, style: GoogleFonts.roboto(color: Theme.of(context).accentColor, fontWeight: FontWeight.bold, fontSize: 20)),
            subtitle: Text(menu[index].informacion, style: GoogleFonts.roboto(color: Colors.black)),     
          ),
        );
      },
    );
   
  }

  Widget _estrellasComent(calificacion) {
    List<Widget> list = new List<Widget>();
    for(var i = 0; i < calificacion; i++){
        list.add(Icon(EvaIcons.star, color: Color(0xffff5722), size: 17,));
    }
    return new Row(children: list);
  
  }

}

class BotonReservacion extends StatelessWidget {
   final background = Color(0xFF191719);
    final primary = Color(0xffDA4720);
    final secundary = Color(0xff219762);
    
  @override
  Widget build(BuildContext context) {
    final NegocioModel negocio = ModalRoute.of(context).settings.arguments;

    final size = MediaQuery.of(context).size;
    return ButtonTheme(
      minWidth: size.width * .7,
      height: 50,
      child: RaisedButton(
        onPressed: (){
          Get.toNamed('crear_reservacion',arguments: negocio);
        },
        color: Colors.white,
        textColor: Theme.of(context).accentColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          side: BorderSide(color: Colors.white)
        ),
        child: Text('Hacer una reservación', style: TextStyle(
          color: Color(0xffDA4720),
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: .5
        ),),
        ),
    );
  }
}



class InfoWidget extends StatefulWidget {
  const InfoWidget({
    Key key,
  }) : super(key: key);

  @override
  _InfoWidgetState createState() => _InfoWidgetState();
}
  
class _InfoWidgetState extends State<InfoWidget> {
 bool fav = false;
  GetStorage box;
  List<dynamic> favoritos = [];
 @override
 void initState() { 
   super.initState();
    box = GetStorage();
    favoritos = box.read('favoritos');
    print(favoritos.toString());
 }
  
  @override
  Widget build(BuildContext context) {

    final NegocioModel negocio = ModalRoute.of(context).settings.arguments;
   
    return SliverToBoxAdapter(
      child: Container(
        color: Color(0xff000000),
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left:15.0, right: 15.0, top: 15),
                child: Row(
                  children: [
                    Flexible(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                            Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  negocio.nombre,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 38,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                                 Row(
                                  children: <Widget>[
                                    _estrellas(negocio.popularidad)
                                  ],
                                ),
                                
                              ],
                            ),
                          ),
                          Column(
                            children: <Widget>[
                               ClipOval(
                                  child: (favoritos != [] && !favoritos.contains(negocio.id)) ? Material(
                                      color: Colors.white10,
                                       child: InkWell(
                                        splashColor: Colors.white10, // inkwell color
                                        child: SizedBox(width: 40, height: 40, child: Icon(EvaIcons.heartOutline)),
                                        onTap: () {
                                          _favorito(negocio);
                                          setState(() {
                                            fav = false;
                                          });
                                          print("agregado" + fav.toString());
                                        },
                                      ),
                                  )
                                  
                                  : Material(
                                    color: Color(0xffDA4720), // button color
                                    child: InkWell(
                                      splashColor: Colors.red, // inkwell color
                                      child: SizedBox(width: 40, height: 40, child: Icon(EvaIcons.heart)),
                                      onTap: () {
                                        _eliminarFav( negocio);
                                        setState(() {
                                            fav = true;
                                          });
                                          print(fav);
                                          

                                      },
                                    ),
                                  ),
                                )
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15,),
              Padding(
                padding: const EdgeInsets.only(left:15.0, right: 15.0),
                child: Row(
                    children: <Widget>[
                      Icon(FontAwesomeIcons.glassCheers, size: 12,color: Theme.of(context).accentColor),
                      SizedBox(width: 10,),

                        Text(
                          negocio.categoriaNegocio.categoria,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),     
                    ],
                ),
              ),
              SizedBox(height: 5,),
              Padding(
                padding: const EdgeInsets.only(left:15.0, right: 15.0),
                child: Row(
                    children: <Widget>[
                      Icon(FontAwesomeIcons.mapMarkerAlt, size: 12, color: Theme.of(context).accentColor,),
                      SizedBox(width: 10,),

                      Text(
                        negocio.ubicacion.toString(),
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
              ),
              SizedBox(height: 5,),

                Padding(
                padding: const EdgeInsets.only(left:15.0, right: 15.0),
                  child: Row(
                    children: <Widget>[
                      Icon(FontAwesomeIcons.info, size: 12,color: Theme.of(context).accentColor),
                      SizedBox(width: 10,),
                      Flexible(
                         child: Text(
                          negocio.informacion,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),    
              SizedBox(height: 10,),
                ExpansionTile(
                  leading: Icon(EvaIcons.clockOutline, color: Color(0xffDA4720), size: 20 ),
                  title: Text('Horarios'),
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          child: Text("Lunes: "+ negocio.horarios[0].lunes),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          child:  Text("Martes: "+ negocio.horarios[0].martes),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          child: Text("Miercoles: "+ negocio.horarios[0].miercoles),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          child:  Text("Jueves: "+ negocio.horarios[0].jueves),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          child:Text("Viernes: "+ negocio.horarios[0].viernes),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          child: Text("Sábado: "+ negocio.horarios[0].sabado),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          child: Text("Domingo: "+ negocio.horarios[0].domingo),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        ),
                      ],
                    )
                  ],
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  RaisedButton(
                    onPressed: (){
                      Get.toNamed('mapa_negocio', arguments: negocio);
                    },
                    textColor: Colors.white, 
                    color: Color(0xffDA4720),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    child: Row(
                      children: <Widget>[
                        Text('Ver en mapa '),
                        Icon(EvaIcons.mapOutline, size: 18,),
                      ],
                    ),
                  ),
                  RaisedButton(
                    onPressed: (){
                      Get.toNamed('chat_page', arguments: negocio);
                    },
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    textColor: Colors.white,
                    color: Color(0xffDA4720),
                    child: Row(
                      children: <Widget>[
                        Text('Enviar mensaje '),
                        Icon(EvaIcons.messageCircle, size: 18,),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 10,),
            
             Container(
                  width: Get.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                  padding: EdgeInsets.only( left: 15, bottom: 10),
                        child: Text('Historias', style: GoogleFonts.roboto(fontSize: 20,color: Colors.white, fontWeight: FontWeight.bold))
                      ),
                     (negocio.historias.length == 0) ? Center(
                            child: Text('No hay historias todavía', style: TextStyle(color: Colors.white),),
                          )  : Container(
                        width: Get.width * 6,
                        height: Get.height *.25,
                        child: HistoriasHorizontal(historias: negocio.historias),
                      )  
                    ],
                  ),
                ),       
            ],
          ),
        ),
      ),
    );
  }

   Widget _estrellas(int rank) {
    List<Widget> list = new List<Widget>();
    for(var i = 0; i < rank; i++){
        list.add(Icon(EvaIcons.star, color: Color(0xffff5722), size: 17,));
    }
    return new Row(children: list);
  }

    _favorito(NegocioModel negocio) async {
      final negocioProvider = Provider.of<NegocioProvider>(context, listen: false);
      
      if (!favoritos.contains(negocio.id)) { 
          favoritos.add(negocio.id);
          box.write('favoritos', favoritos); 
          negocioProvider.getFavoritos(favoritos);
          print(box.read('favoritos').toString()); 
        }
        setState(() {
          
        });
    }

     _eliminarFav(NegocioModel negocio) async {
      final negocioProvider = Provider.of<NegocioProvider>(context, listen: false);

      favoritos = box.read('favoritos');
      favoritos.removeWhere((item) => item == negocio.id);
      negocioProvider.getFavoritos(favoritos);
      box.write('favoritos', favoritos); 
      print(box.read('favoritos').toString()); 
      setState(() {
        
      });
  }
  
}


 

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final NegocioModel negocio = ModalRoute.of(context).settings.arguments;

    return SliverAppBar(
      elevation: 0,
      pinned: true,
      expandedHeight: 250,
      stretch: true,
      leading: IconButton(icon: Icon(FontAwesomeIcons.arrowLeft, color: Colors.white,), onPressed: (){Navigator.of(context).pop();}),
      backgroundColor: Color(0xFF000000),
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: [
          StretchMode.zoomBackground,
        ],
        background: Stack(
          fit: StackFit.expand,
          children: [
            Positioned.fill(
              child: Carousel(
                  autoplay: true,
                  dotSize: 6,
                  dotIncreasedColor: Color(0xffDA4720),
                  dotBgColor: Colors.transparent,
                    images: (negocio.fotos.length > 0 ) ? negocio.fotos.map((map) => Image.network(map.foto)
                            ).toList() : [Image.network(negocio.foto, fit: BoxFit.cover,)],
                  ),
              ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                   
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      
    );
  }

}



