import '../models/pokemon_model.dart';
import '../services/pokemon_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PokemonRepository {
  final PokemonService pokemonService;
  static const String _favoritesKey = 'favorites';

  PokemonRepository(this.pokemonService);
  Future<List<Pokemon>> fetchPokemonListWithTypes(int limit, int offset) async {
    final response = await pokemonService.getPokemonList(
      limit: limit,
      offset: offset,
    );

    final list = Pokemon.listFromJson(response['results']);

    final updatedList = await Future.wait(
      list.map((p) async {
        final detail = await fetchPokemonDetail(p.name);
        return Pokemon(id: p.id, name: p.name, url: p.url, types: detail.types);
      }),
    );

    return updatedList;
  }

  Future<Pokemon> fetchPokemonDetail(String nameOrId) async {
    final json = await pokemonService.getPokemonDetail(nameOrId);
    return Pokemon.fromJson(json);
  }

  Future<List<String>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_favoritesKey) ?? [];
  }

  Future<void> addFavorite(String name) async {
    final prefs = await SharedPreferences.getInstance();
    final favs = prefs.getStringList(_favoritesKey) ?? [];
    if (!favs.contains(name)) {
      favs.add(name);
      await prefs.setStringList(_favoritesKey, favs);
    }
  }

  Future<void> removeFavorite(String name) async {
    final prefs = await SharedPreferences.getInstance();
    final favs = prefs.getStringList(_favoritesKey) ?? [];
    if (favs.contains(name)) {
      favs.remove(name);
      await prefs.setStringList(_favoritesKey, favs);
    }
  }
}
