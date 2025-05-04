import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:rick_and_morty_app/models/character_mode.dart';
import 'package:rick_and_morty_app/models/episode_model.dart';
import 'package:rick_and_morty_app/services/cache_service.dart';

class ApiProvider with ChangeNotifier {
  final url = 'rickandmortyapi.com';
  final cache = CacheService();
  List<Character> characters = [];
  List<Episode> episodes = [];
  List<Character> favorites = [];

  Future<void> getCharacters(int page) async {
    try {
      final result = await http.get(
        Uri.https(url, "/api/character", {'page': page.toString()}),
      );
      if (result.statusCode == 200) {
        final response = characterResponseFromJson(result.body);
        characters.addAll(response.results!);

        await cache.saveCharacters(result.body);

        notifyListeners();
      } else {
        print("Ошибка: ${result.statusCode}");
        print("Ответ: ${result.body}");
      }
    } catch (e) {
      print("Произошлла оишбка при получении данных: $e");
      final cachedJson = await cache.loadCharacters();
      if (cachedJson != null) {
        final cachedResponse = characterResponseFromJson(cachedJson);
        characters = cachedResponse.results!;
        notifyListeners();
      }
    }
  }

  Future<List<Character>> getCharacter(String name) async {
    final result = await http.get(
      Uri.https(url, '/api/character/', {'name': name}),
    );
    final response = characterResponseFromJson(result.body);
    return response.results!;
  }

  Future<List<Episode>> getEpisodes(Character character) async {
    episodes = [];
    for (var i = 0; i < character.episode!.length; i++) {
      final result = await http.get(Uri.parse(character.episode![i]));
      final response = episodeFromJson(result.body);
      episodes.add(response);
      notifyListeners();
    }
    return episodes;
  }

  Future<void> loadFavoritesFromCache() async {
    favorites = await cache.loadFavorites();
    notifyListeners();
  }

  void toggleFavorite(Character character) {
    if (isFavorite(character)) {
      favorites.removeWhere((c) => c.id == character.id);
    } else {
      favorites.add(character);
    }
    cache.saveFavorites(favorites);
    notifyListeners();
  }

  bool isFavorite(Character character) {
    return favorites.any((c) => c.id == character.id);
  }
}
