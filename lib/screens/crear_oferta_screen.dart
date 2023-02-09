import 'package:flutter/material.dart';
import 'package:unicar/widgets/dropdown.dart';

class CrearOferta extends StatefulWidget {
  const CrearOferta({super.key});

  static const kRouteName = "/CrearOferta";

  @override
  State<CrearOferta> createState() => _CrearOfertaState();
}

class _CrearOfertaState extends State<CrearOferta> {
  String selectedTime = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Nuevo viaje'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const customDropdown(titulo: 'Origen:'),
            const customDropdown(titulo: 'Destino:'),
            Container(
              width: 300,
              height: 200,
              color: Colors.green,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final TimeOfDay? picked_s = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );

                    if (picked_s != null) {
                      setState(() {
                        selectedTime = picked_s.minute < 10
                            ? '${picked_s.hour}:0${picked_s.minute}'
                            : '${picked_s.hour}:${picked_s.minute}';
                      });
                    }
                  },
                  child: Text('Selecciona la hora de comienzo del viaje'),
                ),
              ],
            ),
            Text('Hora seleccionada: $selectedTime'),
            const Padding(
              padding: EdgeInsets.only(
                left: 48.0,
                right: 48,
                top: 32,
                bottom: 8,
              ),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Plazas disponibles del viaje',
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(
                left: 48.0,
                right: 48,
                top: 8,
                bottom: 32,
              ),
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Añade una descripción al viaje',
                    hintText: 'Escribe algo para que sea más fácil reconocerte'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 32.0),
              child: ElevatedButton(
                onPressed: () {},
                child: Text('Publicar oferta'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
