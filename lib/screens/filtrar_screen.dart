import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/buttons.dart';
import '../widgets/dropdown.dart';

class FiltrarScreen extends ConsumerStatefulWidget {
  const FiltrarScreen({super.key});
  static const kRouteName = "/Filtrar";
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FiltrarScreenState();
}

class _FiltrarScreenState extends ConsumerState<FiltrarScreen> {
  String selectedTime = '';
  TimeOfDay valorHora = TimeOfDay.now();
  String dropdownValueOrigen = 'Selecciona uno';
  String dropdownValueDestino = 'Selecciona uno';

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
              customDropdown(titulo: 'Origen:', callback: callbackOrigen),
              customDropdown(titulo: 'Destino:', callback: callbackDestino),
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
                  boton(
                      paddingLeft: 8,
                      paddingRight: 8,
                      funcion: () async {
                        final TimeOfDay? picked_s = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );

                        if (picked_s != null) {
                          setState(() {
                            valorHora = picked_s;
                            selectedTime = picked_s.minute < 10
                                ? '${picked_s.hour}:0${picked_s.minute}'
                                : '${picked_s.hour}:${picked_s.minute}';
                          });
                        }
                      },
                      textoBoton: 'Selecciona la hora de comienzo del viaje'),
                ],
              ),

              Text('Hora seleccionada: $selectedTime'),

              Padding(
                padding: const EdgeInsets.only(bottom: 32.0, top: 64),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: boton(
                        paddingTodo: 8,
                        funcion: () async {
                          //TODO Hacer funcion de filtro
                          //Oferta.nuevoViaje().then((value) => Navigator.of(context).pop());
                        },
                        textoBoton: 'Aplicar filtros',
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: boton(
                        colorBoton: Colors.red,
                        paddingTodo: 8,
                        funcion: () async {
                          //TODO Hacer funcion de eliminar filtro
                          //Oferta.nuevoViaje().then((value) => Navigator.of(context).pop());
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
