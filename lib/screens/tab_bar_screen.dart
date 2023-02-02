import 'package:flutter/material.dart';
import 'package:unicar/screens/chats_screen.dart';
import 'package:unicar/screens/mis_viajes_screen.dart';
import 'package:unicar/screens/ofertas_screen.dart';

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

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: NestedScrollView(
          body: TabBarView(
            controller: _tabController,
            children: const [
              OfertasScreen(),
              MisViajesScreen(),
              ChatsScreen(),
            ],
          ),
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                bottom: TabBar(
                  enableFeedback: false,
                  controller: _tabController,
                  tabs: const [
                    Tab(child: Text('Ofertas')),
                    Tab(child: Text('Mis viajes')),
                    Tab(child: Text('Chats'))
                  ],
                ),
                actions: [
                  IconButton(
                    onPressed: null,
                    icon: Icon(
                      Icons.settings,
                      color: IconTheme.of(context).color,
                    ),
                  )
                ],
                pinned: true,
                snap: false,
                floating: true,
                title: const Text('Unicar'),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(20),
                  ),
                ),
              ),
            ];
          },
        ),
      ),
    );

    /*appBar: AppBar(
          title: Text(widget.title),
          actions: [
            IconButton(
              onPressed: null,
              icon: Icon(
                Icons.settings,
                color: IconTheme.of(context).color,
              ),
            )
          ],
          bottom: TabBar(
            enableFeedback: false,
            controller: _tabController,
            tabs: const [
              Tab(child: Text('Ofertas')),
              Tab(child: Text('Mis viajes')),
              Tab(child: Text('Chats'))
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: const [
            OfertasScreen(),
            MisViajesScreen(),
            ChatsScreen(),
          ],
        ),*/
  }
}
