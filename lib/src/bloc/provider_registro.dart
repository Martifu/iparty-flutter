import 'package:flutter/material.dart';
import 'package:IParty/src/bloc/registro_bloc.dart';


class ProviderRegistro extends InheritedWidget {

  final registroBloc = new RegistroBloc();


  static ProviderRegistro _instancia;

  factory ProviderRegistro({ Key key, Widget child }) {

    if ( _instancia == null ) {
      _instancia = new ProviderRegistro._internal(key: key, child: child );
    }

    return _instancia;

  }

  ProviderRegistro._internal({ Key key, Widget child })
    : super(key: key, child: child );


  

  // Provider({ Key key, Widget child })
  //   : super(key: key, child: child );

 
  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  

   static RegistroBloc of ( BuildContext context ){
   return context.dependOnInheritedWidgetOfExactType<ProviderRegistro>().registroBloc;
  }



}