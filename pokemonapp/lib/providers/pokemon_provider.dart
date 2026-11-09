import 'package:flutter/material.dart';

import '../services/pokemon_service.dart';

class PokemonProvider extends ChangeNotifier {
  List<dynamic> pokemons = [];

  Map<String, dynamic>? pokemonSelecionado;

  Map<String, dynamic>? resultadoBusca;
  String? erroBusca;

  bool carregando = false;

  Future<void> carregarPokemons() async {
    carregando = true;
    notifyListeners();

    pokemons = await PokemonService.buscarPokemons();

    carregando = false;
    notifyListeners();
  }

  Future<void> carregarDetalhes(int id) async {
    carregando = true;
    pokemonSelecionado = null;
    notifyListeners();

    pokemonSelecionado = await PokemonService.buscarDetalhes(id);

    carregando = false;
    notifyListeners();
  }

  Future<void> buscarPorNome(String nome) async {
    carregando = true;
    erroBusca = null;
    resultadoBusca = null;
    notifyListeners();

    try {
      resultadoBusca = await PokemonService.buscarPorNome(nome);
    } catch (e) {
      erroBusca = 'Pokémon não encontrado';
    }

    carregando = false;
    notifyListeners();
  }

  Future<void> carregarAleatorio() async {
    carregando = true;
    pokemonSelecionado = null;
    notifyListeners();

    pokemonSelecionado = await PokemonService.buscarAleatorio();

    carregando = false;
    notifyListeners();
  }
}