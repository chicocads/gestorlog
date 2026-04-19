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
  String _termoCodigoBarra = '';
  String _termoNome = '';

  List<ProdutoModel> get itens => List.unmodifiable(_itens);
  ProdutoModel get selecionado => _selecionado;
  bool get temMaisPaginas => _temMaisPaginas;
  String get termoCodigoBarra => _termoCodigoBarra;
  String get termoNome => _termoNome;

  Future<void> consultar({
    String termoCodigoBarra = '',
    String termoNome = '',
  }) async {
    _offset = 0;
    _temMaisPaginas = true;
    _termoCodigoBarra = termoCodigoBarra.trim();
    _termoNome = termoNome.trim();
    _itens.clear();
    notifyListeners();

    await runAsync(() async {
      final itens = await _service.listar(
        limit: _pageSize,
        offset: 0,
        termoCodigoBarra: _termoCodigoBarra,
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
        termoCodigoBarra: _termoCodigoBarra,
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
}
