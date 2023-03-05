import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unicar/models/database/database_interface.dart';
import '../models/database/supabase_db_implementer.dart';

final databaseProvider = Provider<Database>((ref) {
  return SupabaseDB();
});
