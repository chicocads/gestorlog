class RequestDadoFisicoProduto {
  static const colPeso = 'peso';
  static const colAltura = 'altura';
  static const colLargura = 'largura';
  static const colComprimento = 'comprimento';

  RequestDadoFisicoProduto({
    required this.peso,
    required this.altura,
    required this.largura,
    required this.comprimento,
  });

  final double peso;
  final double altura;
  final double largura;
  final double comprimento;

  factory RequestDadoFisicoProduto.empty() => RequestDadoFisicoProduto(
    peso: 0.0,
    altura: 0.0,
    largura: 0.0,
    comprimento: 0.0,
  );

  RequestDadoFisicoProduto copyWith({
    double? peso,
    double? altura,
    double? largura,
    double? comprimento,
  }) {
    return RequestDadoFisicoProduto(
      peso: peso ?? this.peso,
      altura: altura ?? this.altura,
      largura: largura ?? this.largura,
      comprimento: comprimento ?? this.comprimento,
    );
  }

  factory RequestDadoFisicoProduto.fromMap(Map<String, dynamic> map) {
    if (map.isEmpty) return RequestDadoFisicoProduto.empty();
    return RequestDadoFisicoProduto(
      peso: (map[colPeso] ?? 0.0).toDouble(),
      altura: (map[colAltura] ?? 0.0).toDouble(),
      largura: (map[colLargura] ?? 0.0).toDouble(),
      comprimento: (map[colComprimento] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() => {
    colPeso: peso,
    colAltura: altura,
    colLargura: largura,
    colComprimento: comprimento,
  };
}
