import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../providers/localizacion_provider.dart';

class Mapa extends ConsumerWidget {
  const Mapa(this.localizacionOrigen, this.localizacionDestino, this.radioOrigen, this.radioDestino,
      {super.key});
  final LatLng localizacionOrigen;
  final LatLng localizacionDestino;
  final int radioOrigen;
  final int radioDestino;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posicionActual = ref.watch(localizacionActualUsuarioProvider);
    return FlutterMap(
      options: MapOptions(
        center: localizacionOrigen,
        zoom: 11,
        maxZoom: 16.5,
        minZoom: 11,
        onTap: (tapPosition, point) {},
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
              point: localizacionOrigen,
              radius: radioOrigen.toDouble(),
              color: const Color.fromARGB(78, 56, 88, 231),
              borderColor: Colors.blue,
              borderStrokeWidth: 1,
              useRadiusInMeter: true,
            ),
            CircleMarker(
              point: localizacionDestino,
              radius: radioDestino.toDouble(),
              color: const Color.fromARGB(78, 56, 88, 231),
              borderColor: Colors.blue,
              borderStrokeWidth: 1,
              useRadiusInMeter: true,
            ),
          ],
        ),
        MarkerLayer(
          rotate: true,
          markers: [
            Marker(
              point: localizacionOrigen,
              builder: (context) => const SizedBox(
                height: 50,
                width: 50,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Icon(
                    Icons.location_on,
                    color: Color.fromARGB(255, 224, 10, 10),
                  ),
                ),
              ),
            ),
            Marker(
              point: localizacionDestino,
              builder: (context) => const SizedBox(
                height: 50,
                width: 50,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Icon(
                    Icons.location_on,
                    color: Color.fromARGB(255, 224, 10, 10),
                  ),
                ),
              ),
            ),
            posicionActual.when(
              data: (data) {
                return Marker(
                  point: data != null ? LatLng(data.latitude, data.longitude) : localizacionOrigen,
                  builder: (context) => const Icon(
                    Icons.person,
                    color: Colors.blue,
                  ),
                );
              },
              error: (error, stackTrace) {
                return Marker(
                  point: localizacionOrigen,
                  builder: (context) => const Icon(
                    Icons.person,
                    color: Colors.blue,
                  ),
                );
              },
              loading: () {
                return Marker(
                  point: localizacionOrigen,
                  builder: (context) => const SizedBox(
                    height: 10,
                    width: 10,
                  ),
                );
              },
            )
          ],
        ),
        PolylineLayer(
          polylines: [
            Polyline(
              color: Colors.red,
              strokeWidth: 2,
              points: [localizacionOrigen, localizacionDestino],
            )
          ],
        )
      ],
    );
  }
}
