import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:unicar/models/oferta.dart';

class OfertasScreen extends StatelessWidget {
  const OfertasScreen({super.key});

  static const kRouteName = "/Ofertas";

  @override
  Widget build(BuildContext context) {
    Future<Oferta?> recogerDatos() async {
      final supabase = Supabase.instance.client;
      final data = await supabase.from('Viaje').select(
            'id,created_at,Origen,Destino,latitud_origen,longitud_origen,latitud_destino,longitud_destino,hora_inicio,plazas_totales,plazas_ocupadas,descripcion, creado_por',
          );
      print('El valor es ${data}');
    }

    return Scaffold(
      body: ElevatedButton(
        onPressed: () {
          recogerDatos();
        },
        child: Text(
          'Pulsa para probar base de datos',
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).pushNamed('/CrearOferta');
        },
        label: Text('Publicar oferta'),
        icon: Icon(Icons.add),
      ),
    );
  }
}
