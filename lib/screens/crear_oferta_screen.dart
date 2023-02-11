import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:unicar/widgets/buttons.dart';
import 'package:unicar/models/oferta.dart';

class CrearOferta extends StatefulWidget {
  const CrearOferta({super.key});

  static const kRouteName = "/CrearOferta";

  @override
  State<CrearOferta> createState() => _CrearOfertaState();
}

class _CrearOfertaState extends State<CrearOferta> {
  String selectedTime = '';
  TimeOfDay valorHora = TimeOfDay.now();
  String dropdownValueOrigen = 'Selecciona uno';
  String dropdownValueDestino = 'Selecciona uno';
  TextEditingController plazasController = TextEditingController();
  TextEditingController descripcionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final listaUbicaciones = Oferta.ubicaciones
      .map(
        (ubicacion) => DropdownMenuItem(
          alignment: Alignment.center,
          value: ubicacion,
          child: Text(
            ubicacion,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      )
      .toList();

  @override
  void dispose() {
    super.dispose();
    plazasController.dispose();
    descripcionController.dispose();
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Container(
                      alignment: Alignment.center,
                      width: 80,
                      height: 90,
                      child: const Text(
                        'Origen:',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 16,
                      right: 32,
                    ),
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      width: 215,
                      child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 29, 183, 255),
                            border: Border.all(color: Colors.black38, width: 1),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black,
                                blurRadius: 5,
                              )
                            ],
                          ),
                          child: DropdownButtonFormField(
                            validator: (value) {
                              if (dropdownValueOrigen == 'Selecciona uno') {
                                return 'Debes seleccionar un origen';
                              }
                              if (dropdownValueDestino == dropdownValueOrigen) {
                                return 'Origen y destino no pueden ser iguales';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                            ),
                            iconSize: 48,
                            borderRadius: const BorderRadius.all(Radius.circular(20)),
                            autofocus: true,
                            dropdownColor: const Color.fromARGB(255, 167, 209, 236),
                            isExpanded: true,
                            alignment: Alignment.center,
                            value: dropdownValueOrigen,
                            onChanged: (String? value) {
                              setState(() {
                                dropdownValueOrigen = value!;
                              });
                            },
                            items: listaUbicaciones,
                          )),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Container(
                      alignment: Alignment.center,
                      width: 80,
                      height: 90,
                      child: const Text(
                        'Destino:',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 16,
                      right: 32,
                    ),
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      width: 215,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 29, 183, 255),
                          border: Border.all(color: Colors.black38, width: 1),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black,
                              blurRadius: 5,
                            )
                          ],
                        ),
                        child: DropdownButtonFormField(
                            validator: (value) {
                              if (dropdownValueDestino == 'Selecciona uno') {
                                return 'Debes seleccionar un destino';
                              }
                              if (dropdownValueDestino == dropdownValueOrigen) {
                                return 'Origen y destino no pueden ser iguales';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                            ),
                            iconSize: 48,
                            borderRadius: const BorderRadius.all(Radius.circular(20)),
                            autofocus: true,
                            dropdownColor: const Color.fromARGB(255, 167, 209, 236),
                            isExpanded: true,
                            alignment: Alignment.center,
                            value: dropdownValueDestino,
                            onChanged: (String? value) {
                              setState(() {
                                dropdownValueDestino = value!;
                              });
                            },
                            items: listaUbicaciones),
                      ),
                    ),
                  ),
                ],
              ),
              /* const customDropdown(titulo: 'Origen:'),
                const customDropdown(titulo: 'Destino:'),*/
              Container(
                width: 300,
                height: 200,
                color: Colors.green,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  boton(
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
                  bottom: 32,
                ),
                child: TextFormField(
                  controller: descripcionController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      )),
                      labelText: 'Añade una descripción al viaje',
                      hintText: 'Escribe algo para que sea más fácil reconocerte'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 32.0),
                child: boton(
                  funcion: () async {
                    if (_formKey.currentState!.validate() &&
                        (dropdownValueOrigen != 'Selecciona uno' &&
                            dropdownValueDestino != 'Selecciona uno' &&
                            selectedTime != '')) {
                      Oferta.nuevoViaje(dropdownValueOrigen, dropdownValueDestino, selectedTime,
                              plazasController.text, descripcionController.text, 1)
                          .then((value) => Navigator.of(context).pop());
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
