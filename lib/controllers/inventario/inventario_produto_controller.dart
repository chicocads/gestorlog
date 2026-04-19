import '../../core/controllers/base_controller.dart';
import '../../models/cadastro/produto_model.dart';
import '../../services/cadastro/produto/produto_local_service.dart';

class InventarioProdutoController extends BaseController {
  InventarioProdutoController(this._service);

  static const int _pageSize = 50;

  final ProdutoLocalService _service;

  final List<ProdutoModel> _itens = [];
  ProdutoModel _selecionado = ProdutoModel.empty();
  int _offset = 0;
  bool _temMaisPaginas = true;
  int? _codigoFiltro;
  String _termoBarra = '';
  String _termoNome = '';

  List<ProdutoModel> get itens => List.unmodifiable(_itens);
  ProdutoModel get selecionado => _selecionado;
  bool get temMaisPaginas => _temMaisPaginas;
  int? get codigoFiltro => _codigoFiltro;
  String get termoBarra => _termoBarra;
  String get termoNome => _termoNome;

  Future<void> consultar({
    String termoBusca = '',
  }) async {
    _offset = 0;
    _temMaisPaginas = true;
    _aplicarFiltroBusca(termoBusca);
    _itens.clear();
    notifyListeners();

    await runAsync(() async {
      final itens = await _service.listar(
        limit: _pageSize,
        offset: 0,
        codigo: _codigoFiltro,
        termoBarra: _termoBarra,
        termoNome: _termoNome,
      );
      _itens
        ..clear()
        ..addAll(itens);
      _offset = _itens.length;
      _temMaisPaginas = itens.length == _pageSize;
    });
  }

  Future<void> consultarMais() async {
    if (!_temMaisPaginas || isLoading) return;

    await runAsync(() async {
      final itens = await _service.listar(
        limit: _pageSize,
        offset: _offset,
        codigo: _codigoFiltro,
        termoBarra: _termoBarra,
        termoNome: _termoNome,
      );
      _itens.addAll(itens);
      _offset = _itens.length;
      _temMaisPaginas = itens.length == _pageSize;
    });
  }

  void selecionar(ProdutoModel produto) {
    _selecionado = produto;
    notifyListeners();
  }

  void _aplicarFiltroBusca(String termoBusca) {
    final termo = termoBusca.trim();
    _codigoFiltro = null;
    _termoBarra = '';
    _termoNome = '';

    if (termo.isEmpty) return;

    final somenteDigitos = RegExp(r'^\d+$').hasMatch(termo);
    if (somenteDigitos) {
      if (termo.length > 10) {
        _termoBarra = termo;
      } else {
        _codigoFiltro = int.tryParse(termo);
      }
      return;
    }

    _termoNome = termo;
  }
}
