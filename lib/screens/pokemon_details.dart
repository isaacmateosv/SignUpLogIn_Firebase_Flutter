import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pokedex_mobile/providers/pokemon_provider.dart';
import 'package:provider/provider.dart';

class PokemonDetailsScreen extends StatelessWidget {
  static const routeName = '/pokemon-details';

  const PokemonDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    int id = ModalRoute.of(context)!.settings.arguments as int;

    var pokemonData = Provider.of<PokemonProvider>(
      context,
      listen: false,
    ).getPokemon(id);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles'),
      ),
      body: SizedBox(
        height: 300,
        child: Image(
          fit: BoxFit.cover,
          image: NetworkImage(
            pokemonData.imageUrl,
          ),
        ),
      ),
    );
  }
}
