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

  Anotacao.fromMap(Map<String, dynamic> mapAnotacao){

      this._id = mapAnotacao["ID"];
      this._titulo = mapAnotacao["TITULO"];
      this._descricao = mapAnotacao["DESCRICAO"];
      this._dataCadastro = mapAnotacao["DATA_CADASTRO"];
      this._dataAtualizacao = mapAnotacao["DATA_ATUALIZACAO"];
  }

  String get dataAtualizacao => _dataAtualizacao;

  String get dataCadastro => _dataCadastro;

  String get descricao => _descricao;

  String get titulo => _titulo;

  int get id => _id;
}