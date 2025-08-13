import 'package:equatable/equatable.dart';
import 'package:pokepedia/data/models/pokemon_model.dart';


abstract class PokemonOverviewEvent extends Equatable {
  const PokemonOverviewEvent();

  @override
  List<Object?> get props => [];
}

class LoadPokemonDetail extends PokemonOverviewEvent {
  final String name;

  const LoadPokemonDetail(this.name);

  @override
  List<Object?> get props => [name];
}

class BackToList extends PokemonOverviewEvent {
  const BackToList();

  @override
  List<Object?> get props => [];
}

class AddToFavorites extends PokemonOverviewEvent {
  final Pokemon pokemon;

  const AddToFavorites(this.pokemon);

  @override
  List<Object?> get props => [pokemon];
}

class RemoveFromFavorites extends PokemonOverviewEvent {
  final int pokemonId;

  const RemoveFromFavorites(this.pokemonId);

  @override
  List<Object?> get props => [pokemonId];
}
