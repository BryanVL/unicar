import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:unicar/models/localizacion.dart';
import 'package:unicar/widgets/buttons.dart';

import '../providers/localizacion_provider.dart';

class MapaScreen extends ConsumerStatefulWidget {
  const MapaScreen(this.tipo, {super.key});
  final TipoPosicion tipo;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MapaScreenState();
}

class _MapaScreenState extends ConsumerState<MapaScreen> {
  TextEditingController buscador = TextEditingController();
  double radio = 0.1;
  LatLng? posicionElegida;
  String lugarElegido = '';
  String localidad = '';
  List<Marker> posicionesMarcadores = [];
  List<CircleMarker> posCirculos = [];
  MapController controladorMapa = MapController();

  void _ponerMarcadorEnMapa(LatLng posicionPulsada) {
    if (posicionesMarcadores.isNotEmpty) {
      posicionesMarcadores = [];
    }

    final marcador = Marker(
      width: 50,
      rotate: true,
      point: posicionPulsada,
      builder: (context) => const Icon(
        Icons.location_on,
        size: 30,
        color: Color.fromARGB(255, 224, 10, 10),
      ),
    );

    posicionElegida = posicionPulsada;

    posicionesMarcadores.add(marcador);
  }

  void _ponerCirculoEnMapa(LatLng pos, double radio) {
    if (posCirculos.isNotEmpty) {
      posCirculos = [];
    }

    CircleMarker cr = CircleMarker(
      point: pos,
      radius: radio * 1000,
      color: const Color.fromARGB(78, 56, 88, 231),
      borderColor: Colors.blue,
      borderStrokeWidth: 1,
      useRadiusInMeter: true,
    );

    posicionElegida = pos;

    posCirculos.add(cr);
  }

  void _moverMapa(LatLng pos) {
    controladorMapa.move(pos, 16);
  }

  @override
  Widget build(BuildContext context) {
    final posicionActual = ref.watch(localizacionActualUsuarioProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          'Elige una localización y radio',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          color: Colors.black,
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: posicionActual.when(
        data: (data) {
          final posicionInicial = data != null
              ? LatLng(data.latitude, data.longitude)
              : LatLng(36.72016000, -4.42034000);

          return Stack(
            children: [
              FlutterMap(
                mapController: controladorMapa,
                options: MapOptions(
                  center: posicionElegida ?? posicionInicial,
                  zoom: 16,
                  maxZoom: 18,
                  minZoom: 13,
                  onTap: (tapPosition, point) async {
                    final lg = await ref.read(geolocationProvider).lugarDesdeCordenadas(point);

                    setState(() {
                      lugarElegido = lg != null ? '${lg['calle']}, ${lg['localidad']}' : '';
                      localidad = lg != null ? lg['localidad']! : '';
                      _ponerMarcadorEnMapa(point);
                      _ponerCirculoEnMapa(point, radio);
                    });
                  },
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
                  CircleLayer(circles: posCirculos),
                  MarkerLayer(markers: posicionesMarcadores),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SafeArea(
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
                          child: Text('Lugar seleccionado: $lugarElegido'),
                        ),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Radio: ${(radio * 1000).toStringAsFixed(0)}m',
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Slider(
                              value: radio,
                              /*onChangeEnd: (value) {
                                setState(() {
                                  radio = value;
                                });
                              },*/
                              onChanged: posicionElegida != null
                                  ? (value) {
                                      setState(() {
                                        radio = value;
                                        _ponerCirculoEnMapa(posicionElegida!, radio);
                                      });
                                    }
                                  : null,
                              max: 1,
                              min: 0.1,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        child: Row(
                          children: [
                            Flexible(
                              child: Card(
                                child: TextField(
                                  controller: buscador,
                                  decoration: const InputDecoration(
                                    hintText: 'Busca un lugar',
                                    contentPadding: EdgeInsets.symmetric(horizontal: 8),
                                  ),
                                ),
                              ),
                            ),
                            Card(
                              child: IconButton(
                                onPressed: () async {
                                  if (buscador.text.length > 3) {
                                    final LatLng? lugar = await ref
                                        .read(geolocationProvider)
                                        .coordenadasDesdeLugar(buscador.text);

                                    if (lugar != null) {
                                      Map<String, String>? lg = await ref
                                          .read(geolocationProvider)
                                          .lugarDesdeCordenadas(lugar);
                                      setState(() {
                                        lugarElegido =
                                            lg != null ? '${lg['calle']}, ${lg['localidad']}' : '';
                                        localidad = lg != null ? lg['localidad']! : '';
                                        _ponerMarcadorEnMapa(lugar);
                                        _ponerCirculoEnMapa(lugar, radio);
                                        _moverMapa(lugar);

                                        buscador.text = '';
                                      });
                                    }
                                  }
                                },
                                icon: const Icon(Icons.search),
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 32.0),
                        child: Boton(
                            funcion: () {
                              if (localidad != '' &&
                                  lugarElegido != '' &&
                                  posicionElegida != null) {
                                ref
                                    .read(posicionPersonalizadaProvider(widget.tipo).notifier)
                                    .state = LocalizacionPersonalizada(
                                  nombreCompleto: lugarElegido,
                                  coordenadas: posicionElegida!,
                                  radio: int.parse((radio * 1000).toStringAsFixed(0)),
                                  localidad: localidad,
                                );
                                Navigator.of(context).pop();
                              }
                            },
                            textoBoton: 'Seleccionar posicion'),
                      )
                    ],
                  ),
                ],
              ),
            ],
          );
        },
        error: (error, stackTrace) {
          return Text('Error al cargar el mapa, Codigo: $error');
        },
        loading: () {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
