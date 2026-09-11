# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

This project uses [FVM](https://fvm.app/) pinned to Flutter **3.41.6**. Prefix all Flutter commands with `fvm`:

```bash
fvm flutter run                        # run on connected device
fvm flutter build apk --release        # build Android APK
fvm flutter analyze                    # lint (flutter_lints)
fvm flutter test                       # run tests
fvm flutter test test/widget_test.dart # run a single test file
```

## Architecture

**Dependency injection**: `AppDependencies` (in [lib/app/routes.dart](lib/app/routes.dart)) constructs every service and controller once at startup. No Provider/Riverpod/GetX — dependencies flow via `AppScope`, a custom `InheritedWidget` that wraps the entire app. Controllers and services are passed directly to views via constructor parameters.

**State management**: All controllers extend `BaseController` ([lib/core/controllers/base_controller.dart](lib/core/controllers/base_controller.dart)), which extends `ChangeNotifier`. It exposes `isLoading`, `error`, and two helpers (`runAsync` / `runSync`) that handle the loading/error lifecycle automatically. Views listen with standard `ListenableBuilder` or `AnimatedBuilder`.

**Routing**: Named routes are resolved in `AppRoutes.onGenerateRoute` (a `switch` expression in [lib/app/routes.dart](lib/app/routes.dart)). To add a route, add a `static const` name and a `case` in the switch.

**HTTP layer**: `ApiClient` ([lib/core/http/api_client.dart](lib/core/http/api_client.dart)) is an abstract interface; `DioApiClient` ([lib/core/http/dio_client.dart](lib/core/http/dio_client.dart)) is the concrete implementation with `validateStatus: (_) => true` — it never throws on HTTP error status, callers must check `ApiResponse.isSuccess`. Auth credentials are read from `.env` via `AuthHeaders.basicFromEnv(envKey)`.

**Local database**: SQLite via `sqflite`, accessed through the singleton `DatabaseHelper.instance` ([lib/core/database/database_helper.dart](lib/core/database/database_helper.dart)). Current schema version is **11**; migrations are additive `ALTER TABLE` operations. Tables: `Parametro`, `Produto`, `Separacao`, `Inventario`, `LoteSaida`, `Usuario`, `Usuario2`.

**Service split**: Most business domains have two service classes — a `*LocalService` (reads/writes SQLite) and a `*RemoteService` or plain `*Service` (calls the REST API). Controllers receive both and orchestrate between them. Exception: `AuditoriaService` has no dedicated controller — views use the service directly via `AppScope`.

**Dependency graph** (`AppDependencies` in [lib/app/routes.dart](lib/app/routes.dart)):

| Service(s) | Controller |
|---|---|
| `ParametroService` | `ParametroController` |
| `UsuarioService` + `UsuarioLocalService` | `UsuarioController` |
| `PreVendaService` | `PreVendaController` |
| `SeparacaoLocalService` + `SeparacaoRemoteService` | `PvSeparacaoController` |
| `CargaService` | `CarregamentoController` |
| `CargaDespesaService` | _(used directly by views)_ |
| `HSaidaService` + `CargaService` | `HSaidaController` |
| `FilialService` | `FilialController` |
| `ProdutoService` | `ProdutoController` |
| `AuditoriaService` | _(no controller — used directly by views)_ |

## Module overview

| Module | Domain |
|--------|--------|
| `separacao` | Order picking (pre-venda items) |
| `carga` | Truck load management and expenses |
| `entrega` | Delivery confirmation (hsaida = histórico saída, prevenda) |
| `inventario` | Stock count with barcode scanner — 4 tabs: coleta, coletados, produtos, total |
| `auditoria` | Stock audit — 4 tabs: ficha, endereço, dados físicos (peso), lotes; requests: alterar barra, endereço produto, dado físico produto; inclui busca de produto por código (`auditoria_produto_search_bottom_sheet.dart`) |
| `cadastro` | Master data: filial, produto, usuário (with `usu_flag01`–`usu_flag30` permissions) |
| `parametro` | Device configuration (server URL, filial, PDA ID, frota, inventário, decimais) stored in SQLite |

> **Nota sobre `entrega`**: nas camadas `controllers/`, `services/` e `models/` esse "módulo" é, na verdade, dois módulos separados — `hsaida/` e `prevenda/` — unificados apenas em `views/entrega/`. Ao procurar código de entrega, busque por `HSaidaController`/`HSaidaService` e `PreVendaController`/`PreVendaService`, não por `entrega_*`.
>
> **Serviços parciais**: `services/cadastro/cliente/` e `services/cadastro/colaborador/` só têm `request_*`/`response_*` (sem `*_service.dart` correspondente) — funcionalidade ainda em construção, não wire-ada em `AppDependencies`.
>
> **Itens cancelados na separação**: `PreVenda2Model.cancelado` deriva de `status == 1` (setado no backend por `CancelarItemWithTx`, `DELETE /prevenda/item/...`). `PvSeparacaoItensView` bloqueia a separação de itens já cancelados no carregamento e, ao finalizar (`_confirmarFinalizarSeparacao`), rebusca a pré-venda via `PreVendaService.buscar` para detectar cancelamentos ocorridos depois que a lista foi carregada, avisando o usuário antes de prosseguir. `PvSeparacaoItemCard` usa `_bloqueado` (`item.cancelado || romaneio == 2`) para desabilitar os campos do card.

## Rotas

| Rota | View |
|---|---|
| `/` | `LoginView` |
| `/home` | `HomeView` |
| `/parametros` | `ParametroView` |
| `/pre-vendas` | `PvSeparacaoListView` |
| `/entrega-carga` | `CargaListView` |
| `/separacao-carga` | `PvSeparacaoListView` |
| `/inventario` | `InventarioView` |
| `/auditoria-estoque` | `AuditoriaView` |
| `/produtos` | `ProdutoView` |

## main.dart

`WidgetsFlutterBinding.ensureInitialized()` e todo o código de bootstrap ficam **dentro** do `runZonedGuarded` para evitar zone mismatch:

```dart
Future<void> main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    // ...setup...
    runApp(const App());
  }, (error, stack) { debugPrint(...); });
}
```

## Environment

The `.env` file (bundled as a Flutter asset) must be present at project root. It holds:
- `AUTH_API_CADS1` — Basic auth credentials for the main REST API (used via `AuthHeaders.basicCads1()`)
- `AUTH_API_CADS2` — present in `.env` but not referenced anywhere in code yet (reserved)
- `ANDROID_MAPS_APIKEY`, `ANDROID_MAPS_ROUTE_APIKEY`, `IOS_MAPS_APIKEY` — Google Maps keys (used by `geolocator`)

The server base URL is not hardcoded; it is stored in the local `Parametro` table and configured per-device via the Parâmetros screen.

## Testing

Only `test/widget_test.dart` exists (the default Flutter template smoke test). There is no domain-level test coverage (controllers, services, database) — don't assume existing tests when changing business logic.