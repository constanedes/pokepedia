class PokemonDetail {
  final int id;
  final String name;
  final int height;
  final int weight;
  final List<PokemonType> types;
  final List<PokemonStat> stats;
  final List<PokemonAbility> abilities;
  final String spriteUrl;

  PokemonDetail({
    required this.id,
    required this.name,
    required this.height,
    required this.weight,
    required this.types,
    required this.stats,
    required this.abilities,
    required this.spriteUrl,
  });

  factory PokemonDetail.fromJson(Map<String, dynamic> json) {
    return PokemonDetail(
      id: json['id'],
      name: json['name'] ?? '',
      height: json['height'] ?? 0,
      weight: json['weight'] ?? 0,
      types: (json['types'] as List)
          .map((t) => PokemonType.fromJson(t['type']))
          .toList(),
      stats: (json['stats'] as List)
          .map((s) => PokemonStat.fromJson(s))
          .toList(),
      abilities: (json['abilities'] as List)
          .map((a) => PokemonAbility.fromJson(a['ability']))
          .toList(),
      spriteUrl: json['sprites']?['other']?['official-artwork']?['front_default'] ??
          json['sprites']?['front_default'] ??
          '',
    );
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