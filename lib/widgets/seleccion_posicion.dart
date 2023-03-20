import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:unicar/models/localizacion.dart';
import 'package:unicar/providers/localizacion_provider.dart';
import 'package:unicar/widgets/texto.dart';

import '../providers/dropdown_provider.dart';
import '../screens/mapa_screen.dart';
import 'buttons.dart';
import 'dropdown.dart';

class SeleccionPosicion extends ConsumerStatefulWidget {
  const SeleccionPosicion({this.indice, super.key});

  final int? indice;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SeleccionPosicionState();
}

class _SeleccionPosicionState extends ConsumerState<SeleccionPosicion> {
  int indiceSeleccionado = 0;
  Widget? pos;

  @override
  void initState() {
    indiceSeleccionado = widget.indice ?? 0;
    if (ref.read(posicionPersonalizadaProvider(TipoPosicion.origen)) != null) {
      indiceSeleccionado = 1;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final origen = ref.watch(posicionPersonalizadaProvider(TipoPosicion.origen));
    final destino = ref.watch(posicionPersonalizadaProvider(TipoPosicion.destino));

    Widget simple = Column(
      children: const [
        SizedBox(height: 8),
        CustomDropdown(titulo: 'Origen:', tipo: TipoPosicion.origen),
        CustomDropdown(titulo: 'Destino:', tipo: TipoPosicion.destino),
      ],
    );

    Widget pers = Column(
      children: [
        BotonMaterial(
          contenido: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Selecciona un origen personalizado',
                style: TextStyle(fontSize: 16),
              ),
              Icon(
                Icons.open_in_new,
                size: 24,
              ),
            ],
          ),
          funcion: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const MapaScreen(TipoPosicion.origen)),
            );
          },
        ),
        BotonMaterial(
          contenido: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Selecciona un destino personalizado',
                style: TextStyle(fontSize: 16),
              ),
              Icon(
                Icons.open_in_new,
                size: 24,
              ),
            ],
          ),
          funcion: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const MapaScreen(TipoPosicion.destino)),
            );
          },
        ),
        const SizedBox(height: 8),
        TextoTitulo(
          texto: 'Origen seleccionado',
          padding: const EdgeInsets.only(top: 8, left: 24, right: 24, bottom: 8),
          sizeTexto: 20,
          colorTexto: Colors.grey[400],
        ),
        Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 32.0),
              child: Text(origen != null
                  ? '${origen.nombreCompleto}, Radio: ${origen.radio} metros'
                  : 'Ningún origen seleccionado'),
            )),
        TextoTitulo(
          texto: 'Destino seleccionado',
          padding: const EdgeInsets.only(top: 12, left: 24, right: 24, bottom: 4),
          sizeTexto: 20,
          colorTexto: Colors.grey[400],
        ),
        Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 32.0),
              child: Text(destino != null
                  ? '${destino.nombreCompleto}, Radio: ${destino.radio} metros'
                  : 'Ningún destino seleccionado'),
            )),
      ],
    );
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: ToggleSwitch(
            initialLabelIndex: indiceSeleccionado,
            totalSwitches: 2,
            minWidth: 175,
            minHeight: 35,
            borderWidth: 2,
            labels: const ['Simple', 'Personalizado'],
            inactiveBgColor: Colors.white,
            borderColor: const [Colors.blue],
            customTextStyles: const [TextStyle(fontSize: 18)],
            animate: true,
            animationDuration: 200,
            curve: Curves.linear,
            onToggle: (index) {
              if (index == 0) {
                indiceSeleccionado = 0;
                pos = simple;
              } else {
                indiceSeleccionado = 1;
                pos = pers;
              }
              ref.read(dropdownProvider(TipoPosicion.origen).notifier).state = 'Selecciona uno';
              ref.read(dropdownProvider(TipoPosicion.destino).notifier).state = 'Selecciona uno';
              ref.read(posicionPersonalizadaProvider(TipoPosicion.origen).notifier).state = null;
              ref.read(posicionPersonalizadaProvider(TipoPosicion.destino).notifier).state = null;
              setState(() {});
            },
          ),
        ),
        AnimatedCrossFade(
          firstChild: simple,
          secondChild: pers,
          crossFadeState:
              indiceSeleccionado == 0 ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          duration: const Duration(milliseconds: 200),
          layoutBuilder: (topChild, topKey, bottomChild, bottomKey) {
            return Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  key: bottomChild.key,
                  top: 0,
                  child: bottomChild,
                ),
                Positioned(
                  key: topChild.key,
                  child: topChild,
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
