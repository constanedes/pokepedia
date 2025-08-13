import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokepedia/ui/pokemon_overview/pokemon_overview_bloc.dart';
import 'package:pokepedia/ui/pokemon_overview/pokemon_overview_event.dart';
import 'package:pokepedia/ui/pokemon_overview/pokemon_overview_state.dart';

class PokemonOverviewPage extends StatelessWidget {
  final String name;

  const PokemonOverviewPage({super.key, required this.name});

  static const Map<String, Color> typeColors = {
    'normal': Colors.brown,
    'fire': Colors.red,
    'water': Colors.blue,
    'electric': Colors.yellow,
    'grass': Colors.green,
    'ice': Colors.cyan,
    'fighting': Colors.orange,
    'poison': Colors.purple,
    'ground': Colors.brown,
    'flying': Colors.indigo,
    'psychic': Colors.pink,
    'bug': Colors.lightGreen,
    'rock': Colors.grey,
    'ghost': Colors.deepPurple,
    'dragon': Colors.indigoAccent,
    'dark': Colors.black54,
    'steel': Colors.blueGrey,
    'fairy': Colors.pinkAccent,
  };

  Color getTypeColor(String type) =>
      typeColors[type.toLowerCase()] ?? Colors.grey;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          PokemonOverviewBloc(context.read())..add(LoadPokemonDetail(name)),
      child: Scaffold(
        appBar: AppBar(
          title: Text(name.toUpperCase()),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            BlocBuilder<PokemonOverviewBloc, PokemonOverviewState>(
              builder: (context, state) {
                bool isFavorite = false;
                if (state is PokemonOverviewLoaded) {
                  isFavorite = state.isFavorite;
                }
                return IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : Colors.red.shade300,
                  ),
                  onPressed: () {
                    if (state is PokemonOverviewLoaded) {
                      final bloc = context.read<PokemonOverviewBloc>();
                      if (isFavorite) {
                        bloc.add(RemoveFromFavorites(state.pokemon.id));
                      } else {
                        bloc.add(AddToFavorites(state.pokemon));
                      }
                    }
                  },
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<PokemonOverviewBloc, PokemonOverviewState>(
          builder: (context, state) {
            if (state is PokemonOverviewLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is PokemonOverviewLoaded) {
              final p = state.pokemon;
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Image.network(
                        p.derivedImageUrl,
                        height: 200,
                        fit: BoxFit.contain,
                        errorBuilder: (_, _, _) =>
                            const Icon(Icons.error, size: 100),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      children: p.types
                          !.map(
                            (t) => Chip(
                              label: Text(t.name.toUpperCase()),
                              backgroundColor: getTypeColor(t.name),
                              labelStyle: const TextStyle(color: Colors.white),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 12),
                    // Mostrar generación (si disponible),
                    const Text(
                      'Stats',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ...p.stats!.map(
                      (s) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 80,
                              child: Text(
                                s.name.toUpperCase(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Expanded(
                              child: LinearProgressIndicator(
                                value: s.baseStat / 100,
                                backgroundColor: Colors.grey.shade300,
                                color: Colors.blue,
                                minHeight: 8,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(s.baseStat.toString()),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Abilities',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Wrap(
                      spacing: 8,
                      children: p.abilities
                          !.map(
                            (a) => Chip(
                              label: Text(a.name),
                              backgroundColor: Colors.green.shade300,
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            const Text(
                              'Height',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text('${p.height! / 10} m'),
                          ],
                        ),
                        Column(
                          children: [
                            const Text(
                              'Weight',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text('${p.weight! / 10} kg'),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              );
            } else if (state is PokemonOverviewError) {
              return Center(child: Text('Error: ${state.message}'));
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}
