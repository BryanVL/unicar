import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unicar/models/localizacion.dart';

import '../models/oferta.dart';
import '../providers/dropdown_provider.dart';
import '../providers/tema_provider.dart';

class CustomDropdown extends ConsumerWidget {
  const CustomDropdown({super.key, required this.titulo, required this.tipo});
  final String titulo;
  final TipoPosicion tipo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final valor = ref.watch(dropdownProvider(tipo));
    final tema = ref.watch(temaProvider).when(
          data: (data) => data == 'claro' ? true : false,
          error: (error, stackTrace) => true,
          loading: () => true,
        );
    final listaUbicaciones = Oferta.ubicaciones
        .map(
          (ubicacion) => DropdownMenuItem(
            alignment: Alignment.center,
            value: ubicacion,
            child: Text(
              ubicacion,
              style: TextStyle(color: tema ? Colors.black : Colors.white),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        )
        .toList();

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
              titulo,
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
                key: key,
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
                dropdownColor: tema ? Colors.white : const Color.fromARGB(255, 29, 27, 27),
                isExpanded: true,
                alignment: Alignment.center,
                value: valor,
                onChanged: (String? value) {
                  ref.read(dropdownProvider(tipo).notifier).state = value!;
                },
                items: listaUbicaciones,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
