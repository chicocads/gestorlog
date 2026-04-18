import '../core/controllers/base_controller.dart';
import '../models/diversos/parametro_model.dart';
import '../services/parametro_service.dart';

class ParametroController extends BaseController {
  ParametroController(this._service) {
    load();
  }

  final ParametroService _service;

  ParametroModel _parametro = ParametroModel.empty();

  ParametroModel get parametro => _parametro;

  Future<void> load() => runAsync(() async {
    _parametro = await _service.get();
  });

  Future<void> save(ParametroModel parametro) => runAsync(() async {
    await _service.save(parametro);
    _parametro = parametro;
  });

  Future<void> update(
    ParametroModel Function(ParametroModel current) updater,
  ) => save(updater(_parametro));
}
