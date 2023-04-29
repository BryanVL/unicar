import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unicar/providers/database_provider.dart';
import 'package:unicar/providers/usuario_provider.dart';
import 'package:unicar/screens/tab_bar_screen.dart';
import 'package:unicar/widgets/texto.dart';

import '../widgets/buttons.dart';
import '../widgets/textform.dart';

class CambiarNombreScreen extends ConsumerStatefulWidget {
  const CambiarNombreScreen({super.key});
  static const kRouteName = "/cambiarNombre";
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CambiarNombreScreen();
}

class _CambiarNombreScreen extends ConsumerState<CambiarNombreScreen> {
  final _formKey = GlobalKey<FormState>();
  final nombreController = TextEditingController();

  void _actualizarDatos(String nombre) async {
    ref.read(databaseProvider).actualizarDatosUsuario(
        ref.read(usuarioProvider)!.id, nombre, ref.read(usuarioProvider)!.urlIcono);
    ref.read(usuarioProvider.notifier).state =
        ref.read(usuarioProvider.notifier).state!.copyWith(nombre: nombre);
    if (context.mounted) {
      Navigator.of(context).pushReplacementNamed(TabBarScreen.kRouteName);
    }
  }

  @override
  void initState() {
    super.initState();
    nombreController.text = ref.read(usuarioProvider)!.nombre;
  }

  @override
  void dispose() {
    super.dispose();
    nombreController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('cambiar nombre'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.only(top: 32.0, left: 8, right: 8, bottom: 32),
            child: Column(
              children: [
                const TextoTitulo(texto: 'Introduce el nuevo nombre'),
                const SizedBox(
                  height: 20,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Este nombre sera visible para otros usuarios, no puede estar vacio',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                    ),
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
                      Navigator.of(context).pop();
                    }
                  },
                  textoBoton: 'Actualizar',
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
