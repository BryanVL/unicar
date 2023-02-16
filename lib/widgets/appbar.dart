import 'package:flutter/material.dart';

class MyAppbar extends StatelessWidget {
  const MyAppbar({super.key, required this.tabController});

  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      title: const Text('Unicar'),
      pinned: true,
      snap: false,
      floating: true,
      actions: [
        IconButton(
          onPressed: () {
            Navigator.of(context).pushNamed('/Configuracion');
          },
          icon: Icon(
            Icons.settings,
            color: IconTheme.of(context).color,
          ),
        )
      ],
      bottom: TabBar(
        automaticIndicatorColorAdjustment: true,
        enableFeedback: false,
        controller: tabController,
        tabs: const [
          Tab(child: Text('Ofertas')),
          Tab(child: Text('Mis viajes')),
          Tab(child: Text('Chats'))
        ],
      ),
    );
  }
}
