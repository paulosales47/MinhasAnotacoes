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
    _limparCamposAtualizarLista();
  }

  _limparCamposAtualizarLista(){
    _tituloController.clear();
    _descricaoController.clear();
    _recuperarAnotacoes();
  }

  _atualizarAnotacao(Anotacao anotacao) async{
    anotacao.titulo = _tituloController.text;
    anotacao.descricao = _descricaoController.text;

   await _anotacaoHelper.atualizarAnotacao(anotacao);
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
    var formatador = DateFormat("d/MM/y - H:m:s");
    //var formatador = DateFormat.yMMMMd("pt_BR");
    String dataFormatada = formatador.format(DateTime.parse(data));
    return dataFormatada;
  }

  Widget _formatarTextoAnotacao(Anotacao anotacao){
    return Padding(
      padding: EdgeInsets.only(top: 16),
      child: Row(
        children: <Widget>[
          Text(_formatarData(anotacao.dataCadastro), style: TextStyle(
              fontWeight: FontWeight.bold
          ),),
          Text(" - "),
          Text(anotacao.descricao)
        ],
      ),
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
                    final Anotacao anotacao = _anotacoes[index];

                    return Card(
                      child: ListTile(
                        title: Text(anotacao.titulo),
                        subtitle: _formatarTextoAnotacao(anotacao),
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
                              onTap: (){},
                              child: Padding(
                                padding: EdgeInsets.only(right: 0),
                                child: Icon(Icons.remove_circle, color: Colors.red,),
                              ),
                            ),
                          ],
                        ),
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
