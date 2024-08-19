import 'package:complexivo/provider/home_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../provider/categoria_provider.dart';
import '../provider/shoes_provider.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final TextEditingController textNombre = TextEditingController();

  //1. Una aplicacion se inicia con un Scaffold (es lo estandar). StatelessWidget siempre construyte por defect el placeholder
  /*Cupertino es la libreria de iOS y tiene las herramientas visuales para ese SO. Material utilizamos para Android*/
  @override
  Widget build(BuildContext context) {
    /*Si pongo en mouse sobre el widget de scaffold este me va a dar encerrar el widget COMPLETO. En este caso lo usamo para encerrar scaffold en un SAFEAREA para respetar los límetes del diispositivo*/
    final shoesProvider = context.watch<
        ShoesProvider>(); //shoesProvider va a estar mirando los cambios en ShoesProvider
    /*Creamos el watch que escuche a home provider*/
    final homeProvider = context.watch<HomeProvider>();

    final categoriesProvider = context.watch<CategoriaProvider>();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Boutique OZONO S.A.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.blue,
          actions: [
            IconButton(
              onPressed: () async {
                if (homeProvider.rol == null) {
                  context.go(
                      '/login'); /*Aqui manejamos ruts y
                        ponemos /login para que sepa que si está en login puede regresar a la ruta inicial '/' */
                } else {
                  await homeProvider.logout();
                }
              },
              icon: Icon(
                homeProvider.rol == null ? Icons.person : Icons.logout,
                color: Colors.white,
              ),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await categoriesProvider.getAllCategories();
            context.go('/add_shoes');
          },
          backgroundColor: Colors.blue,
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        /*Encerramos a GridView en un column porque el column tiene la propiedad de recibir a muchos hijos 'CHILDren'
        * SIEMPRE SEPARAMOS A LOS WIDGET CON COMA*/
        body: shoesProvider
                .isLoading /*Comparacion con operador ternario si isLoading es true quiere decir que estamos esperando que la API NOS RESPONDA :D
        Si ya obtenemos respuesta, is Loading en ShoesProvider va a cambiar a FALSE y por ende lo va a notificar y lo vamos a ESCUCHAR para cambiar la vista con los DOS PUNTOS :
        Quiero recordar los operadores ternarios para manejar estas comparaciones :DD*/
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: () => shoesProvider.getAllShoes(),
                child: Padding(
                  /*Envolviendo el COLUMN en PADDING damos espacio entre el widget y su contorno .all dando espacio en los 4 lados (arriba, abajo, izquierda y derecha)*/
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          /*Row es padre de TextField e IconButton, (La Lupa de search) al ROW le damos la propiedad de mainAxisSize
                    * para que ocupe el minimo espacio que pueda dentro de lo que le permita su abuelo COLUMN, porque su padre es Padding (que solo
                    * está determinando su espacio entre el otro widget xd )  */
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded(
                                child: TextField(
                              controller: textNombre,
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
                                hintText: 'Escribe aquí',
                                hintStyle: TextStyle(
                                  color: Colors
                                      .grey, // Cambia el color del hintText
                                ),
                              ),
                            )),
                            IconButton(
                                onPressed: () {
                                  shoesProvider.searchShoes(textNombre.text);
                                },
                                icon: const Icon(
                                  Icons.search,
                                  color: Colors.blue,
                                ))
                          ],
                        ),
                      ),
                      Expanded(
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, // Número de columnas
                            crossAxisSpacing:
                                10.0, // Espacio horizontal entre columnas
                            mainAxisSpacing:
                                10.0, // Espacio vertical entre filas
                          ),
                          itemCount: shoesProvider.listaZapato.length,
                          // Número de elementos
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                              onTap: () {
                                if (homeProvider.rol != null) {
                                  context.go('/detail',
                                      extra: shoesProvider.listaZapato[index]);
                                }
                              },
                              child: Card(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image.asset(
                                        'assets/zapato.jpg',
                                        height: 90,
                                      ),
                                    ),
                                    Text(shoesProvider
                                        .listaZapato[index].nombre),
                                    Text(shoesProvider.listaZapato[index].estado
                                        ? 'Disponible'
                                        : 'En reposicion')
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
