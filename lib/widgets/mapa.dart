import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

class Mapa extends ConsumerStatefulWidget {
  const Mapa(this.localizacionInicial, {super.key});
  final LatLng localizacionInicial;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MapaState();
}

class _MapaState extends ConsumerState<Mapa> {
  Marker? posicioninicio;
  Marker? posicionDestino;
  List<Marker> posiciones = [];

  void anadirPosicion() {}

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        center: widget.localizacionInicial,
        zoom: 16,
        maxZoom: 18,
        minZoom: 13,
        onTap: (tapPosition, point) {},
        //maxBounds: LatLngBounds(LatLng(43.874071, -9.629332), LatLng(35.791012, 3.817933)),
      ),
      nonRotatedChildren: [
        AttributionWidget.defaultWidget(
          source: 'OpenStreetMap contributors',
          onSourceTapped: null,
        ),
      ],
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.unicar',
        ),
        CircleLayer(
          circles: [
            CircleMarker(
              point: widget.localizacionInicial,
              radius: 100,
              color: const Color.fromARGB(78, 56, 88, 231),
              borderColor: Colors.blue,
              borderStrokeWidth: 1,
              useRadiusInMeter: true,
            )
          ],
        ),
        MarkerLayer(
            markers:
                posiciones /*[
            
            Marker(
              point: widget.localizacionInicial,
              builder: (context) => const Icon(
                Icons.location_on,
                color: Color.fromARGB(255, 224, 10, 10),
              ),
            )
          ],*/
            )
      ],
    );
  }
}
