import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:unicar/providers/oferta_provider.dart';
import 'package:unicar/screens/mapa_screen.dart';
import 'package:unicar/widgets/buttons.dart';
import 'package:unicar/widgets/textform.dart';
import 'package:unicar/widgets/texto.dart';

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
  String? origenPersonalizado;
  String? destinoPersonalizado;
  LatLng? coordOrigen;
  LatLng? coordDestino;
  int? radioOrigen;
  int? radioDestino;
  int indiceSeleccionado = 0;
  Widget? pos;
  int groupValue = 0;

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

  callbackOrigenPersonalizado(
      String lugarElegido, LatLng coordenadas, String radio, String origen) {
    setState(() {
      dropdownValueOrigen = origen;
      coordOrigen = coordenadas;
      origenPersonalizado = lugarElegido;
      radioOrigen = int.parse(radio);
    });
  }

  callbackDestinoPersonalizado(
      String lugarElegido, LatLng coordenadas, String radio, String destino) {
    setState(() {
      dropdownValueDestino = destino;
      coordDestino = coordenadas;
      destinoPersonalizado = lugarElegido;
      radioDestino = int.parse(radio);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget simple = Column(
      children: [
        const SizedBox(height: 8),
        CustomDropdown(titulo: 'Origen:', callback: callbackOrigen),
        CustomDropdown(titulo: 'Destino:', callback: callbackDestino),
      ],
    );

    Widget pers = Column(
      children: [
        BotonMaterial(
          contenido: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Selecciona un origen personalizado',
                style: TextStyle(fontSize: 16),
              ),
              Icon(
                Icons.open_in_new,
                size: 24,
              ),
            ],
          ),
          funcion: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => MapaScreen(callbackOrigenPersonalizado)),
            );
          },
        ),
        BotonMaterial(
          contenido: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Selecciona un destino personalizado',
                style: TextStyle(fontSize: 16),
              ),
              Icon(
                Icons.open_in_new,
                size: 24,
              ),
            ],
          ),
          funcion: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => MapaScreen(callbackDestinoPersonalizado)),
            );
          },
        ),
        const SizedBox(height: 8),
        TextoTitulo(
          texto: 'Origen seleccionado',
          padding: const EdgeInsets.only(top: 8, left: 24, right: 24, bottom: 8),
          sizeTexto: 20,
          colorTexto: Colors.grey[400],
        ),
        Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 32.0),
              child: Text(origenPersonalizado != null
                  ? '$origenPersonalizado, Radio: $radioOrigen metros'
                  : 'Ningún origen seleccionado'),
            )),
        TextoTitulo(
          texto: 'Destino seleccionado',
          padding: const EdgeInsets.only(top: 12, left: 24, right: 24, bottom: 4),
          sizeTexto: 20,
          colorTexto: Colors.grey[400],
        ),
        Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 32.0),
              child: Text(destinoPersonalizado != null
                  ? '$destinoPersonalizado, Radio: $radioDestino metros'
                  : 'Ningún destino seleccionado'),
            )),
      ],
    );

    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(''),
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
              const TextoTitulo(texto: 'Selección de posición'),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: ToggleSwitch(
                  initialLabelIndex: indiceSeleccionado,
                  totalSwitches: 2,
                  minWidth: 175,
                  minHeight: 35,
                  borderWidth: 2,
                  labels: const ['Simple', 'Personalizado'],
                  inactiveBgColor: Colors.white,
                  borderColor: const [Colors.blue],
                  customTextStyles: const [TextStyle(fontSize: 18)],
                  animate: true,
                  animationDuration: 200,
                  curve: Curves.linear,
                  onToggle: (index) {
                    if (index == 0) {
                      indiceSeleccionado = 0;
                      pos = simple;
                    } else {
                      indiceSeleccionado = 1;
                      pos = pers;
                    }
                    dropdownValueOrigen = 'Selecciona uno';
                    dropdownValueDestino = 'Selecciona uno';
                    origenPersonalizado = null;
                    destinoPersonalizado = null;
                    setState(() {});
                  },
                ),
              ),
              AnimatedCrossFade(
                firstChild: simple,
                secondChild: pers,
                crossFadeState:
                    indiceSeleccionado == 0 ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                duration: const Duration(milliseconds: 200),
                layoutBuilder: (topChild, topKey, bottomChild, bottomKey) {
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        key: bottomChild.key,
                        top: 0,
                        child: bottomChild,
                      ),
                      Positioned(
                        key: topChild.key,
                        child: topChild,
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 24),
              const TextoTitulo(
                texto: 'Selección de hora',
                padding: EdgeInsets.only(top: 8, left: 16),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: RadioListTile(
                        title: const Text(
                          'Estar a',
                          style: TextStyle(fontSize: 18),
                        ),
                        value: 0,
                        groupValue: groupValue,
                        onChanged: (value) {
                          setState(() {
                            groupValue = 0;
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: RadioListTile(
                        title: const Text(
                          'Salir a',
                          style: TextStyle(fontSize: 18),
                        ),
                        value: 1,
                        groupValue: groupValue,
                        onChanged: (value) {
                          setState(() {
                            groupValue = 1;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 0.0, bottom: 8),
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
                      return horaController.text == '' ? 'Este campo no puede estar vacio' : null;
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const TextoTitulo(
                texto: 'Plazas y otros',
                padding: EdgeInsets.only(top: 8, left: 16),
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
                        (((dropdownValueOrigen != 'Selecciona uno' &&
                                    dropdownValueDestino != 'Selecciona uno') ||
                                (origenPersonalizado != null && destinoPersonalizado != null)) &&
                            horaController.text != '' &&
                            dropdownValueDestino != dropdownValueOrigen)) {
                      ref.read(ofertasOfrecidasUsuarioProvider.notifier).addNewOferta(
                            dropdownValueOrigen, //indiceSeleccionado == 0 ? dropdownValueOrigen : origenPersonalizado!,
                            dropdownValueDestino, //indiceSeleccionado == 0 ? dropdownValueDestino : destinoPersonalizado!,
                            DateTime.tryParse(horaController.text)!.toIso8601String(),
                            plazasController.text,
                            descripcionController.text,
                            tituloController.text,
                            coordOrigen,
                            coordDestino,
                            radioOrigen,
                            radioDestino,
                            groupValue == 0,
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
