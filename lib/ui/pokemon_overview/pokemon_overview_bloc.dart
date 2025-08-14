import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokepedia/data/models/pokemon_detail_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pokemon_overview_event.dart';
import 'pokemon_overview_state.dart';
import '../../../data/repositories/pokemon_repository.dart';

class PokemonOverviewBloc extends Bloc<PokemonOverviewEvent, PokemonOverviewState> {
  final PokemonRepository repository;
  static const _favoritesKey = 'favorites';

  final List<PokemonDetail> _favorites = [];
  final List<int> _favoriteIds = [];

  PokemonOverviewBloc(this.repository) : super(PokemonOverviewInitial()) {
    on<LoadPokemonDetail>(_onLoadPokemonDetail);
    on<AddToFavorites>(_onAddToFavorites);
    on<RemoveFromFavorites>(_onRemoveFromFavorites);

    _loadFavoritesFromPrefs();
  }

  Future<void> _loadFavoritesFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final favIds = prefs.getStringList(_favoritesKey) ?? [];
    _favoriteIds.clear();
    _favoriteIds.addAll(favIds.map(int.parse));
  }

  Future<void> _saveFavoritesToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_favoritesKey, _favoriteIds.map((e) => e.toString()).toList());
  }

  Future<void> _onLoadPokemonDetail(
    LoadPokemonDetail event,
    Emitter<PokemonOverviewState> emit,
  ) async {
    emit(PokemonOverviewLoading());
    try {
      final detail = await repository.fetchPokemonDetail(event.name);
      final isFav = _favoriteIds.contains(detail.id);
      if (isFav && !_favorites.any((p) => p.id == detail.id)) {
        _favorites.add(detail);
      }
      emit(PokemonOverviewLoaded(detail, isFavorite: isFav));
    } catch (e) {
      emit(PokemonOverviewError(e.toString()));
    }
  }

  Future<void> _onAddToFavorites(
    AddToFavorites event,
    Emitter<PokemonOverviewState> emit,
  ) async {
    if (!_favoriteIds.contains(event.pokemon.id)) {
      _favoriteIds.add(event.pokemon.id);
      _favorites.add(event.pokemon);
      await _saveFavoritesToPrefs();
    }
    emit(PokemonOverviewLoaded(event.pokemon, isFavorite: true));
  }

  Future<void> _onRemoveFromFavorites(
    RemoveFromFavorites event,
    Emitter<PokemonOverviewState> emit,
  ) async {
    _favoriteIds.remove(event.pokemonId);
    _favorites.removeWhere((p) => p.id == event.pokemonId);
    await _saveFavoritesToPrefs();

    if (state is PokemonOverviewLoaded) {
      final currentPokemon = (state as PokemonOverviewLoaded).pokemon;
      if (currentPokemon.id == event.pokemonId) {
        emit(PokemonOverviewLoaded(currentPokemon, isFavorite: false));
      }
    }
  }
}
