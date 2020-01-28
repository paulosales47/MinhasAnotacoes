class Anotacao{

  int _id;
  String _titulo;
  String _descricao;
  String _dataCadastro;
  String _dataAtualizacao;

  Anotacao(this._titulo, this._descricao, this._dataCadastro, [this._dataAtualizacao]);

  Map toMap(){
    Map<String, dynamic> mapAnotacao = {
      "TITULO": this.titulo,
      "DESCRICAO": this.descricao,
      "DATA_CADASTRO": this.dataCadastro,
      "DATA_ATUALIZACAO": this.dataAtualizacao
    };

    return mapAnotacao;

  }


  String get dataAtualizacao => _dataAtualizacao;

  String get dataCadastro => _dataCadastro;

  String get descricao => _descricao;

  String get titulo => _titulo;

  int get id => _id;
}