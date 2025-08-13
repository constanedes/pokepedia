// lib/data/services/pokemon_service.dart
import '../../core/services/http_service.dart';

class PokemonService {
  final HttpService httpService;
  static const String baseUrl = "https://pokeapi.co/api/v2";

  PokemonService(this.httpService);

  Future<Map<String, dynamic>> getPokemonList({int limit = 20, int offset = 0}) {
    final url = "$baseUrl/pokemon?limit=$limit&offset=$offset";
    return httpService.get(url);
  }

  Future<Map<String, dynamic>> getPokemonDetail(String nameOrId) {
    final url = "$baseUrl/pokemon/$nameOrId";
    return httpService.get(url);
  }
}
