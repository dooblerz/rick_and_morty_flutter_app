import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:rick_and_morty_app/providers/api_provider.dart';
import 'package:rick_and_morty_app/providers/theme_provider.dart';
import 'package:rick_and_morty_app/widgets/search_delegate.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final scrollController = ScrollController();
  bool isLoading = false;
  int page = 1;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final apiProvider = Provider.of<ApiProvider>(context, listen: false);
    apiProvider.getCharacters(page);
    apiProvider.loadFavoritesFromCache();
    scrollController.addListener(() async {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        setState(() {
          isLoading = true;
        });
        page++;
        await apiProvider.getCharacters(page);
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final apiProvider = Provider.of<ApiProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Rick and Morty',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              showSearch(context: context, delegate: SearchCharacter());
            },
            icon: Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {
              context.go('/favorites');
            },
            icon: Icon(Icons.favorite),
          ),
          IconButton(
            onPressed: () {
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
            },
            icon: Icon(Icons.brightness_6),
          ),
        ],
      ),
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child:
            apiProvider.characters.isNotEmpty
                ? CharacterList(
                  apiProvider: apiProvider,
                  isLoading: isLoading,
                  scrollController: scrollController,
                )
                : Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class CharacterList extends StatelessWidget {
  const CharacterList({
    super.key,
    required this.apiProvider,
    required this.scrollController,
    required this.isLoading,
  });

  final ApiProvider apiProvider;
  final ScrollController scrollController;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.87,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      itemCount:
          isLoading
              ? apiProvider.characters.length + 2
              : apiProvider.characters.length,
      controller: scrollController,
      itemBuilder: (context, index) {
        if (index < apiProvider.characters.length) {
          final character = apiProvider.characters[index];
          return GestureDetector(
            onTap: () {
              context.go('/character', extra: character);
            },
            child: Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Hero(
                      tag: character.id!,
                      child: FadeInImage(
                        placeholder: const AssetImage(
                          'assets/images/portal.gif',
                        ),
                        image: NetworkImage(character.image!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                    child: IconButton(
                      onPressed: () => apiProvider.toggleFavorite(character),
                      icon: Icon(
                        apiProvider.isFavorite(character)
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: Colors.red,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4.0,
                      vertical: 5.0,
                    ),
                    child: Text(
                      character.name!,
                      style: TextStyle(
                        fontSize: 16,
                        overflow: TextOverflow.ellipsis,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
