import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/categoria.dart';
import '../../provider/categoria_provider.dart';
import '../../provider/shoes_provider.dart';
import '../models/empleado.dart';
import '../models/zapato.dart';
import '../widgets/text_form_default.dart';

class AddShoesPage extends StatefulWidget {
  AddShoesPage({super.key});

  @override
  State<AddShoesPage> createState() => _AddShoesPageState();
}

class _AddShoesPageState extends State<AddShoesPage> {
  /*Controllers para recuperar el texto que ingresa*/
  final TextEditingController textNombreController = TextEditingController();

  final TextEditingController textPrecioController = TextEditingController();

  final TextEditingController textCantidadController = TextEditingController();

  final TextEditingController textDescripcionController =
      TextEditingController();
  String? categoriaSeleccionada;

  /*Lista para el estado de los zapatos*/
  final List<String> listaEstado = ['Disponible', 'En reposicion'];
  String? estadoSeleccionado;

  @override
  Widget build(BuildContext context) {
    final shoesProvider = context.watch<
        ShoesProvider>(); /*shoesProvider va a estar mirando los cambios en ShoesProvider. La REFERENCIAS SE CREAN
        DENTRO DEL METODO BUILD*/
    final categoriesProvider = context.watch<CategoriaProvider>();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          title: const Text('Agregar zapato'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            /*Con padding damos margen y con la propiedad EdgeInsets.SYMMETRIC (symmetric significa
            que vamos a quitar un % de un lado y del otro en partes iguales) en este caso
            estamos haciendolo con horizontal. Obtenemos el ancho del dispositivo y lo multiplicamos
            por el porcentaje que queremos reducir*/
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.4),
            child: Column(
              children: [
                TextFormDefault(
                    textEditingController: textNombreController,
                    hintTextForm: 'Nombre'),
                TextFormDefault(
                  textEditingController: textPrecioController,
                  hintTextForm: 'Precio',
                  keyboardType: TextInputType.number,
                  inputFormatter: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                  ],
                ),
                TextFormDefault(
                  textEditingController: textCantidadController,
                  hintTextForm: 'Cantidad',
                  keyboardType: TextInputType.number,
                  inputFormatter: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                  ],
                ),
                DropdownButtonFormField(
                    value: categoriaSeleccionada,
                    items: categoriesProvider.listaCategoria
                        .map((Categoria categoria) {
                      return DropdownMenuItem(
                        value: categoria.idcategoria.toString(),
                        child: Text(categoria.nombre),
                      );
                    }).toList(),
                    onChanged: (String? nuevoValor) {
                      setState(() {
                        categoriaSeleccionada = nuevoValor;
                      });
                    }),
                DropdownButtonFormField(
                    value: estadoSeleccionado,
                    items: listaEstado.map((String estado) {
                      return DropdownMenuItem(
                        value: estado,
                        child: Text(estado),
                      );
                    }).toList(),
                    onChanged: (String? nuevoValor) {
                      setState(() {
                        estadoSeleccionado = nuevoValor;
                      });
                    }),
                TextFormDefault(
                  textEditingController: textDescripcionController,
                  hintTextForm: 'Descripcion',
                  maxLines: 3,
                ),
                /*EN FLUTTER T O D O ES UN WIDGET *inserte voz de regaño*
                * */
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextButton(
                          onPressed: () async {
                            final SharedPreferences preferences =
                                await SharedPreferences.getInstance();
                            final idempleado = preferences.getInt('idempleado');
                            final role = preferences.getString('role');
                            final Zapato zapato = Zapato(
                                nombre: textNombreController.text,
                                precio: double.parse(textPrecioController.text),
                                cantidad:
                                    int.parse(textCantidadController.text),
                                descripcion: textDescripcionController.text,
                                estado: estadoSeleccionado == 'Disponible',
                                categoria: categoriesProvider.listaCategoria
                                    .firstWhere((element) =>
                                        element.idcategoria.toString() ==
                                        categoriaSeleccionada),
                                /*FIRSTWHERE(funciona solamente en listas) va devolver el primer item de la categoria que cumpla con una condicion
                                *El element dentro del parentesis hace refrencia una categoria y lo que hace es que recorre la lista
                                * de categoria hasta que encuentra un elemento que cumpla la condicion de busqueda   */
                                empleados: Empleado.save(idempleado, role));
                            final saved =
                                await shoesProvider.createShoes(zapato);
                            if (saved) {
                              showToast('Zapato creado correctamente :)',
                                  context: context);
                              if (context.mounted) {
                                context
                                    .pop();
                              }
                            } else {
                              showToast(
                                  'Hubo un error al crear el zapato. Intente nuevamente. :(',
                                  context: context);
                            }
                          },
                          style: const ButtonStyle(
                            backgroundColor:
                                WidgetStatePropertyAll<Color>(Colors.blue),
                          ),
                          child: const Text(
                            'Guardar',
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
      ),
    );
  }
}
