import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:unicar/models/oferta.dart';
import 'package:unicar/providers/usuario_provider.dart';

class dbSupabase {
  static final db = Supabase.instance.client;

  static Future<List<Oferta>> recogerViajesAjenos(String userId) async {
    final List consultaViajes = await db
        .from(
          'viaje',
        )
        .select(
          'id,created_at,origen,destino,latitud_origen,longitud_origen,latitud_destino,longitud_destino,hora_inicio,plazas_totales,plazas_disponibles,descripcion, creado_por, titulo',
        )
        .neq('creado_por', userId)
        .order('created_at');

    return Future.value(Oferta.fromList(consultaViajes));
  }
}
