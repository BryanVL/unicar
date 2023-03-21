import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:unicar/providers/usuario_provider.dart';
import 'package:unicar/screens/tab_bar_screen.dart';

import '../providers/tema_provider.dart';
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
    await Supabase.instance.client.from('usuario').update(
      {
        'nombre': nombre,
      },
    ).match(
      {
        'id': ref.read(usuarioProvider),
      },
    );
    if (context.mounted) {
      Navigator.of(context).pushReplacementNamed(TabBarScreen.kRouteName);
    }
  }

  void innitState() {
    nombreController.text = '';
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
                    tipoTeclado: TextInputType.emailAddress,
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
