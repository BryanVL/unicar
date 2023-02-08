import 'package:flutter/material.dart';
import 'package:unicar/screens/chats_screen.dart';
import 'package:unicar/screens/crear_oferta_screen.dart';
import 'package:unicar/screens/mis_viajes_screen.dart';
import 'package:unicar/screens/ofertas_screen.dart';
import 'package:unicar/screens/tab_bar_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Unicar',
      theme: ThemeData(
        useMaterial3: false,
        primarySwatch: Colors.blue,
        primaryColor: Colors.blue,
        brightness: Brightness.light,
        bottomAppBarTheme: const BottomAppBarTheme(color: Colors.blue),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      home: const TabBarScreen(title: 'Unicar'),
      routes: {
        OfertasScreen.kRouteName: (ctx) => const OfertasScreen(),
        MisViajesScreen.kRouteName: (context) => const MisViajesScreen(),
        ChatsScreen.kRouteName: (context) => const ChatsScreen(),
        CrearOferta.kRouteName: (context) => const CrearOferta(),
      },
    );
  }
}
