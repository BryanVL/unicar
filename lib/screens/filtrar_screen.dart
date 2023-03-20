import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:unicar/providers/oferta_provider.dart';
import 'package:unicar/widgets/seleccion_posicion.dart';

import '../widgets/buttons.dart';
import '../widgets/dropdown.dart';
import '../widgets/texto.dart';
import 'mapa_screen.dart';

//TODO arreglar
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
  String? origenPersonalizado;
  String? destinoPersonalizado;
  LatLng? coordOrigen;
  LatLng? coordDestino;
  int? radioOrigen;
  int? radioDestino;
  int groupValue = 2;
  int indiceSeleccionado = 0;
  Widget? pos;

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
  initState() {
    super.initState();
    horaController.text = ref.read(ofertasDisponiblesProvider.notifier).filtroHora;
    dropdownValueOrigen = ref.read(ofertasDisponiblesProvider.notifier).filtroOrigen;
    dropdownValueDestino = ref.read(ofertasDisponiblesProvider.notifier).filtroDestino;
    coordOrigen = ref.read(ofertasDisponiblesProvider.notifier).filtroCoordOrigen;
    coordDestino = ref.read(ofertasDisponiblesProvider.notifier).filtroCoordDestino;
    radioOrigen = ref.read(ofertasDisponiblesProvider.notifier).filtroRadioOrigen;
    radioDestino = ref.read(ofertasDisponiblesProvider.notifier).filtroRadioDestino;
    groupValue = ref.read(ofertasDisponiblesProvider.notifier).filtroGroupValue;
    indiceSeleccionado = coordOrigen != null || coordDestino != null ? 1 : 0;
  }

  @override
  dispose() {
    super.dispose();
    horaController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /*Widget simple = Column(
      children: [
        const SizedBox(height: 8),
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
              MaterialPageRoute(builder: (context) => MapaScreen('origen')),
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
              MaterialPageRoute(builder: (context) => MapaScreen('destino')),
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
          ),
        ),
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
          ),
        ),
      ],
    );*/

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
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
              const TextoTitulo(texto: 'Filtra por posición'),
              const SeleccionPosicion(),
              /*Padding(
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

                    setState(() {
                      dropdownValueOrigen = 'Selecciona uno';
                      dropdownValueDestino = 'Selecciona uno';
                      origenPersonalizado = null;
                      destinoPersonalizado = null;
                      coordOrigen = null;
                      coordDestino = null;
                    });
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
              ),*/
              const SizedBox(height: 24),
              const TextoTitulo(texto: 'Filtra por hora'),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    Row(
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
                    RadioListTile(
                      title: const Text(
                        'Ambos',
                        style: TextStyle(fontSize: 18),
                      ),
                      value: 2,
                      groupValue: groupValue,
                      onChanged: (value) {
                        setState(() {
                          groupValue = 2;
                        });
                      },
                    ),
                  ],
                ),
              ),
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
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 64.0, top: 64),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: Boton(
                        textSize: 16,
                        colorBoton: Colors.red,
                        funcion: () async {
                          ref
                              .read(ofertasDisponiblesProvider.notifier)
                              .eliminarFiltros()
                              .then((value) => Navigator.of(context).pop());
                        },
                        textoBoton: 'Eliminar filtros aplicados',
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Boton(
                        textSize: 16,
                        funcion: () async {
                          ref.read(ofertasDisponiblesProvider.notifier).filtrar(
                                dropdownValueOrigen,
                                dropdownValueDestino,
                                horaController.text,
                                coordOrigen,
                                coordDestino,
                                radioOrigen,
                                radioDestino,
                                groupValue,
                              );
                          Navigator.of(context).pop();
                        },
                        textoBoton: 'Aplicar filtros',
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
