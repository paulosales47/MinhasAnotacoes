import 'package:flutter/material.dart';
import 'package:minhas_anotacoes/helpers/AnotacaoHelper.dart';
import 'package:minhas_anotacoes/models/Anotacao.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  var _tituloController = TextEditingController();
  var _descricaoController = TextEditingController();
  var _anotacaoHelper = AnotacaoHelper();
  List<Anotacao> _anotacoes = [];


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

  _salvarAnotacao() async{
    var anotacao = Anotacao(
      _tituloController.text,
      _descricaoController.text,
      DateTime.now().toString()
    );

    await _anotacaoHelper.salvarAnotacao(anotacao);
    _tituloController.clear();
    _descricaoController.clear();
    _recuperarAnotacoes();
  }

  _recuperarAnotacoes() async{
    _anotacoes.clear();
    List anotacoes = await _anotacaoHelper.listarAnotacoes();

    for(var item in anotacoes){
      _anotacoes.add(Anotacao.fromMap(item));
    }

    setState(() {

    });
  }

  @override
  void initState() {
    super.initState();
    _recuperarAnotacoes();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Minhas anotações"),
        backgroundColor: Colors.lightGreen,
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                  itemCount: _anotacoes.length,
                  itemBuilder: (context, index){
                    final Anotacao anotacao = _anotacoes[index];

                    return Card(
                      child: ListTile(
                        title: Text(anotacao.titulo),
                        subtitle: Text("${anotacao.dataCadastro} - ${anotacao.descricao}"),
                      ),
                    );

                  }),
            )
          ],
        ),
      ),
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
              onPressed: () {
                _salvarAnotacao();
                Navigator.pop(context);
              },
              child: Text("Salvar"),
            ),
          ]);
        },
      ),
    );
  }
}
