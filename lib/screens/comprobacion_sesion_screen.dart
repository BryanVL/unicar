import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unicar/providers/database_provider.dart';

class ComprobacionSesionScreen extends ConsumerWidget {
  const ComprobacionSesionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(databaseProvider.notifier).comprobarSesion(context);
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
