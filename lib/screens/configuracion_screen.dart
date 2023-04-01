import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unicar/providers/database_provider.dart';
import 'package:unicar/providers/tema_provider.dart';
import 'package:unicar/screens/datos_extra_defecto_screen.dart';
import 'package:unicar/widgets/buttons.dart';
import 'package:unicar/widgets/texto.dart';

import 'cambiar_nombre_screen.dart';

class ConfiguracionScreen extends ConsumerWidget {
  const ConfiguracionScreen({super.key});
  static const kRouteName = "/Configuracion";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tema = ref.watch(temaProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Ajustes'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const TextoTitulo(texto: 'Modo oscuro '),
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: tema.when(
                    data: (data) {
                      bool estado = data == 'claro' ? false : true;
                      return Switch(
                        value: estado,
                        onChanged: (value) {
                          ref.read(temaProvider.notifier).cambiarTema();
                        },
                      );
                    },
                    error: (error, stackTrace) => const SizedBox(
                      height: 10,
                      width: 10,
                    ),
                    loading: () => const CircularProgressIndicator(),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 0,
            ),
            ListTile(
              title: const TextoTitulo(
                texto: 'Establecer datos extra por defecto',
                padding: EdgeInsets.zero,
              ),
              shape: Border(
                  bottom: BorderSide(width: 2, color: Colors.grey[300]!),
                  top: BorderSide(width: 2, color: Colors.grey[300]!)),
              onTap: () {
                Navigator.of(context).pushNamed(DatosExtraDefectoScreen.kRouteName);
              },
            ),
            ListTile(
              title: const TextoTitulo(
                texto: 'Cambiar nombre',
                padding: EdgeInsets.zero,
              ),
              shape: Border(
                bottom: BorderSide(width: 2, color: Colors.grey[300]!),
              ),
              onTap: () {
                Navigator.of(context).pushNamed(CambiarNombreScreen.kRouteName);
              },
            ),
            const SizedBox(
              height: 32,
            ),
            /*BotonMaterial(
              contenido: const Text(
                'Cerrar sesion',
                style: TextStyle(fontSize: 18),
              ),
              funcion: () {
                ref.read(databaseProvider.notifier).cerrarSesion(context);
              },
            ),*/
            Boton(
              funcion: () {
                ref.read(databaseProvider.notifier).cerrarSesion(context);
              },
              textSize: 20,
              textoBoton: 'Cerrar sesión',
            ),
            const SizedBox(
              height: 256,
            ),
            const TextoTitulo(texto: 'Cuidado, Terreno peligroso'),
            const SizedBox(
              height: 32,
            ),
            Boton(
              funcion: () async {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: const Text(
                        'ATENCION, estas apunto de borrar de manera definitiva todos tus datos, esta acción no se puede deshacer, ¿Quieres continuar?',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            ref.read(databaseProvider.notifier).borrarCuenta(context);
                          },
                          style: TextButton.styleFrom(backgroundColor: Colors.red),
                          child: const Text(
                            'Borrar definitivamente',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 40,
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancelar'),
                        ),
                      ],
                    );
                  },
                );
              },
              textSize: 20,
              textoBoton: 'Borrar cuenta',
              colorBoton: Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}
