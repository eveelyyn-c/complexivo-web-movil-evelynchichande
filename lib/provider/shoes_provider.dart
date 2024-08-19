import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/zapato.dart';

class ShoesProvider extends ChangeNotifier {
  /*CHANGENOTIFIER va a notificar todos los cambios que hayan dentro de esta clase*/
  bool isLoading = false;
  String? valueError;

  /*Creamos una lista de zapatos y la inicializamos en vacio, y le agregamos la propiedad
  * de GROWABLE que porque defecto viene  false para que la lista no se pueda modificar
  * pero como si queremos modificar vamos a cambiar su estado a TRUE :)*/
  List<Zapato> listaZapato = List.empty(growable: true);

  Future<void> getAllShoes() async {
    isLoading = true;
    listaZapato.clear();
    notifyListeners();
    try {
      final SharedPreferences preferences =
          await SharedPreferences.getInstance();
      final response =
          await http.get(Uri.parse('http://192.168.18.5:8080/zapatos-public'));
      /*'http://192.168.18.5:8080/zapatos-public
      * QUiero recordar que esto puede cambiar, si estoy con un emulador será localhost y si es con un dispositivo
      * fisico tendrá que ser la ip de mi compu :D que por si no te acuerdas CAMBIA SEGUN LA REEED!!! -.- */

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body) as List<dynamic>;
        listaZapato = responseData
            .map((element) => Zapato.fromJson(element as Map<String, dynamic>))
            .toList();

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

  Future<void> searchShoes(String nombre) async {
    isLoading = true;
    listaZapato.clear();
    notifyListeners();
    try {
      final response = await http
          .get(Uri.parse(
              'https://complexback.uc.r.appspot.com/zapatos-public/search/$nombre'))
          .timeout(Duration(seconds: 5));
      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body) as List<dynamic>;
        listaZapato = responseData
            .map((element) => Zapato.fromJson(element as Map<String, dynamic>))
            .toList();

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

  Future<bool> createShoes(Zapato zapato) async {
    isLoading = true;
    notifyListeners();
    try {
      final SharedPreferences preferences =
          await SharedPreferences.getInstance();
      final token = preferences.getString('token');
      final response = await http.post(
        Uri.parse('https://complexback.uc.r.appspot.com/zapatos'),
        body: jsonEncode(zapato.toJson()),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token!'
        },
      );
      /*'http://192.168.18.5:8080/zapatos-public
      * QUiero recordar que esto puede cambiar, si estoy con un emulador será localhost y si es con un dispositivo
      * fisico tendrá que ser la ip de mi compu :D que por si no te acuerdas CAMBIA SEGUN LA REEED!!! -.- */

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body) as Map<String, dynamic>;
        listaZapato.add(Zapato.fromJsonSave(responseData));
        isLoading = false;
        valueError = null;
        notifyListeners();
        /*Esto va a notificar a todos los que esten ESCUCHANDO a ShoesBloc*/
        return true;
      } else {
        return false;
      }
    } catch (e) {
      isLoading = false;
      valueError = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateShoes(Zapato zapato) async {
    isLoading = true;
    notifyListeners();
    try {
      final SharedPreferences preferences =
          await SharedPreferences.getInstance();
      final token = preferences.getString('token');
      final response = await http.put(
        Uri.parse('https://complexback.uc.r.appspot.com/zapatos/${zapato.id}'),
        body: jsonEncode(zapato.toJson()),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token!'
        },
      );
      /*'http://192.168.18.5:8080/zapatos-public
      * QUiero recordar que esto puede cambiar, si estoy con un emulador será localhost y si es con un dispositivo
      * fisico tendrá que ser la ip de mi compu :D que por si no te acuerdas CAMBIA SEGUN LA REEED!!! -.- */

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body) as Map<String, dynamic>;
        listaZapato.add(Zapato.fromJsonSave(responseData));
        isLoading = false;
        valueError = null;
        notifyListeners();
        /*Esto va a notificar a todos los que esten ESCUCHANDO a ShoesBloc*/
        return true;
      } else {
        return false;
      }
    } catch (e) {
      isLoading = false;
      valueError = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteShoes(Zapato zapato) async {
    isLoading = true;
    notifyListeners();
    try {
      final SharedPreferences preferences =
          await SharedPreferences.getInstance();
      final token = preferences.getString('token');
      final response = await http.delete(
          Uri.parse(
              'https://complexback.uc.r.appspot.com/zapatos/${zapato.id}'),
          body: jsonEncode(zapato.toJson()),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token!'
          });
      /*'http://192.168.18.5:8080/zapatos-public
      * QUiero recordar que esto puede cambiar, si estoy con un emulador será localhost y si es con un dispositivo
      * fisico tendrá que ser la ip de mi compu :D que por si no te acuerdas CAMBIA SEGUN LA REEED!!! -.- */

      if (response.statusCode == 200) {
        listaZapato.removeWhere((element) => element.id == zapato.id);
        isLoading = false;
        valueError = null;
        notifyListeners();
        /*Esto va a notificar a todos los que esten ESCUCHANDO a ShoesBloc*/
        return true;
      } else {
        return false;
      }
    } catch (e) {
      isLoading = false;
      valueError = e.toString();
      notifyListeners();
      return false;
    }
  }
}
