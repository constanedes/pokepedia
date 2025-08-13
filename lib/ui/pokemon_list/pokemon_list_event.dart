import 'package:equatable/equatable.dart';

abstract class PokemonListEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchPokemonList extends PokemonListEvent {
  final int limit;
  final int offset;

  FetchPokemonList({this.limit = 20, this.offset = 0});

  @override
  List<Object?> get props => [limit, offset];
}
