import 'package:flutter_bloc/flutter_bloc.dart';
import 'pokemon_list_event.dart';
import 'pokemon_list_state.dart';
import '../../../data/repositories/pokemon_repository.dart';

class PokemonListBloc extends Bloc<PokemonListEvent, PokemonListState> {
  final PokemonRepository repository;

  PokemonListBloc(this.repository) : super(PokemonListInitial()) {
    on<FetchPokemonList>(_onFetchPokemonList);
  }

  Future<void> _onFetchPokemonList(
      FetchPokemonList event, Emitter<PokemonListState> emit) async {
    emit(PokemonListLoading());
    try {
      final data = await repository.fetchPokemonListWithTypes(
        event.limit,
        event.offset,
      );
      emit(PokemonListLoaded(data));
    } catch (e) {
      emit(PokemonListError(e.toString()));
    }
  }
}
