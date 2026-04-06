class FpagamentoModel {
  static const tblNome = 'fpagamento';

  static const colId = 'codigo';
  static const colNome = 'nome';
  static const colSituacao = 'situacao';
  static const colAvista = 'avista';
  static const colTipo = 'tipo';
  static const colTroco = 'troco';
  static const colTef = 'tef';
  static const colFinanceiro = 'financeiro';
  static const colBanco = 'banco';
  static const colPrazo = 'prazo';

  FpagamentoModel({
    required this.codigo,
    required this.nome,
    required this.situacao,
    required this.avista,
    required this.tipo,
    required this.troco,
    required this.tef,
    required this.financeiro,
    required this.banco,
    required this.prazo,
  });

  // chave primária
  final int codigo;

  // dados cadastrais
  final String nome;

  // classificação
  final int situacao;
  final int avista;
  final int tipo;
  final int troco;
  final int tef;
  final int financeiro;
  final int banco;
  final int prazo;

  factory FpagamentoModel.empty() => FpagamentoModel(
    codigo: 0,
    nome: '',
    situacao: 0,
    avista: 0,
    tipo: 0,
    troco: 0,
    tef: 0,
    financeiro: 0,
    banco: 0,
    prazo: 0,
  );

  FpagamentoModel copyWith({
    int? codigo,
    String? nome,
    int? situacao,
    int? avista,
    int? tipo,
    int? troco,
    int? tef,
    int? financeiro,
    int? banco,
    int? prazo,
  }) {
    return FpagamentoModel(
      codigo: codigo ?? this.codigo,
      nome: nome ?? this.nome,
      situacao: situacao ?? this.situacao,
      avista: avista ?? this.avista,
      tipo: tipo ?? this.tipo,
      troco: troco ?? this.troco,
      tef: tef ?? this.tef,
      financeiro: financeiro ?? this.financeiro,
      banco: banco ?? this.banco,
      prazo: prazo ?? this.prazo,
    );
  }

  factory FpagamentoModel.fromMap(Map<String, dynamic> map) {
    if (map.isEmpty) return FpagamentoModel.empty();
    return FpagamentoModel(
      codigo: map[colId] as int? ?? 0,
      nome: (map[colNome] ?? '').toString().toUpperCase(),
      situacao: map[colSituacao] as int? ?? 0,
      avista: map[colAvista] as int? ?? 0,
      tipo: map[colTipo] as int? ?? 0,
      troco: map[colTroco] as int? ?? 0,
      tef: map[colTef] as int? ?? 0,
      financeiro: map[colFinanceiro] as int? ?? 0,
      banco: map[colBanco] as int? ?? 0,
      prazo: map[colPrazo] as int? ?? 0,
    );
  }

  Map<String, dynamic> toMap() => {
    colId: codigo,
    colNome: nome,
    colSituacao: situacao,
    colAvista: avista,
    colTipo: tipo,
    colTroco: troco,
    colTef: tef,
    colFinanceiro: financeiro,
    colBanco: banco,
    colPrazo: prazo,
  };

  @override
  String toString() => 'FpagamentoModel(codigo: $codigo, nome: $nome)';
}
