import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unicar/providers/database_provider.dart';

class ComprobacionSesionScreen extends ConsumerStatefulWidget {
  const ComprobacionSesionScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ComprobacionSesionScreenState();
}

class _ComprobacionSesionScreenState extends ConsumerState<ComprobacionSesionScreen> {
  @override
  Widget build(BuildContext context) {
    ref.read(databaseProvider.notifier).comprobarSesion(context);
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
