import 'package:flutter/material.dart';

class OfertasScreen extends StatelessWidget {
  const OfertasScreen({super.key});

  static const kRouteName = "/Ofertas";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
