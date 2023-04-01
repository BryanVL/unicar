import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unicar/providers/database_provider.dart';
import 'package:unicar/providers/usuario_provider.dart';
import 'package:unicar/widgets/buttons.dart';

import '../widgets/textform.dart';

class DatosExtraDefectoScreen extends ConsumerStatefulWidget {
  const DatosExtraDefectoScreen({super.key});
  static const kRouteName = "/DatosExtraDefecto";
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DatosExtraDefectoScreenState();
}

class _DatosExtraDefectoScreenState extends ConsumerState<DatosExtraDefectoScreen> {
  TextEditingController descripcionController = TextEditingController();
  TextEditingController tituloController = TextEditingController();
  @override
  initState() {
    descripcionController.text = ref.read(usuarioProvider)!.descripcionDefecto ?? '';
    tituloController.text = ref.read(usuarioProvider)!.tituloDefecto ?? '';

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    descripcionController.dispose();
    tituloController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Establecer datos extra'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 32,
              left: 32,
              right: 32,
            ),
            child: Container(
              decoration: const BoxDecoration(
                border: Border.fromBorderSide(
                  BorderSide(
                    color: Colors.blue,
                    width: 3,
                  ),
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              padding: const EdgeInsets.only(top: 8.0, bottom: 8, left: 8, right: 8),
              child: const Text(
                'Si quieres eliminar una descripción por defecto puedes dejar en blanco el cuadro de texto que quieras eliminar',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  color: Colors.blue,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 32,
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 48.0,
              right: 48,
              bottom: 12,
            ),
            child: MyTextForm(
              controlador: tituloController,
              label: 'Titulo (Opcional)',
              hint: 'Escribe un titulo',
              funcionValidacion: null,
              maximoCaracteres: 50,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 48.0,
              right: 48,
              bottom: 32,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 500,
                maxHeight: 135,
              ),
              child: Scrollbar(
                thickness: 0,
                child: MyTextForm(
                  controlador: descripcionController,
                  label: 'Descripción (Opcional)',
                  funcionValidacion: null,
                  hint: 'Escribe algo para reconocerte',
                  usarMaximo: true,
                  maximoCaracteres: 500,
                ),
              ),
            ),
          ),
          Boton(
            funcion: () {
              ref.read(databaseProvider).actualizarDatosExtraUsuario(
                  ref.read(usuarioProvider)!.id, tituloController.text, descripcionController.text);
              ref.read(usuarioProvider.notifier).state = ref
                  .read(usuarioProvider.notifier)
                  .state!
                  .copyWith(
                      tituloDefecto: tituloController.text,
                      descripcionDefecto: descripcionController.text);
              Navigator.of(context).pop();
            },
            textoBoton: 'Actualizar datos',
          )
        ],
      ),
    );
  }
}
