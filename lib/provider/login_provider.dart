import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginProvider extends ChangeNotifier{
  /*CHANGENOTIFIER va a notificar todos los cambios que hayan dentro de esta clase*/
  bool isLoading = false;
  String? valueError;
  Future<void> signIn(String username, String password) async {
    isLoading = true;
    notifyListeners();

    final SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
    try {
      final response =
          await http.post(Uri.parse('http://192.168.18.5:8080/auth/signin'), body: jsonEncode({
              "username":username,
              "password":password
          }),headers:  {
            'Content-Type': 'application/json',
          });
      /*Con jsonEncode le decimos que transforme en json el objeto que estamos mandando.
      * Y tambine agregamos los encabezados y de tipo son. */
      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        /*Map porque eso me devuelve el API*/
        /*1. Obtiene una instancia a una bd de datos interna*/
        preferences.setString("token", responseData['token']);
        /*Aquí grabo el objeto el objeto de mi responseData dentro de mi instancia*/
        preferences.setString("role", responseData['empleado']['role']);
        preferences.setInt("idempleado", responseData['empleado']['idempleado']);
        /*Aqui estoy accedienod al atributo de rol de mi empleado sin crear un modelo*/
        isLoading = false;
        valueError = null;
        notifyListeners();
        /*Esto va a notificar a todos los que esten ESCUCHANDO a ShoesBloc*/
      }
    } catch (e) {
      isLoading = false;
      valueError = e.toString();
      notifyListeners();
      print(e.toString());
    }
  }
}