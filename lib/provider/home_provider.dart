import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeProvider extends ChangeNotifier{
  String? rol;
  Future<void> getUserRol() async {
    final SharedPreferences preferences =
        await SharedPreferences.getInstance();
    rol=preferences.getString('role');
    notifyListeners();
  }
  Future<void> logout() async {
    final SharedPreferences preferences =
        await SharedPreferences.getInstance();
    await preferences.remove('role');
    rol=null;
    notifyListeners();
  }


}