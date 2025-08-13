import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart'; // <- Asegurate de importarlo
import 'package:pokepedia/core/routes/pokemon_routes.dart';
import 'package:pokepedia/core/services/http_service.dart';
import 'package:pokepedia/data/repositories/pokemon_repository.dart';
import 'package:pokepedia/data/services/pokemon_service.dart';
import 'package:pokepedia/ui/pokemon_list/pokemon_list_bloc.dart';

void main() {
  final httpService = HttpService();
  final pokemonService = PokemonService(httpService);
  final pokemonRepository = PokemonRepository(pokemonService);

  runApp(MyApp(pokemonRepository: pokemonRepository));
}

class MyApp extends StatelessWidget {
  final PokemonRepository pokemonRepository;

  const MyApp({super.key, required this.pokemonRepository});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<PokemonRepository>.value(value: pokemonRepository),
        BlocProvider(
          create: (_) => PokemonListBloc(pokemonRepository),
        ),
      ],
      child: MaterialApp(
        title: 'Pokepedia',
        initialRoute: PokemonRoutes.list,
        debugShowCheckedModeBanner: false,
        onGenerateRoute: PokemonRoutes.onGenerateRoute,
        theme: ThemeData(
          primarySwatch: Colors.red,
        ),
      ),
    );
  }
}
