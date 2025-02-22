import 'package:common_files/common_files.dart';

class MovimentoCaixaParcelaDAO implements IEntityDAO {
  HasuraBloc _hasuraBloc;
  AppGlobalBloc _appGlobalBloc;
  final String tableName = "movimento_caixa_parcela";
  int filterMovimentoCaixa = 0;
  bool loadTipoPagamento = false;
    
  MovimentoCaixaParcela movimentoCaixaParcela;
  List<MovimentoCaixaParcela> movimentoCaixaParcelaList;
  
  @override
  Dao dao;

  MovimentoCaixaParcelaDAO(this._hasuraBloc, this.movimentoCaixaParcela, this._appGlobalBloc) {
    dao = Dao();
    movimentoCaixaParcela = movimentoCaixaParcela == null ? MovimentoCaixaParcela() : movimentoCaixaParcela;
  }  

  @override
  IEntity fromMap(Map<String, dynamic> map) {}

  @override
  Future<List> getAll({bool preLoad=false}) async {
    String where = "1 = 1 ";
    where = filterMovimentoCaixa > 0 ? where + " and id_app_movimento_caixa = $filterMovimentoCaixa" : where; 

    List<dynamic> args = [];

    List list = await dao.getList(this, where, args);
    movimentoCaixaParcelaList = List.generate(list.length, (i) {
      return MovimentoCaixaParcela(
        idApp: list[i]['id_app'],
        id: list[i]['id'],
        idAppMovimentoCaixa: list[i]['id_app_movimento_caixa'],
        idMovimentoCaixa: list[i]['id_movimento_caixa'],
        idTipoPagamento: list[i]['id_tipo_pagamento'],
        data: DateTime.parse(list[i]['data']),
        descricao: list[i]['descricao'],
        valor: list[i]['valor'],
        ehAbertura: list[i]['ehabertura'],
        ehReforco: list[i]['ehreforco'],
        ehRetirada: list[i]['ehretirada'],
        observacao: list[i]['observacao'],
        dataCadastro: DateTime.parse(list[i]['data_cadastro']),
        dataAtualizacao: DateTime.parse(list[i]['data_atualizacao']),
      );
    });

    if (preLoad) {
      for (var movimentoCaixaParcela in movimentoCaixaParcelaList){
        if (loadTipoPagamento) {
          TipoPagamento _tipoPagamento = TipoPagamento();
          TipoPagamentoDAO _tipoPagamentoDAO = TipoPagamentoDAO(_hasuraBloc, _appGlobalBloc, tipoPagamento: _tipoPagamento);
          movimentoCaixaParcela.tipoPagamento = await _tipoPagamentoDAO.getById(movimentoCaixaParcela.idTipoPagamento);
        }  
      }
    }  
  
    return movimentoCaixaParcelaList;
  }

  @override
  Future<IEntity> getById(int id) async {
    movimentoCaixaParcela = await dao.getById(this, id);
    return movimentoCaixaParcela;
  }

  @override
  Future<IEntity> insert() async {
    this.movimentoCaixaParcela.idApp = await dao.insert(this);
    return this.movimentoCaixaParcela;
  }

  @override
  Future<IEntity> delete(int id) async {
    await dao.delete(this, id);
    return this.movimentoCaixaParcela;
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id_app': this.movimentoCaixaParcela.idApp,
      'id': this.movimentoCaixaParcela.id,
      'id_movimento_caixa': this.movimentoCaixaParcela.idMovimentoCaixa,
      'id_app_movimento_caixa': this.movimentoCaixaParcela.idAppMovimentoCaixa,
      'id_tipo_pagamento': this.movimentoCaixaParcela.idTipoPagamento,
      'data': this.movimentoCaixaParcela.data.toString(),
      'descricao': this.movimentoCaixaParcela.descricao,
      'valor': this.movimentoCaixaParcela.valor,
      'observacao': this.movimentoCaixaParcela.observacao,
      'ehabertura': this.movimentoCaixaParcela.ehAbertura,
      'ehreforco': this.movimentoCaixaParcela.ehReforco,
      'ehretirada': this.movimentoCaixaParcela.ehRetirada,
      'data_cadastro': this.movimentoCaixaParcela.dataCadastro.toString(),
      'data_atualizacao': this.movimentoCaixaParcela.dataAtualizacao.toString(),
    };
  }
}
