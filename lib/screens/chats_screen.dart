import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unicar/providers/chat_provider.dart';

import '../widgets/tarjeta_chat.dart';

class ChatsScreen extends ConsumerWidget {
  const ChatsScreen({super.key});

  static const kRouteName = "/Chats";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chats = ref.watch(chatProvider);
    return Scaffold(
      body: chats.when(
        data: (data) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: NotificationListener<OverscrollIndicatorNotification>(
                  onNotification: (OverscrollIndicatorNotification overscroll) {
                    overscroll.disallowIndicator();
                    return true;
                  },
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return TarjetaChat(
                        chat: data[index],
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
        loading: () {
          return const Center(child: CircularProgressIndicator());
        },
        error: (error, stackTrace) {
          return Text(
              'Hubo un error al cargar los viajes, intentalo de nuevo. Codigo error: $error');
        },
      ),
    );
  }
}
