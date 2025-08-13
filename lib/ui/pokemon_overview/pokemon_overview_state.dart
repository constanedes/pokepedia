import 'package:equatable/equatable.dart';
import 'package:pokepedia/data/models/pokemon_detail_model.dart';


abstract class PokemonOverviewState extends Equatable {
  const PokemonOverviewState();

  @override
  List<Object?> get props => [];
}

class PokemonOverviewInitial extends PokemonOverviewState {}

class PokemonOverviewLoading extends PokemonOverviewState {}

class PokemonOverviewLoaded extends PokemonOverviewState {
  final Pokemon pokemon;
  final bool isFavorite;

  const PokemonOverviewLoaded(this.pokemon, {required this.isFavorite});

  @override
  List<Object?> get props => [pokemon, isFavorite];
}

class PokemonOverviewError extends PokemonOverviewState {
  final String message;

  const PokemonOverviewError(this.message);

  @override
  List<Object?> get props => [message];
}
