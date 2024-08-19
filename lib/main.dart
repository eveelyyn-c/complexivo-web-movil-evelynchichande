import 'dart:io';

import 'package:complexivo/provider/categoria_provider.dart';
import 'package:complexivo/provider/home_provider.dart';
import 'package:complexivo/provider/shoes_provider.dart';
import 'package:complexivo/routes/router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  runApp(MultiProvider(
      /*Multiprovider tiene esta propiedad providers que recibe una lista de providers :D*/
      providers: [
        ChangeNotifierProvider(
          create: (_) {
            return HomeProvider()..getUserRol();
          },
        ),
        ChangeNotifierProvider(
          /*Creo el changeNotifierProvider para decir que me cargue toda la lista de zapatos (CON SHOESBLOC PARA LLAMAR AL API) al inicio de la app
                y defino cual es la clase (HIJO) que va a escuchar los cambios (HOMEPAGE)*/
          create: (_) {
            return ShoesProvider()..getAllShoes();
          },
        ),
        ChangeNotifierProvider(
          /*Creo el changeNotifierProvider para decir que me cargue toda la lista de categorias (CON SHOESBLOC PARA LLAMAR AL API) al inicio de la app
                y defino cual es la clase (HIJO) que va a escuchar los cambios (HOMEPAGE)*/
          create: (_) => CategoriaProvider(),
        ),
      ],
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: routesConfig,
      title: 'Flutter Demo',
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
