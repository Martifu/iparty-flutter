import 'package:flutter/material.dart';
import 'package:IParty/src/bloc/login_bloc.dart';


class ProviderLogin extends InheritedWidget {

  final loginBloc      = new LoginBloc();


  static ProviderLogin _instancia;

  factory ProviderLogin({ Key key, Widget child }) {

    if ( _instancia == null ) {
      _instancia = new ProviderLogin._internal(key: key, child: child );
    }

    return _instancia;

  }

  ProviderLogin._internal({ Key key, Widget child })
    : super(key: key, child: child );


  

  // ProviderLogin({ Key key, Widget child })
  //   : super(key: key, child: child );

 
  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static LoginBloc of ( BuildContext context ){
   return context.dependOnInheritedWidgetOfExactType<ProviderLogin>().loginBloc;
  }

}