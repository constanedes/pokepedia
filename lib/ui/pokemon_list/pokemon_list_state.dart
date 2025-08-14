import 'package:equatable/equatable.dart';
import 'package:pokepedia/data/models/pokemon_list_model.dart';

abstract class PokemonListState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PokemonListInitial extends PokemonListState {}

class PokemonListLoading extends PokemonListState {}

class PokemonListLoaded extends PokemonListState {
  final List<PokemonListItem> data;

  PokemonListLoaded(this.data);

  @override
  List<Object?> get props => [data];
}

class PokemonListError extends PokemonListState {
  final String message;

  PokemonListError(this.message);

  @override
  List<Object?> get props => [message];
}
