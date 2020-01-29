import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:minhas_anotacoes/helpers/AnotacaoHelper.dart';
import 'package:minhas_anotacoes/models/Anotacao.dart';
import 'package:intl/date_symbol_data_local.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  var _tituloController = TextEditingController();
  var _descricaoController = TextEditingController();
  var _anotacaoHelper = AnotacaoHelper();
  List<Anotacao> _anotacoes = [];


  AlertDialog _exibirAltertCadastroEdicao(String tituloAltert, List<Widget> botoes){
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

  AlertDialog _exibirAllertExclusao(Anotacao anotacao) {
    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text("Confirmação de remoção"),
            actions: <Widget>[
              FlatButton(
                child: Text("Cancelar"),
                onPressed: () async{
                  await _limparCamposAtualizarLista();
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text("Confirmar"),
                onPressed: () async {
                  await _removerAnotacao(anotacao);
                  Navigator.pop(context);
                },
              )
            ],
          );
        }
    );
  }

  _limparCamposAtualizarLista(){
    _tituloController.clear();
    _descricaoController.clear();
    _recuperarAnotacoes();
  }

  _salvarAnotacao() async{
    var anotacao = Anotacao(
      _tituloController.text,
      _descricaoController.text,
      DateTime.now().toString()
    );

    await _anotacaoHelper.salvarAnotacao(anotacao);
    _limparCamposAtualizarLista();
  }

  _atualizarAnotacao(Anotacao anotacao) async{
    anotacao.titulo = _tituloController.text;
    anotacao.descricao = _descricaoController.text;

   await _anotacaoHelper.atualizarAnotacao(anotacao);
  _limparCamposAtualizarLista();
  }

  _removerAnotacao(Anotacao anotacao) async{
    await _anotacaoHelper.removerAnotacao(anotacao);
    _limparCamposAtualizarLista();
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

  String _formatarData(String data){
    initializeDateFormatting('pt_BR');
    var formatador = DateFormat("d/MM/yy - H:m:ss");
    //var formatador = DateFormat.yMMMMd("pt_BR");
    String dataFormatada = formatador.format(DateTime.parse(data));
    return dataFormatada;
  }

  Widget _formatarTituloAnotacao(Anotacao anotacao){
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Text("${_formatarData(anotacao.dataCadastro)} - ${anotacao.titulo}",
        style: TextStyle(
            fontWeight: FontWeight.bold
        ),),
    );
  }

  _montarListaTarefas(Anotacao anotacao){
    return Dismissible(
      child: Card(
        child: ListTile(
          title: _formatarTituloAnotacao(anotacao),
          subtitle: Container(
            child: Text(anotacao.descricao),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              GestureDetector(
                onTap: (){
                  _tituloController.text = anotacao.titulo;
                  _descricaoController.text = anotacao.descricao;

                  _exibirAltertCadastroEdicao("Editar anotação", [
                    FlatButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("Cancelar"),
                    ),
                    FlatButton(
                      onPressed: () {
                        _atualizarAnotacao(anotacao);
                        Navigator.pop(context);
                      },
                      child: Text("Salvar"),
                    ),
                  ]);
                },
                child: Padding(
                  padding: EdgeInsets.only(right: 16),
                  child: Icon(Icons.edit, color: Colors.green,),
                ),
              ),
              GestureDetector(
                onTap: (){
                  _exibirAllertExclusao(anotacao);
                },
                child: Padding(
                  padding: EdgeInsets.only(right: 0),
                  child: Icon(Icons.remove_circle, color: Colors.red,),
                ),
              ),
            ],
          ),
        ),
      ),
      key: UniqueKey(),
      background: Container(
        color: Colors.red,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 16),
              child: Icon(Icons.delete, color: Colors.white),
            )
          ],
        ),
      ),
      direction: DismissDirection.startToEnd,
      onDismissed: (direcao){
        _exibirAllertExclusao(anotacao);
      },
    );
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
        padding: EdgeInsets.only(top: 16, right: 8, left: 8, bottom: 8 ),
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                  itemCount: _anotacoes.length,
                  itemBuilder: (context, index){
                    return _montarListaTarefas(_anotacoes[index]);
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
          _tituloController.clear();
          _descricaoController.clear();

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
