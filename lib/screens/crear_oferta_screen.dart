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
  String selectedTime = '';
  TimeOfDay valorHora = TimeOfDay.now();
  String dropdownValueOrigen = 'Selecciona uno';
  String dropdownValueDestino = 'Selecciona uno';
  TextEditingController plazasController = TextEditingController();
  TextEditingController descripcionController = TextEditingController();
  TextEditingController tituloController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    plazasController.dispose();
    descripcionController.dispose();
    tituloController.dispose();
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
              //TODO poner fecha y hora en vez de solo hora
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0, bottom: 8),
                    child: Boton(
                        paddingTodo: 12,
                        funcion: () async {
                          final TimeOfDay? pickedT = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );

                          if (pickedT != null) {
                            setState(() {
                              valorHora = pickedT;
                              selectedTime = pickedT.minute < 10
                                  ? '${pickedT.hour}:0${pickedT.minute}'
                                  : '${pickedT.hour}:${pickedT.minute}';
                            });
                          }
                        },
                        textoBoton: 'Selecciona la hora de comienzo del viaje'),
                  ),
                ],
              ),

              Text(
                'Hora seleccionada: $selectedTime',
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
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
                            selectedTime != '' &&
                            dropdownValueDestino != dropdownValueOrigen)) {
                      ref.read(ofertasOfrecidasUsuarioProvider.notifier).addNewOferta(
                            dropdownValueOrigen,
                            dropdownValueDestino,
                            selectedTime,
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
