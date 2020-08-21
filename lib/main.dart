import 'package:IParty/src/pages/chat_list_page.dart';
import 'package:IParty/src/pages/editar_reservacion_page.dart';
import 'package:IParty/src/pages/info_reservacion_page.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:ff_navigation_bar/ff_navigation_bar.dart';
import 'package:ff_navigation_bar/ff_navigation_bar_item.dart';
import 'package:ff_navigation_bar/ff_navigation_bar_theme.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:IParty/src/bloc/provider.dart';
import 'package:IParty/src/bloc/provider_registro.dart';
import 'package:IParty/src/components/evento_viewer.dart';
import 'package:IParty/src/components/historias_horizontal.dart';
import 'package:IParty/src/pages/busqueda_page.dart';
import 'package:IParty/src/pages/comentario_page.dart';
import 'package:IParty/src/pages/crear_reservacion_page.dart';
import 'package:IParty/src/pages/favs_page.dart';
import 'package:IParty/src/pages/chat_page.dart';
import 'package:IParty/src/pages/datalles_negocio.dart';
import 'package:IParty/src/pages/editar_perfil.dart';
import 'package:IParty/src/pages/home_page.dart';
import 'package:IParty/src/pages/landing_page.dart';
import 'package:IParty/src/pages/login_page.dart';
import 'package:IParty/src/pages/mapa_negocio.dart';
import 'package:IParty/src/pages/mapa_negocios.dart';
import 'package:IParty/src/pages/registro_page.dart';
import 'package:IParty/src/pages/reservaciones_page.dart';
import 'package:IParty/src/pages/subir_historia.dart';
import 'package:IParty/src/pages/usuario_page.dart';
import 'package:IParty/src/providers/chat_provider.dart';
import 'package:IParty/src/providers/info_user_provider.dart';
import 'package:IParty/src/providers/negocio_provider.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';

void main()  async {
  await GetStorage.init();
  await Jiffy.locale("es");
  runApp(MyApp());
} 

class MyApp extends StatelessWidget {
  final box = GetStorage();
  
  
  @override
  Widget build(BuildContext context) {
    
    
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => new NegocioProvider()),
        ChangeNotifierProvider(create: (_) => new UsuarioInfoProvider()),
        ChangeNotifierProvider(create: (_) => new ChatProvider()),
      ],
          child: GetMaterialApp(
            title: 'IParty',
          debugShowCheckedModeBanner: false,
          defaultTransition: Transition.fadeIn,
           initialRoute:'login',
           getPages: [
             GetPage(name: 'login', page: () => ProviderLogin(child: LoginPage(),)),
             GetPage(name: 'registro', page: () => ProviderRegistro(child: RegistroPage(),)),
             GetPage(name: 'perfil', page: () => UsuarioPage()),
             GetPage(name: 'editar', page: () => EditarPerfilPage()),
             GetPage(name: 'home', page: () => MyHomePage()),
             //GetPage(name: 'landing', page: () => Landing()),
             GetPage(name: 'detalles', page: () => DetallesPage()),
             GetPage(name: 'ver_historia', page: () => MoreStories()),
             GetPage(name: 'mapa_negocio', page: () => MapaNegocioPage()),
             GetPage(name: 'mapa_negocios', page: () => MapaNegociosPage()),
             GetPage(name: 'chat_page', page: () => ChatPage()),
             GetPage(name: 'evento', page: () => EventoView()),
             GetPage(name: 'busqueda', page: () => BusquedaPage()),
             GetPage(name: 'crear_reservacion', page: () => CrearReservacion()),
             GetPage(name: 'comentario', page: () => ComentarioPage()),
             GetPage(name: 'subir_historia', page: () => SubirHistoria()),
             GetPage(name: 'info_reservacion', page: () => InfoReservacionPage()),
             GetPage(name: 'editar_reservacion', page: () => EditarReservacionPage()),
             GetPage(name: 'chat_list', page: () => ChatListPage()),
          ],
      ),
    );
  }
}


class MyHomePage extends StatefulWidget {

  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selectedIndex = 1;
  
  @override
  Widget build(BuildContext context) {

    final background = Colors.black;
    final primary = Color(0xffDA4720);
    //final secundary = Color(0xff219762);
    return ChangeNotifierProvider(
      create: (_) => _NavegacionModel(),
          child: Scaffold(
        body: _Paginas(),
        bottomNavigationBar: _Navegacion(background: background, primary: primary),
      ),
    );
  }
}

class _Navegacion extends StatelessWidget {
  const _Navegacion({
    Key key,
    @required this.background,
    @required this.primary,
  }) : super(key: key);

  final Color background;
  final Color primary;

  @override
  Widget build(BuildContext context) {
   

    final navegacionModel = Provider.of<_NavegacionModel>(context);

    return FFNavigationBar(
      theme: FFNavigationBarTheme(
        barBackgroundColor: background,
        unselectedItemIconColor: Colors.white54,
        unselectedItemLabelColor:Colors.white54,
        selectedItemBorderColor: Colors.transparent,
        selectedItemBackgroundColor: primary,
        selectedItemIconColor: Colors.white,
        selectedItemLabelColor: Colors.white,
        showSelectedItemShadow: false,
        barHeight: 50,
      ),
      selectedIndex: navegacionModel.paginaActual,
      onSelectTab: (i) => navegacionModel.paginaActual = i,
      items: [
        FFNavigationBarItem(
          iconData: FontAwesomeIcons.wineGlassAlt,
          label: 'Reservaciones',
        ),
        FFNavigationBarItem(
          iconData: EvaIcons.homeOutline,
          label: 'Inicio',
        ),
        FFNavigationBarItem(
          iconData: EvaIcons.heartOutline,
          label: 'Favoritos',
        ),
      ],
    );
  }
}

class _Paginas extends StatelessWidget {
  

  @override
  Widget build(BuildContext context) {

    final navegacionModel = Provider.of<_NavegacionModel>(context);
    return PageView(
      controller: navegacionModel.pageController,
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
          ReservacionesPage(),
          HomePage(),
          FavsPage(),
      ],
    );
  }
}


class _NavegacionModel with ChangeNotifier {

  int _paginaAcual = 1;
  
  PageController _pageController = new PageController(initialPage: 1);

  int get paginaActual => this._paginaAcual;

  set paginaActual( int valor ){
    this._paginaAcual = valor;
    print(valor);
    
    _pageController.animateToPage(valor, duration: Duration(milliseconds: 600), curve: Curves.easeInOutExpo);
    notifyListeners();
  }
  
  PageController get pageController => this._pageController;
}