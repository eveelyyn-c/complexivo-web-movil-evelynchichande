import 'package:complexivo/details/detail_page.dart';
import 'package:complexivo/login/login_page.dart';
import 'package:complexivo/models/zapato.dart';
import 'package:complexivo/provider/home_provider.dart';
import 'package:complexivo/provider/login_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../home/home_page.dart';
import '../provider/shoes_provider.dart';
import '../shoes/add_shoes_page.dart';

final GoRouter routesConfig = GoRouter(
  initialLocation: '/',
  /*ruta inicial*/
  routes: [
    /*routes es una lista de rutas :D*/
    GoRoute(
      path: '/',
      routes: [
        /*Creamos una lista [] de rutas y aquí definimos a los hijos de la ruta inicial, como el login*/
        GoRoute(
          path: 'login',
          builder: (context, state) {
            return ChangeNotifierProvider(
                create: (context) {
                  return LoginProvider();
                },
                child:
                    LoginPage()); /*agreamos el path sin el /, le decimos que va a construir y retornmaos la página que construye*/
          },
        ),
        GoRoute(
          path: 'detail',
          builder: (context, state) {
            return DetailPage(state.extra! as Zapato /* STATE.EXTRA */
                ); /*agreamos el path sin el /, le decimos que va a construir y retornmaos la página que construye*/
          },
        ),
        GoRoute(path: 'add_shoes',
          builder: (context, state) {
            return  AddShoesPage();
          },
        ),
      ],
      builder: (context, state) {
        return  HomePage();
      },
    ),
  ],
);
