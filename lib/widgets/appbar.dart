import 'package:flutter/material.dart';

class MyAppbar extends StatelessWidget {
  const MyAppbar({super.key, required this.tabController});

  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
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
      actions: [
        IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.settings,
          ),
        )
      ],
      pinned: true,
      snap: false,
      floating: true,
      title: const Text('Unicar'),
    );
  }
}
