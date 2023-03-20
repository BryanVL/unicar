import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unicar/models/localizacion.dart';

import '../models/oferta.dart';
import '../providers/dropdown_provider.dart';

class CustomDropdown extends ConsumerStatefulWidget {
  const CustomDropdown({super.key, required this.titulo, required this.tipo, this.valorDefecto});
  final String titulo;
  final TipoPosicion tipo;
  final String? valorDefecto;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends ConsumerState<CustomDropdown> {
  String dropdownValue = 'Selecciona uno';

  @override
  void initState() {
    dropdownValue = widget.valorDefecto ?? 'Selecciona uno';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final valor = ref.watch(dropdownProvider(widget.tipo));

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
                color: Colors.transparent,
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
                dropdownColor: Colors.white,
                isExpanded: true,
                alignment: Alignment.center,
                value: valor,
                onChanged: (String? value) {
                  ref.read(dropdownProvider(widget.tipo).notifier).state = value!;
                },
                items: Oferta.listaUbicaciones,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
