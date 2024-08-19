import 'package:complexivo/models/zapato.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../provider/shoes_provider.dart';

class DetailPage extends StatelessWidget {
  const DetailPage(this.zapato, {super.key});

  final Zapato zapato;

  @override
  Widget build(BuildContext context) {
    final shoesProvider = context.watch<ShoesProvider>();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () async {
                  final saved = await shoesProvider.updateShoes(zapato);
                  if (saved) {
                    showToast('Zapato actualizado correctamente :)',
                        context: context);
                    if (context.mounted) {
                      context.pop();
                    }
                  } else {
                    showToast(
                        'Hubo un error al moficiar el zapato. Intente nuevamente. :(',
                        context: context);
                  }
                },
                icon: const Icon(Icons.edit)),
            IconButton(
                onPressed: () async {
                  final saved = await shoesProvider.deleteShoes(zapato);
                  if (saved) {
                    showToast('Zapato eliminado correctamente :)',
                        context: context);
                    if (context.mounted) {
                      context.pop();
                    }
                  } else {
                    showToast(
                        'Hubo un error al eliminar el zapato. Intente nuevamente. :(',
                        context: context);
                  }
                },
                icon: const Icon(Icons.delete)),
          ],
          backgroundColor: Colors.blue,
          foregroundColor: Colors
              .white, /*para cambiar el color del icono del app y del text del appbar*/
        ),
        body: Column(
          children: [
            //   Image.asset('assets/zapato.jpg'),
            Text(zapato.nombre),
            Text(zapato.cantidad.toString()),
            Text(zapato.categoria!.nombre),
            Text(zapato.precio.toString()),
            Text(zapato.descripcion),
            Text(zapato.estado ? 'Disponible' : 'En reposicion'),
          ],
        ),
      ),
    );
  }
}
