import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokepedia/data/models/pokemon_detail_model.dart';
import 'package:pokepedia/ui/pokemon_list/pokemon_list_bloc.dart';
import 'package:pokepedia/ui/pokemon_list/pokemon_list_event.dart';
import 'package:pokepedia/ui/pokemon_list/pokemon_list_state.dart';

class PokemonListPage extends StatefulWidget {
  const PokemonListPage({super.key});

  @override
  State<PokemonListPage> createState() => _PokemonListPageState();
}

class _PokemonListPageState extends State<PokemonListPage> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<Pokemon> _allPokemons = [];
  List<Pokemon> _filteredPokemons = [];

  bool _isLoadingMore = false;
  int _offset = 0;
  final int _limit = 50;
  int _totalCount = 0;

  @override
  void initState() {
    super.initState();
    _loadPokemons();

    _scrollController.addListener(_onScroll);
    _searchController.addListener(_onSearchChanged);
  }

  void _loadPokemons() {
    context.read<PokemonListBloc>().add(FetchPokemonList(limit: _limit, offset: _offset));
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isLoadingMore &&
        _allPokemons.length < _totalCount) {
      _isLoadingMore = true;
      _offset += _limit;
      _loadPokemons();
    }
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredPokemons = _allPokemons;
      } else {
        _filteredPokemons = _allPokemons
            .where((p) => p.name.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PokéPedia'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar Pokémon',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),
        ),
      ),
      body: BlocConsumer<PokemonListBloc, PokemonListState>(
        listener: (context, state) {
          if (state is PokemonListLoaded) {
            setState(() {
              _isLoadingMore = false;
              _totalCount = state.data.length;


              final newPokemons = state.data.toList();
              final currentNames = _allPokemons.map((e) => e.name).toSet();

              _allPokemons.addAll(newPokemons.where((p) => !currentNames.contains(p.name)));

              final query = _searchController.text.toLowerCase();
              if (query.isEmpty) {
                _filteredPokemons = _allPokemons;
              } else {
                _filteredPokemons = _allPokemons
                    .where((p) => p.name.toLowerCase().contains(query))
                    .toList();
              }
            });
          } else if (state is PokemonListError) {
            setState(() {
              _isLoadingMore = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.message}')),
            );
          }
        },
        builder: (context, state) {
          if (state is PokemonListInitial || (_allPokemons.isEmpty && state is! PokemonListLoaded)) {
            return const Center(child: CircularProgressIndicator());
          }

          if (_filteredPokemons.isEmpty) {
            return const Center(child: Text('No se encontraron Pokémon'));
          }

          return Stack(
            children: [
              GridView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(8),
                itemCount: _filteredPokemons.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 0.75,
                ),
                itemBuilder: (context, index) {
                  final pokemon = _filteredPokemons[index];

                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/pokemon/overview',
                        arguments: pokemon.name
                      );
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Image.network(
                              pokemon.derivedImageUrl,
                              fit: BoxFit.contain,
                              errorBuilder: (_, _, _) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            pokemon.name.toUpperCase(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  );
                },
              ),
              if (_isLoadingMore)
                Positioned(
                  bottom: 8,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const CircularProgressIndicator(),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
