import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:rick_and_morty_app/providers/api_provider.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final apiProvider = Provider.of<ApiProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body:
          apiProvider.favorites.isEmpty
              ? const Center(child: Text('Нет избранных персонажей'))
              : ListView.builder(
                itemCount: apiProvider.favorites.length,
                itemBuilder: (context, index) {
                  final character = apiProvider.favorites[index];
                  return ListTile(
                    onTap: () {
                      context.push('/character', extra: character);
                    },
                    leading: Image.network(character.image!),
                    title: Text(character.name!),
                    trailing: IconButton(
                      onPressed: () {
                        apiProvider.toggleFavorite(character);
                      },
                      icon: const Icon(Icons.remove_circle, color: Colors.red),
                    ),
                  );
                },
              ),
    );
  }
}
