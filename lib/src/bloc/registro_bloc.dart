import 'dart:async';
import 'package:IParty/src/bloc/validators.dart';
import 'package:rxdart/rxdart.dart';

class RegistroBloc with Validators {
 

  final _emailController    = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();
  final _nombreController = BehaviorSubject<String>();

  // Recuperar los datos del Stream
  Stream<String> get emailStream    => _emailController.stream.transform( validarEmail );
  Stream<String> get passwordStream => _passwordController.stream.transform( validarPassword );
  Stream<String> get nombreStream => _nombreController.stream.transform( validarNombre );

  Stream<bool> get formValidStream => 
      Rx.combineLatest3(emailStream, passwordStream, nombreStream, (e, p, s) => true );



  // Insertar valores al Stream
  Function(String) get changeEmail    => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;
  Function(String) get changeNombre => _nombreController.sink.add;


  // Obtener el último valor ingresado a los streams
  String get email    => _emailController.value;
  String get password => _passwordController.value;
  String get nombre => _nombreController.value;

  dispose() {
    _emailController?.close();
    _passwordController?.close();
    _nombreController?.close();
  }

}
