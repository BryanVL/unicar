import 'package:flutter/material.dart';

import '../models/oferta.dart';

class customDropdown extends StatefulWidget {
  const customDropdown({super.key, required this.titulo});
  final String titulo;

  @override
  State<customDropdown> createState() => _customDropdownState();
}

class _customDropdownState extends State<customDropdown> {
  String dropdownValue = 'Selecciona uno';

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
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Container(
            alignment: Alignment.center,
            width: 80,
            height: 90,
            child: Text(
              widget.titulo,
              style: const TextStyle(
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
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                  iconSize: 48,
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  autofocus: true,
                  dropdownColor: const Color.fromARGB(255, 167, 209, 236),
                  isExpanded: true,
                  alignment: Alignment.center,
                  value: dropdownValue,
                  onChanged: (String? value) {
                    setState(() {
                      dropdownValue = value!;
                    });
                  },
                  items: listaUbicaciones),
            ),
          ),
        ),
      ],
    );
  }
}
