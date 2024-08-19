import 'package:complexivo/home/home_page.dart';
import 'package:complexivo/provider/login_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final TextEditingController textUser = TextEditingController();
  final TextEditingController textPass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final loginProvider = context.watch<
        LoginProvider>(); /*REFERENCIA A LOGIN PROVIDER PARA ACCEDER A LAS
    FUNCIONES Y A LAS VARIABLES*/
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'BOUTIQUE OSONO S.A',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: textUser,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black12,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(30),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black12,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(30),
                      ),
                    ),
                    hintText: 'Username',
                    hintStyle: TextStyle(
                      color: Colors.grey, // Cambia el color del hintText
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: textPass,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black12,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(30),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black12,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(30),
                      ),
                    ),
                    hintText: 'Password',
                    hintStyle: TextStyle(
                      color: Colors.grey, // Cambia el color del hintText
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: TextButton(
                        style: const ButtonStyle(
                          backgroundColor:
                              WidgetStatePropertyAll<Color>(Colors.blue),
                        ),
                        onPressed: () async {
                          /*Agregamos un AWAIT porque necesitamos que espere que haga el login*/
                          await loginProvider.signIn(
                              textUser.text, textPass.text);
                          final SharedPreferences preferences =
                              await SharedPreferences.getInstance();
                          /*Nuevamente obtengo la instancia de la bd*/
                          if (preferences.getString('token') != null) {
                            context.go('/');
                            /*obtengo el token que estaba grabado en la base y y comparo si es nulo o no
                            * En este casi redirijo a la raíz de la app. con el context.go :D
                            * Sin, mensajito de toast*/
                          } else {
                            showToast(
                              "Usuario o contraseña no encontrada :(",
                              context: context,
                            );
                          }
                        },
                        child: const Text(
                          'Ingresar',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
