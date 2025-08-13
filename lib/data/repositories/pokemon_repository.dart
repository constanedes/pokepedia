import 'package:pokepedia/data/models/pokemon_list_model.dart';
import 'package:pokepedia/data/models/pokemon_detail_model.dart';

import '../models/pokemon_model.dart';
import '../models/pokemon_model.dart2';
import '../services/pokemon_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PokemonRepository {
  final PokemonService pokemonService;
  static const String _favoritesKey = 'favorites';

  PokemonRepository(this.pokemonService);

  Future<List<PokemonListItem>> fetchPokemonListWithTypes(
    int limit,
    int offset,
  ) async {
    final response = await pokemonService.getPokemonList(
      limit: limit,
      offset: offset,
    );

    final listResponse = PokemonListResponse.fromJson(response);
    List<PokemonListItem> pokemons = listResponse.results;

    for (int i = 0; i < pokemons.length; i++) {
      final detail = await fetchPokemonDetail(pokemons[i].name);
      pokemons[i] = PokemonListItem(
        id: pokemons[i].id,
        name: pokemons[i].name,
        url: pokemons[i].url,
      );
    }

    return pokemons;
  }

  Future<PokemonDetail> fetchPokemonDetail(String nameOrId) async {
    final json = await pokemonService.getPokemonDetail(nameOrId);
    return PokemonDetail.fromJson(json);
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
