
import 'dart:convert';

import 'package:IParty/src/models/conversacion_model.dart';
import 'package:IParty/src/models/mesagge_model.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class ChatProvider extends ChangeNotifier {
  int _counter = 0; 
  List<Message> _messages = List();
  List<Last> conversaciones = List();
  List<Message> mensajes = List();
  GetStorage box = GetStorage();

  ChatProvider() {
    this.getMessagesUser(box.read('id'));
  }

  int get counter => _counter;

  set counter(int value) {
    _counter = value;
    notifyListeners();
  }

  List<Message> get messages => _messages;

  set messages(List<Message> value) {
    _messages = value;
    notifyListeners();
  }

  void addMessage(Message message) {
    _messages.add(message);
    notifyListeners();
  }

  getMessages() async {
    
  }
  
  void removeMessage(int index) {
    _messages.removeAt(index);
    notifyListeners();
  }

  void clearMessages() {
    _messages.clear();
    notifyListeners();
  }

  getMessagesUser(int id) async {
    final url = Uri.http('ec2-54-84-72-80.compute-1.amazonaws.com', "/socket/api/getConversationCliente");
  
      print(id);
      final authData = {
        "user": id
      };


      var body = json.encode(authData);
      final resp = await http.post(
        url,
        headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      }, 
        body: body
      );
      final decodedData =  json.decode(resp.body);

      final reser = Conversaciones.fromJsonList(decodedData['data']);
      print(decodedData);
      this.conversaciones = reser.items;

      print(this.conversaciones);
      notifyListeners();
  }

  getConversaciones(int id, int negocio) async {
    final url = Uri.http('ec2-54-84-72-80.compute-1.amazonaws.com', "/socket/api/getchat");
      
      print('entro');
      final authData = {
        "conversacion":id,
        "idnegocio": negocio
      };


      var body = json.encode(authData);
      final resp = await http.post(
        url,
        headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      }, 
        body: body
      );
      final decodedData =  json.decode(resp.body);

      final msjs =  Mensajes.fromJsonList(decodedData['data']);
      
      this._messages = msjs.items;

      print(this._messages);
      notifyListeners();
  }

  static ChatProvider of(BuildContext context) =>
      Provider.of<ChatProvider>(context);
}