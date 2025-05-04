import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:rick_and_morty_app/models/character_mode.dart';
import 'package:rick_and_morty_app/providers/api_provider.dart';
import 'package:rick_and_morty_app/sreens/character_screen.dart';
import 'package:rick_and_morty_app/sreens/favorite_screen.dart';
import 'package:rick_and_morty_app/sreens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

final GoRouter _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) {
        return HomeScreen();
      },
      routes: [
        GoRoute(
          path: 'character',
          builder: (context, state) {
            final character = state.extra as Character;
            return CharacterScreen(character: character);
          },
        ),
        GoRoute(
          path: 'favorites',
          builder: (context, state) => const FavoriteScreen(),
        ),
      ],
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ApiProvider(),
      child: MaterialApp.router(
        title: 'Rick and Morty App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(brightness: Brightness.dark, useMaterial3: true),
        routerConfig: _router,
      ),
    );
  }
}
