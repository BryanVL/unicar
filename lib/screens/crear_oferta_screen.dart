import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unicar/providers/oferta_provider.dart';
import 'package:unicar/widgets/buttons.dart';
import 'package:unicar/widgets/textform.dart';

import '../widgets/dropdown.dart';

class CrearOferta extends ConsumerStatefulWidget {
  const CrearOferta({super.key});

  static const kRouteName = "/CrearOferta";

  @override
  ConsumerState<CrearOferta> createState() => _CrearOfertaState();
}

class _CrearOfertaState extends ConsumerState<CrearOferta> {
  String dropdownValueOrigen = 'Selecciona uno';
  String dropdownValueDestino = 'Selecciona uno';
  TextEditingController plazasController = TextEditingController();
  TextEditingController descripcionController = TextEditingController();
  TextEditingController tituloController = TextEditingController();
  TextEditingController horaController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    plazasController.dispose();
    descripcionController.dispose();
    tituloController.dispose();
    horaController.dispose();
  }

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nuevo viaje'),
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
              CustomDropdown(titulo: 'Origen:', callback: callbackOrigen),
              CustomDropdown(titulo: 'Destino:', callback: callbackDestino),
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
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 7)),
                        dateLabelText: 'Selecciona una fecha y hora',
                        validator: (value) {
                          return horaController.text == ''
                              ? 'Este campo no puede estar vacio'
                              : null;
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 48.0,
                  right: 48,
                  top: 32,
                  bottom: 8,
                ),
                child: MyTextForm(
                  controlador: plazasController,
                  label: 'Plazas disponibles del viaje',
                  funcionValidacion: (value) {
                    return plazasController.text == '' ? 'Este campo no puede estar vacio' : null;
                  },
                  tipoInput: [FilteringTextInputFormatter.digitsOnly],
                  tipoTeclado: TextInputType.number,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 48.0,
                  right: 48,
                  top: 16,
                  bottom: 8,
                ),
                child: MyTextForm(
                  controlador: tituloController,
                  label: 'Titulo (Opcional)',
                  hint: 'Escribe un titulo',
                  funcionValidacion: null,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 48.0,
                  right: 48,
                  top: 16,
                  bottom: 32,
                ),
                child: MyTextForm(
                  controlador: descripcionController,
                  label: 'Descripción (Opcional)',
                  funcionValidacion: null,
                  hint: 'Escribe algo para reconocerte',
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 32.0),
                child: Boton(
                  paddingTodo: 12,
                  funcion: () async {
                    if (dropdownValueDestino == dropdownValueOrigen) {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: const Text('El origen y el destino no pueden ser iguales'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Aceptar'),
                                ),
                              ],
                            );
                          });
                    }
                    if (_formKey.currentState!.validate() &&
                        (dropdownValueOrigen != 'Selecciona uno' &&
                            dropdownValueDestino != 'Selecciona uno' &&
                            horaController.text != '' &&
                            dropdownValueDestino != dropdownValueOrigen)) {
                      ref.read(ofertasOfrecidasUsuarioProvider.notifier).addNewOferta(
                            dropdownValueOrigen,
                            dropdownValueDestino,
                            DateTime.tryParse(horaController.text)!.toIso8601String(),
                            plazasController.text,
                            descripcionController.text,
                            tituloController.text,
                          );

                      if (context.mounted) {
                        Navigator.of(context).pop();
                      }
                    }
                  },
                  textoBoton: 'Publicar oferta',
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
