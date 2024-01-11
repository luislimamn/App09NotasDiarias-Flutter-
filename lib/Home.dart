import 'package:flutter/material.dart';
import 'package:notas_diarias/model/Anotacao.dart';
import 'package:notas_diarias/helper/AnotacaoHelper.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final _titulo = "Notas Diarias";
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  var _db = AnotacaoHelper();
  List<Anotacao> _anotacoes = [];

  _exibirTelaCadastro() {
    showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: Text("Adicionar Anotação"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: _tituloController,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: "Título",
                  hintText: "Digite título..."
                ),
              ),
              TextField(
                controller: _descricaoController,
                decoration: const InputDecoration(
                    labelText: "Descrição",
                    hintText: "Digite a Descrição..."
                ),
              )
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll<Color>(Colors.red),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "Cancelar",
                style: TextStyle(
                    color: Colors.white
                ),
              ),
            ),
            ElevatedButton(
              style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll<Color>(Colors.lightGreen),
              ),
              onPressed: () {

                _salvarAnotacao();
                Navigator.pop(context);
              },
              child: const Text(
                "Salvar",
                style: TextStyle(
                    color: Colors.white
                ),
              ),
            )
          ],
        );
      }
    );
  }
  _recuperarAnotacao() async {
    List anotacoesRecuperadas = await _db.recuperarAnotacao();
    List<Anotacao> listaTemporaria = [];
    for( var item in anotacoesRecuperadas){
      Anotacao anotacao = Anotacao.fromMap(item);
      listaTemporaria.add(anotacao);
    }
    setState(() {
      _anotacoes = listaTemporaria;
    });
    listaTemporaria = [];
    //print("Anotações: " + anotacoesRecuperadas.toString());
  }

  _salvarAnotacao() async {
    String titulo = _tituloController.text;
    String descricao = _descricaoController.text;
    //String dataAtual = DateTime.now().toString();
    Anotacao anotacao = Anotacao(titulo, descricao, DateTime.now().toString());
    int resultado = await _db.salvarAnotacao(anotacao);
    //print("Salvar Anotação:" + resultado.toString() );
    _tituloController.clear();
    _descricaoController.clear();
    _recuperarAnotacao();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _recuperarAnotacao();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(_titulo),
        backgroundColor: Colors.lightGreen,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: _anotacoes.length,
              itemBuilder: (context, index){
                final anotacao = _anotacoes[index];
                return Card(
                  child: ListTile(
                    title: Text("${anotacao.titulo}"),
                    subtitle: Text("${anotacao.data} - ${anotacao.descricao}"),
                  ),
                );
              }
            )
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightGreen,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
        onPressed: (){
          _exibirTelaCadastro();
        }
      ),
    );
  }
}
