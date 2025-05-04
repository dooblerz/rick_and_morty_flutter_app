import 'package:rick_and_morty_app/models/character_mode.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class CacheService {
  static const String characterKey = 'cached_characters';
  static const _favoritesKey = 'favorites';

  Future<void> saveCharacters(String json) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(characterKey, json);
  }

  Future<String?> loadCharacters() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(characterKey);
  }

  Future<void> saveFavorites(List<Character> favorites) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = favorites.map((c) => c.toJson()).toList();
    prefs.setString(_favoritesKey, jsonEncode(jsonList));
  }

  Future<List<Character>> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_favoritesKey);
    if (jsonString != null) {
      final List decoded = jsonDecode(jsonString);
      return decoded.map((json) => Character.fromJson(json)).toList();
    } else {
      return [];
    }
  }
}
