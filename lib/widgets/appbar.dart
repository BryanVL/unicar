import 'package:flutter/material.dart';

class MyAppbar extends StatelessWidget {
  const MyAppbar({super.key, required this.tabController});

  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      surfaceTintColor: Colors.black,
      shadowColor: Colors.black,
      bottom: TabBar(
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(
            25.0,
          ),
          color: Colors.lightBlue,
        ),
        //indicatorColor: Colors.deepPurpleAccent,
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
    );
  }
}
