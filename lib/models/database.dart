import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:unicar/models/oferta.dart';

class dbSupabase {
  static final db = Supabase.instance.client;
  static Future<List<Oferta>> recogerViajesAjenos() async {
    final List consultaViajes = await db
        .from(
          'Viaje',
        )
        .select(
          'id,created_at,Origen,Destino,latitud_origen,longitud_origen,latitud_destino,longitud_destino,hora_inicio,plazas_totales,plazas_disponibles,descripcion, creado_por, titulo, usuarios_apuntados',
        )
        .neq('creado_por', '1')
        .order('created_at');

    return Future.value(Oferta.fromList(consultaViajes));
  }
}
