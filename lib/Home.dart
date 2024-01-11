import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
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

  _exibirTelaCadastro( {Anotacao? anotacao} ) {
    String textoSalvarAtualizar = "";
    if(anotacao == null){ //Salvar
      _tituloController.text = "";
      _descricaoController.text = "";
      textoSalvarAtualizar = "Salvar";
    }else{ //Atualizar
      _tituloController.text = anotacao.titulo!;
      _descricaoController.text = anotacao.descricao!;
      textoSalvarAtualizar = "Atualizar";
    }

    showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: Text("$textoSalvarAtualizar Anotação"),
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

                _salvarAtualizaAnotacao(anotacaoSelecionada: anotacao!);
                Navigator.pop(context);
              },
              child: Text(
                textoSalvarAtualizar,
                style: const TextStyle(
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

  _salvarAtualizaAnotacao( {Anotacao? anotacaoSelecionada} ) async {
    String titulo = _tituloController.text;
    String descricao = _descricaoController.text;

    if(anotacaoSelecionada == null){ //Salvar
      Anotacao anotacao = Anotacao(titulo, descricao, DateTime.now().toString());
      int resultado = await _db.salvarAnotacao(anotacao);
      if (kDebugMode) {
        print("Salvar Anotação: $resultado" );
      }
    }else{ //Atualizar
      anotacaoSelecionada.titulo = titulo;
      anotacaoSelecionada.descricao = descricao;
      anotacaoSelecionada.data = DateTime.now().toString();
      int resultado = await _db.atualizarAnotacao(anotacaoSelecionada);
    }

    _tituloController.clear();
    _descricaoController.clear();
    _recuperarAnotacao();
  }
  _formatarData(String? data){
    initializeDateFormatting("pt_BR");
    var formatador = DateFormat("dd/MM/yyyy HH:mm:ss");
    DateTime dataConvertida = DateTime.parse(data!);
    String dataFormatada = formatador.format(dataConvertida);
    return dataFormatada;
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
                    subtitle: Text("${_formatarData(anotacao.data)} - ${anotacao.descricao}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        GestureDetector(
                          onTap: (){
                            _exibirTelaCadastro(anotacao: anotacao);
                          },
                          child: const Padding(
                            padding: EdgeInsets.only(right: 16),
                            child: Icon(
                              Icons.edit,
                              color: Colors.green,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: (){

                          },
                          child: const Padding(
                            padding: EdgeInsets.only(right: 0),
                            child: Icon(
                              Icons.remove_circle,
                              color: Colors.red,
                            ),
                          ),
                        )
                      ],
                    ),
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
