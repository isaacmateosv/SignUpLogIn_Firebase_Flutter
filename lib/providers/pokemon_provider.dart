import 'dart:collection';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:pokedex_mobile/dtos/pokemon_model.dart';

class PokemonProvider extends ChangeNotifier {
  final List<Pokemon> _pokemon = [];

  int get totalPokemons => _pokemon.length;

  UnmodifiableListView<Pokemon> get pokemons => UnmodifiableListView(_pokemon);

  Pokemon getPokemon(int id) {
    /*
      for(int i = 0; i<_pokemon.length; i++){
        if(_pokemon[i].id == id){
          return _pokemon[i];
        }
      }
    */
    return _pokemon.firstWhere((element) => element.id == id);
  }

  Future<bool> checkPokemons() async {
    if (_pokemon.isEmpty) {
      await _initPokemonList();
      return true;
    }
    return false;
  }

  Future<void> _initPokemonList() async {
    var client = http.Client();
    var response = await client.get(Uri.http('pokeapi.co', '/api/v2/pokemon'));
    print('statusPokemon: ${response.statusCode}'); //codigo de retorno HTTP
    //20X -> OK
    //40X -> Errores de lado del cliente (404, 403)
    //50X -> Errores de lado del servidor (500)
    //print('pokemon List: ${response.body}');
    //DART - JSON -> Map<String, Object> -> Object -> List
    var decodedResponse = jsonDecode(response.body);
    var results = decodedResponse['results'] as List;
    for (var ri in results) {
      //ri -Map<String, Object>
      var url = ri['url'] as String;
      await addPokemonList(url);
    }
    notifyListeners();
  }

  Future<void> addPokemonList(String url) async {
    var client = http.Client();
    var response = await client.get(Uri.parse(url));
    var pokemonData = jsonDecode(response.body);
    print('Procesando: $url');

    /*
    var pokemon = Pokemon(
        id: pokemonData['id'],
        name: pokemonData['name'],
        imageUrl: pokemonData['sprites']['front_default']);
    */
    _pokemon.add(Pokemon.fromJson(pokemonData));

    final pokemonDocument = <String, dynamic>{
      //'id': pokemonData['id'],
      //'name': pokemonData['name']
      'additionalName': 'Test'
    };

    var db = FirebaseFirestore.instance;
    /*
      Future:
        - let value = await future();
        - future().then(
          (value) =>{

          }
        );
    */
    /* Agregar documentos en la base con Ids autogenerados
    db
        .collection("pokemons")
        .add(pokemonDocument)
        .then((value) => print('success'));
        */
    var setOptions = SetOptions(merge: true);
    db
        .collection("pokemons")
        .doc(pokemonData['id'].toString())
        .set(pokemonDocument, setOptions)
        .then((value) => print("success"));
  }
}
