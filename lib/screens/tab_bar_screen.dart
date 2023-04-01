import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:unicar/screens/chats_screen.dart';
import 'package:unicar/screens/mis_viajes_screen.dart';
import 'package:unicar/screens/ofertas_screen.dart';
import 'package:unicar/widgets/appbar.dart';

class TabBarScreen extends StatefulWidget {
  const TabBarScreen({Key? key, required this.title}) : super(key: key);
  static const String kRouteName = "/tabBarScreen";
  final String title;
  @override
  State<TabBarScreen> createState() => _TabBarScreenState();
}

class _TabBarScreenState extends State<TabBarScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 1);
  }

  void _comprobarPermisos() async {
    if (await Permission.location.status.isDenied) {
      await Permission.location.request();
    }
  }

  @override
  Widget build(BuildContext context) {
    _comprobarPermisos();
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[MyAppbar(tabController: _tabController)];
          },
          body: TabBarView(
            controller: _tabController,
            children: const [
              OfertasScreen(),
              MisViajesScreen(),
              ChatsScreen(),
            ],
          ),
        ),
      ),
    );
  }
}
