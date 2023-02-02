import 'package:flutter/material.dart';

class OfertasScreen extends StatelessWidget {
  const OfertasScreen({super.key});

  static const kRouteName = "/Ofertas";

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: null,
        label: Text('Nueva oferta'),
        icon: Icon(Icons.add),
      ),
    );
  }
}
