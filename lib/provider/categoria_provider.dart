import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/categoria.dart';

class CategoriaProvider extends ChangeNotifier{
  bool isLoading= false;
  String? valueError;
  List<Categoria> listaCategoria = List.empty(growable: true);

  Future<void> getAllCategories() async {
    isLoading = true;
    notifyListeners();
    try {
      final SharedPreferences preferences = await SharedPreferences.getInstance();
      final token= preferences.getString('token');
      final response =
      await http.get(Uri.parse('https://complexback.uc.r.appspot.com/categorias'),
          headers: {'Authorization': 'Bearer $token!'}
      );
      /*'http://192.168.18.5:8080/zapatos-public
      * QUiero recordar que esto puede cambiar, si estoy con un emulador será localhost y si es con un dispositivo
      * fisico tendrá que ser la ip de mi compu :D que por si no te acuerdas CAMBIA SEGUN LA REEED!!! -.- */

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body) as List<dynamic>;
        listaCategoria = responseData
            .map((element) => Categoria.fromJson(element as Map<String, dynamic>))
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
    }
  }
}