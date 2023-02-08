import 'package:flutter/material.dart';

class customDropdown extends StatefulWidget {
  const customDropdown({super.key, required this.titulo});
  final String titulo;

  @override
  State<customDropdown> createState() => _customDropdownState();
}

class _customDropdownState extends State<customDropdown> {
  String dropdownValue = 'Torremolinos';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          widget.titulo,
          style: const TextStyle(
            fontSize: 36,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 8.0,
            bottom: 32,
            left: 64,
            right: 64,
          ),
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
            child: DropdownButton(
              iconSize: 48,
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              autofocus: true,
              dropdownColor: const Color.fromARGB(255, 167, 209, 236),
              underline: Container(),
              isExpanded: true,
              alignment: Alignment.center,
              value: dropdownValue,
              onChanged: (String? value) {
                setState(() {
                  dropdownValue = value!;
                });
              },
              items: const [
                DropdownMenuItem(
                  alignment: Alignment.center,
                  value: 'Torremolinos',
                  child: Text('Torremolinos'),
                ),
                DropdownMenuItem(
                  alignment: Alignment.center,
                  value: 'Teatinos',
                  child: Text('Teatinos'),
                ),
                DropdownMenuItem(
                  alignment: Alignment.center,
                  value: 'Fuengirola',
                  child: Text('Fuengirola'),
                ),
                DropdownMenuItem(
                  alignment: Alignment.center,
                  value: 'Ampliación de Teatinos',
                  child: Text('Ampliación de Teatinos'),
                ),
                DropdownMenuItem(
                  alignment: Alignment.center,
                  value: 'Benalmadena',
                  child: Text('Benalmadena'),
                ),
                DropdownMenuItem(
                  alignment: Alignment.center,
                  value: 'Alhaurin de la torre',
                  child: Text('Alharurin de la torre'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
