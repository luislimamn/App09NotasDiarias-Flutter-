import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final _titulo = "Notas Diarias";
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();

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
              onPressed: ( ){
                //Salvar
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titulo),
        backgroundColor: Colors.lightGreen,
        foregroundColor: Colors.white,
      ),
      body: Container(

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
