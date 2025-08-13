class Pokemon {
  final int id;
  final String name;
  final String url;
  final int? height;
  final int? weight;
  final List<PokemonType>? types;
  final List<PokemonStat>? stats;
  final List<PokemonAbility>? abilities;
  final String? spriteUrl;

  Pokemon({
    required this.id,
    required this.name,
    required this.url,
    this.height,
    this.weight,
    this.types,
    this.stats,
    this.abilities,
    this.spriteUrl,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      id: json['id'],
      name: json['name'] ?? '',
      url: json['url'] ?? '',
      height: json['height'],
      weight: json['weight'],
      types: json['types'] != null
          ? (json['types'] as List)
                .map((t) => PokemonType.fromJson(t['type']))
                .toList()
          : null,
      stats: json['stats'] != null
          ? (json['stats'] as List).map((s) => PokemonStat.fromJson(s)).toList()
          : null,
      abilities: json['abilities'] != null
          ? (json['abilities'] as List)
                .map((a) => PokemonAbility.fromJson(a['ability']))
                .toList()
          : null,
      spriteUrl:
          json['sprites']?['other']?['official-artwork']?['front_default'] ??
          json['sprites']?['front_default'],
    );
  }

  String get derivedImageUrl {
    if (spriteUrl != null && spriteUrl!.isNotEmpty) return spriteUrl ?? "";
    return 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$id.png';
  }

  static List<Pokemon> listFromJson(List<dynamic> jsonList) {
    return jsonList
        .map((item) => Pokemon.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}

class PokemonType {
  final String name;

  PokemonType({required this.name});

  factory PokemonType.fromJson(Map<String, dynamic> json) {
    return PokemonType(name: json['name'] ?? '');
  }
}

class PokemonStat {
  final String name;
  final int baseStat;

  PokemonStat({required this.name, required this.baseStat});

  factory PokemonStat.fromJson(Map<String, dynamic> json) {
    return PokemonStat(
      name: json['stat']?['name'] ?? '',
      baseStat: json['base_stat'] ?? 0,
    );
  }
}

class PokemonAbility {
  final String name;

  PokemonAbility({required this.name});

  factory PokemonAbility.fromJson(Map<String, dynamic> json) {
    return PokemonAbility(name: json['name'] ?? '');
  }
}
