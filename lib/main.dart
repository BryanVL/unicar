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
          primarySwatch: Colors.blue,
          primaryColor: Colors.blue,
          brightness: Brightness.light,
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
          appBarTheme: const AppBarTheme(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(25),
              ),
            ),
            foregroundColor: Colors.black,
            backgroundColor: Colors.blue,
          ),
          tabBarTheme: TabBarTheme(
            unselectedLabelColor: Colors.black,
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(25.0),
              color: Colors.lightBlue,
            ),
          ),
          buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary)),
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
