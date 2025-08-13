import 'package:flutter/material.dart';
import 'package:pokepedia/ui/pages/pokemon_list_page.dart';
import 'package:pokepedia/ui/pages/pokemon_overview_page.dart';

class PokemonRoutes {
  static const String list = '/pokemon/list';
  static const String overview = '/pokemon/overview';
  static const String favorites = '/pokemon/favorites';

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case list:
        return MaterialPageRoute(builder: (_) => const PokemonListPage());
      case overview:
        final name = settings.arguments as String;
        return MaterialPageRoute(
          builder: (context) => PokemonOverviewPage(name: name),
        );
      default:
        return null;
    }
  }
}


