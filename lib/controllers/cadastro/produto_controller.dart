import '../../core/controllers/base_controller.dart';
import '../../models/cadastro/produto_model.dart';
import '../../services/cadastro/produto/produto_service.dart';
import '../../services/cadastro/produto/request_produto.dart';
import '../../services/cadastro/produto/response_produto.dart';

class ProdutoController extends BaseController {
  ProdutoController(this._service, this._getBaseUrl);

  final ProdutoService _service;
  final String Function() _getBaseUrl;

  ResponseProduto _response = ResponseProduto.empty();
  RequestProduto _filtro = RequestProduto.empty();
  ProdutoModel _selecionado = ProdutoModel.empty();

  List<ProdutoModel> get itens => _response.itens;
  ResponseProduto get response => _response;
  RequestProduto get filtro => _filtro;
  ProdutoModel get selecionado => _selecionado;
  bool get temMaisPaginas => _response.paginaAtual < _response.qtdPaginas;

  void setFiltro(RequestProduto filtro) {
    _filtro = filtro;
    notifyListeners();
  }

  Future<void> consultar(RequestProduto filtro) async {
    _filtro = filtro.copyWith(
      paginaAtual: filtro.paginaAtual,
      qtdTotal: filtro.qtdTotal,
      idFilial: filtro.idFilial,
    );
    _response = ResponseProduto.empty();
    await runAsync(() async {
      _response = await _service.consultar(
        baseUrl: _getBaseUrl(),
        request: _filtro,
      );
    });
  }

  Future<void> consultarMais() async {
    if (!temMaisPaginas || isLoading) return;
    await runAsync(() async {
      final proximaPagina = _response.proximaPagina.toString();
      final novaResposta = await _service.consultar(
        baseUrl: _getBaseUrl(),
        request: _filtro.copyWith(paginaAtual: proximaPagina),
      );
      _filtro = _filtro.copyWith(paginaAtual: proximaPagina);
      _response = _response.copyWith(
        itens: [..._response.itens, ...novaResposta.itens],
        paginaAtual: novaResposta.paginaAtual,
        proximaPagina: novaResposta.proximaPagina,
        qtdPaginas: novaResposta.qtdPaginas,
      );
    });
  }

  void selecionar(ProdutoModel produto) {
    _selecionado = produto;
    notifyListeners();
  }

  void limpar() {
    _response = ResponseProduto.empty();
    _filtro = RequestProduto.empty();
    _selecionado = ProdutoModel.empty();
    clearError();
  }
}
