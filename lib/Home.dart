import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  var _tituloController = TextEditingController();
  var _descricaoController = TextEditingController();


  _exibirAltertCadastroEdicao(String tituloAltert, List<Widget> botoes){
    showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: Text(tituloAltert),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: _tituloController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: "Informe o título"
                ),
              ),
              TextField(
                controller: _descricaoController,
                decoration: InputDecoration(
                    hintText: "Informe a descrição"
                ),
              ),
            ],
          ),
          actions: botoes
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Minhas anotações"),
        backgroundColor: Colors.lightGreen,
      ),
      body: Container(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
        onPressed: (){
          _exibirAltertCadastroEdicao("Adicionar anotação", [
            FlatButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancelar"),
            ),
            FlatButton(
              onPressed: () => {

                Navigator.pop(context)
              },
              child: Text("Adicionar"),
            ),
          ]);
        },
      ),
    );
  }
}
