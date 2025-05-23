import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unicar/models/localizacion.dart';
import 'package:unicar/providers/dropdown_provider.dart';
import 'package:unicar/providers/localizacion_provider.dart';
import 'package:unicar/providers/oferta_provider.dart';
import 'package:unicar/screens/tab_bar_screen.dart';
import 'package:unicar/widgets/seleccion_posicion.dart';

import '../models/oferta.dart';
import '../widgets/buttons.dart';
import '../widgets/textform.dart';
import '../widgets/texto.dart';

class EditarOfertaScreen extends ConsumerStatefulWidget {
  const EditarOfertaScreen(this.oferta, {super.key});
  final Oferta oferta;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditarOfertaScreenState();
}

class _EditarOfertaScreenState extends ConsumerState<EditarOfertaScreen> {
  TextEditingController plazasController = TextEditingController();
  TextEditingController descripcionController = TextEditingController();
  TextEditingController tituloController = TextEditingController();
  TextEditingController horaController = TextEditingController();

  int groupValue = 0;
  final _formKey = GlobalKey<FormState>();

  @override
  initState() {
    groupValue = widget.oferta.paraEstarA ? 0 : 1;
    plazasController.text = '${widget.oferta.plazasTotales}';
    descripcionController.text = widget.oferta.descripcion ?? '';
    tituloController.text = widget.oferta.titulo ?? '';
    horaController.text = widget.oferta.hora;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    plazasController.dispose();
    descripcionController.dispose();
    tituloController.dispose();
    horaController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future(() {
      if (widget.oferta.coordOrigen != null) {
        ref.read(posicionPersonalizadaProvider(TipoPosicion.origen).notifier).state =
            LocalizacionPersonalizada(
          nombreCompleto: widget.oferta.origen,
          localidad: widget.oferta.origen,
          coordenadas: widget.oferta.coordOrigen!,
          radio: widget.oferta.radioOrigen!,
        );
        ref.read(posicionPersonalizadaProvider(TipoPosicion.destino).notifier).state =
            LocalizacionPersonalizada(
          nombreCompleto: widget.oferta.destino,
          localidad: widget.oferta.destino,
          coordenadas: widget.oferta.coordDestino!,
          radio: widget.oferta.radioDestino!,
        );
      } else {
        ref.read(dropdownProvider(TipoPosicion.origen).notifier).state = widget.oferta.origen;
        ref.read(dropdownProvider(TipoPosicion.destino).notifier).state = widget.oferta.destino;
      }
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(widget.oferta.titulo ?? 'Viaje a ${widget.oferta.destino}'),
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
              SeleccionPosicion(indice: widget.oferta.coordOrigen != null ? 1 : 0),
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
                  bottom: 12,
                ),
                child: MyTextForm(
                  controlador: plazasController,
                  label: 'Plazas disponibles del viaje',
                  funcionValidacion: (value) {
                    return plazasController.text == '' ? 'Este campo no puede estar vacio' : null;
                  },
                  tipoInput: [FilteringTextInputFormatter.digitsOnly],
                  tipoTeclado: TextInputType.number,
                  maximoCaracteres: 2,
                ),
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
              Padding(
                padding: const EdgeInsets.only(bottom: 64.0),
                child: Boton(
                  funcion: () async {
                    final dpOrigen = ref.read(dropdownProvider(TipoPosicion.origen));
                    final dpDestino = ref.read(dropdownProvider(TipoPosicion.destino));
                    final origen = ref.read(posicionPersonalizadaProvider(TipoPosicion.origen));
                    final destino = ref.read(posicionPersonalizadaProvider(TipoPosicion.destino));

                    final origenPersonalizado = origen?.nombreCompleto;
                    final destinoPersonalizado = destino?.nombreCompleto;
                    if (dpOrigen == dpDestino &&
                        (origenPersonalizado == null || destinoPersonalizado == null)) {
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
                        (((dpOrigen != 'Selecciona uno' && dpDestino != 'Selecciona uno') ||
                                (origenPersonalizado != null && destinoPersonalizado != null)) &&
                            horaController.text != '' &&
                            (dpDestino != dpOrigen ||
                                origenPersonalizado != destinoPersonalizado) &&
                            int.parse(plazasController.text) >=
                                (widget.oferta.plazasTotales - widget.oferta.plazasDisponibles))) {
                      ref.read(ofertasOfrecidasUsuarioProvider.notifier).editarOferta(
                            id: widget.oferta.id,
                            origen: origen?.localidad ?? dpOrigen,
                            destino: destino?.localidad ?? dpDestino,
                            plazas: plazasController.text,
                            hora: DateTime.tryParse(horaController.text)!.toIso8601String(),
                            titulo: tituloController.text,
                            descripcion: descripcionController.text,
                            coordOrigen: origen?.coordenadas,
                            coordDestino: destino?.coordenadas,
                            radioOrigen: origen?.radio,
                            radioDestino: destino?.radio,
                            paraEstarA: groupValue == 0,
                            esPeriodico: widget.oferta.esPeriodico,
                          );

                      Navigator.of(context).popUntil(ModalRoute.withName(TabBarScreen.kRouteName));
                    }
                  },
                  textSize: 16,
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
