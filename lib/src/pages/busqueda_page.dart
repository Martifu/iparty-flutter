import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iparty/src/models/negocio_model.dart';
import 'package:iparty/src/providers/negocio_provider.dart';
import 'package:provider/provider.dart';
 
 
class BusquedaPage extends StatefulWidget {

  @override
  _BusquedaPageState createState() => _BusquedaPageState();
}

class _BusquedaPageState extends State<BusquedaPage> {
  TextEditingController _searchQueryController = TextEditingController();

  bool _isSearching = true;

  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    final negocioProvider = Provider.of<NegocioProvider>(context);

    return  Scaffold(
      backgroundColor: Colors.black,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
          child: Hero(
            tag: 'busqueda',
           child: AppBar(
            backgroundColor: Colors.white,
                
            leading: _isSearching ?  BackButton(color: Colors.black, onPressed: () { negocioProvider.borrarBusqueda(); Get.back(); } ,) : Container(),
            title: _isSearching ? _buildSearchField() : Container(),
            actions: _buildActions(),
        ),
          ),
      ),

      body: Container(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: <Widget>[ 
              (negocioProvider.busquedas.length > 0) ?  _crearBusqueda(negocioProvider.busquedas) : Center(child: Text('No hay coincidencias', style: TextStyle(color: Colors.white),)),
            ],
          ),
        ),
      ), 
    );
  }

   Widget _crearBusqueda(List<NegocioModel> buscados) {

          if (buscados.length == 0) {
           return Container( padding: EdgeInsets.symmetric(vertical: 80),child:  Center( child: Text('No hay coincidencias', style: TextStyle(color: Colors.white),)));
          } else {
           return Column(
             children: _listaResultados(buscados),
           ) ;
          }
        
  }

  List<Widget> _listaResultados(List<NegocioModel> negocios) {
      return negocios.map((negocio){
        return Material(
          borderRadius: BorderRadius.circular(25),
          color: Colors.black,
          child: GestureDetector(
            onTap: () {
              Get.toNamed('detalles', arguments: negocio);
            },
              child: Container( 
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              width: Get.width * 2,
              height: Get.height * 0.15,
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(25)
              ),
              child: Row(
                children: <Widget>[
                  (negocio.fotos.length > 0) ? Container(
                  width: 140,
                  decoration: BoxDecoration(
                    image: DecorationImage(image: NetworkImage(negocio.foto), fit: BoxFit.cover),
                    borderRadius: BorderRadius.circular(25), 
                  ),
                ) : Container(
                  width: 140,
                  decoration: BoxDecoration(
                    image: DecorationImage(image: NetworkImage(negocio.foto), fit: BoxFit.cover),
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left:15.0, top: 8.0),
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(negocio.nombre, style: GoogleFonts.roboto(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                        Text(negocio.ubicacion, style: GoogleFonts.roboto(color: Colors.white, fontSize: 14)),
                        _estrellas(5),
                      ],
                    ),
                  ),
                )
                ],
              )
            ),
          ),
        );
      }).toList();
  }

  Widget _estrellas(int rank) {
    List<Widget> list = new List<Widget>();
    for(var i = 0; i < rank; i++){
        list.add(Icon(EvaIcons.star, color: Color(0xffff5722), size: 17,));
    }
    return new Row(children: list);
  }

  Widget _buildSearchField() {
    return Container(
      height: 50,
      child: TextField(
        controller: _searchQueryController,
        autofocus: true,
        decoration: InputDecoration(
          hintText: "Encuentra algún lugar...",
          border: InputBorder.none,
          hintStyle: TextStyle(color: Colors.black26),
        ),
        style: GoogleFonts.roboto(textStyle: TextStyle(color: Colors.black, fontSize: 28, fontWeight: FontWeight.bold)),
        onChanged: (query) => updateSearchQuery(query),
      ),
    );
  }

  List<Widget> _buildActions() {
    final negocioProvider = Provider.of<NegocioProvider>(context, listen: false);

    if (_isSearching) {
      return <Widget>[
        IconButton(
          icon: const Icon(Icons.clear, color: Colors.black,),
          onPressed: () {
               negocioProvider.borrarBusqueda();
            
            if (_searchQueryController == null ||
                _searchQueryController.text.isEmpty) {

              Navigator.pop(context);
              return;
            }
            _clearSearchQuery();
          },
        ),
      ];
    }

    return <Widget>[
      IconButton(
        icon: const Icon(Icons.search),
        onPressed: _startSearch,
      ),
    ];
  }

  void _startSearch() {
    ModalRoute.of(context)
        .addLocalHistoryEntry(LocalHistoryEntry(onRemove: _stopSearching));

    setState(() {
      _isSearching = true;
    });
  }

   updateSearchQuery(String newQuery) {
    final negocioProvider = Provider.of<NegocioProvider>(context, listen: false);
    negocioProvider.busqueda(newQuery);
    print('buscando');
    setState(() {
      searchQuery = newQuery;
    });
    print(negocioProvider.busquedas);
  }

  void _stopSearching() {
    _clearSearchQuery();

    setState(() {
      _isSearching = false;
    });
  }

  void _clearSearchQuery() {
    setState(() {
      _searchQueryController.clear();
      updateSearchQuery("");
    });
  }
}