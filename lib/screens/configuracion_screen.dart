import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unicar/providers/database_provider.dart';
import 'package:unicar/widgets/buttons.dart';

class ConfiguracionScreen extends ConsumerStatefulWidget {
  const ConfiguracionScreen({super.key});
  static const kRouteName = "/Configuracion";
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ConfiguracionScreenState();
}

class _ConfiguracionScreenState extends ConsumerState<ConfiguracionScreen> {
  @override
  Widget build(BuildContext context) {
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
            Boton(
              funcion: () {
                ref.read(databaseProvider.notifier).cerrarSesion(context);
              },
              textoBoton: 'Cerrar sesión',
              paddingTodo: 12,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 64.0),
              child: Boton(
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
                textoBoton: 'Borrar cuenta',
                paddingTodo: 12,
                colorBoton: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
