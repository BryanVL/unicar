import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unicar/providers/oferta_provider.dart';

import '../widgets/buttons.dart';
import '../widgets/dropdown.dart';

class FiltrarScreen extends ConsumerStatefulWidget {
  const FiltrarScreen({super.key});
  static const kRouteName = "/Filtrar";
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FiltrarScreenState();
}

class _FiltrarScreenState extends ConsumerState<FiltrarScreen> {
  String dropdownValueOrigen = 'Selecciona uno';
  String dropdownValueDestino = 'Selecciona uno';
  TextEditingController horaController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  callbackOrigen(valorElegido) {
    setState(() {
      dropdownValueOrigen = valorElegido;
    });
  }

  callbackDestino(valorElegido) {
    setState(() {
      dropdownValueDestino = valorElegido;
    });
  }

  @override
  initState() {
    super.initState();
    horaController.text = ref.read(ofertasDisponiblesProvider.notifier).filtroHora;
    dropdownValueOrigen = ref.read(ofertasDisponiblesProvider.notifier).filtroOrigen;
    dropdownValueDestino = ref.read(ofertasDisponiblesProvider.notifier).filtroDestino;
  }

  @override
  dispose() {
    super.dispose();
    horaController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Elige el valor por el que filtrar'),
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
          child: Column(
            children: [
              CustomDropdown(
                titulo: 'Origen:',
                callback: callbackOrigen,
                valorDefecto: dropdownValueOrigen,
              ),
              CustomDropdown(
                titulo: 'Destino:',
                callback: callbackDestino,
                valorDefecto: dropdownValueDestino,
              ),
              //TODO poner seleccion personalizada de posicion
              Container(
                width: 300,
                height: 200,
                color: Colors.green,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0, bottom: 8),
                    child: SizedBox(
                      height: 75,
                      width: 300,
                      child: DateTimePicker(
                        controller: horaController,
                        type: DateTimePickerType.dateTime,
                        firstDate: DateTime.now().subtract(const Duration(days: 1)),
                        lastDate: DateTime.now().add(const Duration(days: 7)),
                        dateLabelText: 'Selecciona una fecha y hora',
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 32.0, top: 64),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: Boton(
                        paddingTodo: 12,
                        funcion: () async {
                          ref.read(ofertasDisponiblesProvider.notifier).filtrar(
                              dropdownValueOrigen, dropdownValueDestino, horaController.text);
                          Navigator.of(context).pop();
                        },
                        textoBoton: 'Aplicar filtros',
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Boton(
                        colorBoton: Colors.red,
                        paddingTodo: 12,
                        funcion: () async {
                          ref
                              .read(ofertasDisponiblesProvider.notifier)
                              .eliminarFiltros()
                              .then((value) => Navigator.of(context).pop());
                        },
                        textoBoton: 'Eliminar filtros aplicados',
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
