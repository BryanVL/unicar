import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unicar/providers/oferta_provider.dart';
import 'package:unicar/screens/tab_bar_screen.dart';

import '../models/oferta.dart';
import '../widgets/buttons.dart';
import '../widgets/dropdown.dart';

class EditarOfertaScreen extends ConsumerStatefulWidget {
  const EditarOfertaScreen(this.oferta, {super.key});
  final Oferta oferta;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditarOfertaScreenState();
}

class _EditarOfertaScreenState extends ConsumerState<EditarOfertaScreen> {
  String dropdownValueOrigen = '';
  String dropdownValueDestino = '';
  TextEditingController plazasController = TextEditingController();
  TextEditingController descripcionController = TextEditingController();
  TextEditingController tituloController = TextEditingController();
  TextEditingController horaController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  initState() {
    super.initState();
    dropdownValueOrigen = widget.oferta.origen;
    dropdownValueDestino = widget.oferta.destino;
    plazasController.text = '${widget.oferta.plazasTotales}';
    descripcionController.text = widget.oferta.descripcion ?? '';
    tituloController.text = widget.oferta.titulo ?? '';
    horaController.text = widget.oferta.hora;
  }

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
                child: TextFormField(
                  controller: plazasController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    return plazasController.text == '' ? 'Este campo no puede estar vacio' : null;
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    )),
                    labelText: 'Plazas disponibles del viaje',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 48.0,
                  right: 48,
                  top: 8,
                ),
                child: TextFormField(
                  controller: tituloController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    )),
                    labelText: 'Añade un titulo (Opcional)',
                    hintText: 'Escribe algún titulo',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 48.0,
                  right: 48,
                  top: 8,
                  bottom: 32,
                ),
                child: TextFormField(
                  controller: descripcionController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      )),
                      labelText: 'Añade una descripción (Opcional)',
                      hintText: 'Escribe algo para reconocerte'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 32.0),
                child: Boton(
                  paddingLeft: 8,
                  paddingRight: 8,
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
                            dropdownValueDestino != dropdownValueOrigen &&
                            int.parse(plazasController.text) >=
                                (widget.oferta.plazasTotales - widget.oferta.plazasDisponibles))) {
                      ref.read(ofertasOfrecidasUsuarioProvider.notifier).editarOferta(
                            widget.oferta.id,
                            dropdownValueOrigen,
                            dropdownValueDestino,
                            plazasController.text,
                            DateTime.tryParse(horaController.text)!.toIso8601String(),
                            tituloController.text,
                            descripcionController.text,
                          );

                      Navigator.of(context).popUntil(ModalRoute.withName(TabBarScreen.kRouteName));
                    }
                  },
                  textoBoton: 'Actualizar datos',
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
