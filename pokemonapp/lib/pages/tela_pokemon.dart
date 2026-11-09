import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/pokemon_provider.dart';
import 'tela_detalhes_pokemon.dart';

class TelaPokemon extends StatefulWidget {
  const TelaPokemon({super.key});

  @override
  State<TelaPokemon> createState() => _TelaPokemonState();
}

class _TelaPokemonState extends State<TelaPokemon> {
  final _controllerBusca = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PokemonProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Pokédex')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // BUSCA POR NOME
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controllerBusca,
                    decoration: const InputDecoration(
                      hintText: 'Digite o nome do Pokémon',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    final nome = _controllerBusca.text.trim();
                    if (nome.isNotEmpty) {
                      context.read<PokemonProvider>().buscarPorNome(nome);
                    }
                  },
                ),
              ],
            ),

            if (provider.resultadoBusca != null)
              Card(
                child: ListTile(
                  leading: Image.network(
                    provider.resultadoBusca!['imagem'],
                    width: 60,
                  ),
                  title: Text(
                    provider.resultadoBusca!['nome'].toString().toUpperCase(),
                  ),
                  subtitle: Text('Tipo: ${provider.resultadoBusca!['tipo']}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TelaDetalhesPokemon(
                          idPokemon: provider.resultadoBusca!['id'],
                        ),
                      ),
                    );
                  },
                ),
              ),

            if (provider.erroBusca != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  provider.erroBusca!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),

            const SizedBox(height: 20),

            // BOTÕES
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      context.read<PokemonProvider>().carregarPokemons();
                    },
                    child: const Text('Buscar Pokémon'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      await context.read<PokemonProvider>().carregarAleatorio();
                      final id = context
                          .read<PokemonProvider>()
                          .pokemonSelecionado?['id'];
                      if (id != null && context.mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                TelaDetalhesPokemon(idPokemon: id),
                          ),
                        );
                      }
                    },
                    child: const Text('Aleatório 🎲'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            if (provider.carregando) const CircularProgressIndicator(),

            if (!provider.carregando)
              Expanded(
                child: ListView.builder(
                  itemCount: provider.pokemons.length,
                  itemBuilder: (context, index) {
                    final pokemon = provider.pokemons[index];

                    return Card(
                      child: ListTile(
                        leading: Image.network(
                          pokemon['imagem'],
                          width: 60,
                        ),
                        title: Text(
                          pokemon['nome'].toString().toUpperCase(),
                        ),
                        subtitle: Text('Tipo: ${pokemon['tipo']}'),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TelaDetalhesPokemon(
                                idPokemon: pokemon['id'],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}