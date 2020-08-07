import 'dart:async';



class Validators {


  final validarEmail = StreamTransformer<String, String>.fromHandlers( 
    handleData: ( email, sink ) {


      Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regExp   = new RegExp(pattern);

      if ( regExp.hasMatch( email ) ) {
        sink.add( email );
      } else {
        sink.addError('Email no es correcto');
      }

    }
  );


  final validarPassword = StreamTransformer<String, String>.fromHandlers(
    handleData: ( password, sink ) {

      if ( password.length >= 6 ) {
        sink.add( password );
      } else {
        sink.addError('Más de 6 caracteres por favor');
      }

    }
  );

  final validarEdad = StreamTransformer<int, int>.fromHandlers(
    handleData: ( edad, sink ) {

      if ( edad is int ) {
        if (edad >= 18 && edad < 99) {
          sink.add( edad );
        } else if (edad > 99) {
          sink.addError('¿Realmente estás tan viejo?');
        } else {
          sink.addError('Debes ser mayor de edad para ingresar');
        }
      } 
    }
  );

  final validarNombre = StreamTransformer<String, String>.fromHandlers(
    handleData: ( nombre, sink ) {
      if ( nombre.length > 5 ) {
        sink.add( nombre );
      } else {
        sink.addError('Minimo 6 caracteres');
      }

    }
  );


}