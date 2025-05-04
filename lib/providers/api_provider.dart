import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:rick_and_morty_app/models/character_mode.dart';
import 'package:rick_and_morty_app/models/episode_model.dart';

class ApiProvider with ChangeNotifier {
  final url = 'rickandmortyapi.com';
  List<Character> characters = [];
  List<Episode> episodes = [];

  Future<void> getCharacters(int page) async {
    try {
      final result = await http.get(
        Uri.https(url, "/api/character", {'page': page.toString()}),
      );
      if (result.statusCode == 200) {
        final response = characterResponseFromJson(result.body);
        characters.addAll(response.results!);
        notifyListeners();
      } else {
        print("Ошибка: ${result.statusCode}");
        print("Ответ: ${result.body}");
      }
    } catch (e) {
      print("Произошлла оишбка при получении данных: $e");
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
}
