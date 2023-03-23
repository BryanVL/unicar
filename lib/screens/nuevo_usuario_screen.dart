import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unicar/providers/database_provider.dart';
import 'package:unicar/providers/usuario_provider.dart';
import 'package:unicar/screens/tab_bar_screen.dart';

import '../widgets/buttons.dart';
import '../widgets/textform.dart';

class NuevoUsuarioScreen extends ConsumerStatefulWidget {
  const NuevoUsuarioScreen({super.key});
  static const kRouteName = "/NuevoUsuario";
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NuevoUsuarioScreen();
}

class _NuevoUsuarioScreen extends ConsumerState<NuevoUsuarioScreen> {
  final _formKey = GlobalKey<FormState>();
  final nombreController = TextEditingController();

  void _actualizarDatos(String nombre) async {
    ref.read(databaseProvider).actualizarDatosUsuario(ref.read(usuarioProvider)!.id, nombre, null);
    if (context.mounted) {
      Navigator.of(context).pushReplacementNamed(TabBarScreen.kRouteName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.only(top: 64.0, left: 16, right: 16, bottom: 32),
            child: Column(
              children: [
                const Text(
                  'Introduce un nombre para continuar',
                  style: TextStyle(fontSize: 24),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Este nombre sera visible para otros usuarios y puedes cambiarlo en el menu de ajustes cuando quieras',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 32, bottom: 32.0, left: 32, right: 32),
                  child: MyTextForm(
                    controlador: nombreController,
                    tipoTeclado: TextInputType.text,
                    label: 'Nombre de usuario',
                    funcionValidacion: (String? value) {
                      if (nombreController.text == '') {
                        return 'Este campo no puede estar vacio';
                      }

                      return null;
                    },
                  ),
                ),
                Boton(
                  funcion: () async {
                    if (_formKey.currentState!.validate()) {
                      _actualizarDatos(nombreController.text);
                    }
                  },
                  textoBoton: 'Continuar',
                  paddingTodo: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
