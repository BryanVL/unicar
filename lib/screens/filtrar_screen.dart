import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unicar/providers/oferta_provider.dart';
import 'package:unicar/widgets/seleccion_posicion.dart';

import '../models/localizacion.dart';
import '../providers/dropdown_provider.dart';
import '../providers/localizacion_provider.dart';
import '../widgets/buttons.dart';
import '../widgets/texto.dart';

class FiltrarScreen extends ConsumerStatefulWidget {
  const FiltrarScreen({super.key});
  static const kRouteName = "/Filtrar";
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FiltrarScreenState();
}

class _FiltrarScreenState extends ConsumerState<FiltrarScreen> {
  TextEditingController horaController = TextEditingController();
  int groupValue = 2;

  final _formKey = GlobalKey<FormState>();

  @override
  initState() {
    super.initState();
    horaController.text = ref.read(viajesProvider.notifier).filtroHora;
    groupValue = ref.read(viajesProvider.notifier).filtroGroupValue;
  }

  @override
  dispose() {
    super.dispose();
    horaController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future(() {
      final origen = ref.read(viajesProvider.notifier).filtroOrigenP;
      final destino = ref.read(viajesProvider.notifier).filtroDestinoP;
      if (origen != null) {
        ref.read(posicionPersonalizadaProvider(TipoPosicion.origen).notifier).state = origen;
      }

      if (destino != null) {
        ref.read(posicionPersonalizadaProvider(TipoPosicion.destino).notifier).state = destino;
      }

      if (origen == null && destino == null) {
        ref.read(dropdownProvider(TipoPosicion.origen).notifier).state =
            ref.read(viajesProvider.notifier).filtroOrigen;
        ref.read(dropdownProvider(TipoPosicion.destino).notifier).state =
            ref.read(viajesProvider.notifier).filtroDestino;
      }
    });

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
              const SeleccionPosicion(filtro: false),
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
                              .read(viajesProvider.notifier)
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
                          final dpOrigen = ref.read(dropdownProvider(TipoPosicion.origen));
                          final dpDestino = ref.read(dropdownProvider(TipoPosicion.destino));

                          final origen =
                              ref.read(posicionPersonalizadaProvider(TipoPosicion.origen));
                          final destino =
                              ref.read(posicionPersonalizadaProvider(TipoPosicion.destino));
                          ref.read(viajesProvider.notifier).filtrar(
                                dpOrigen,
                                dpDestino,
                                horaController.text,
                                origen,
                                destino,
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
