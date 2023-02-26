import 'package:flutter/material.dart';

import '../models/oferta.dart';

class CustomDropdown extends StatefulWidget {
  const CustomDropdown(
      {super.key, required this.titulo, required this.callback, this.valorDefecto});
  final String titulo;
  final Function(String) callback;
  final String? valorDefecto;

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  String dropdownValue = 'Selecciona uno';

  @override
  void initState() {
    dropdownValue = widget.valorDefecto ?? 'Selecciona uno';
    super.initState();
  }

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
            height: 80,
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
            right: 16,
          ),
          child: Container(
            alignment: Alignment.bottomCenter,
            height: 50,
            width: 225,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.transparent, //const Color.fromARGB(255, 29, 183, 255),
                border: Border.all(color: Colors.blue, width: 3),
                borderRadius: BorderRadius.circular(20),

                boxShadow: const [
                  BoxShadow(
                    color: Colors.transparent,
                    blurRadius: 5,
                  )
                ],
              ),
              child: DropdownButtonFormField(
                  key: widget.key,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                  iconSize: 24,
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  autofocus: true,
                  dropdownColor: const Color.fromARGB(255, 80, 171, 228),
                  isExpanded: true,
                  alignment: Alignment.center,
                  value: dropdownValue,
                  onChanged: (String? value) {
                    widget.callback(value ?? '');
                    setState(() {
                      dropdownValue = value!;
                    });
                  },
                  items: Oferta.listaUbicaciones),
            ),
          ),
        ),
      ],
    );
  }
}
