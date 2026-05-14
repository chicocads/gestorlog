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

**Local database**: SQLite via `sqflite`, accessed through the singleton `DatabaseHelper.instance` ([lib/core/database/database_helper.dart](lib/core/database/database_helper.dart)). Current schema version is **10**; migrations are additive `ALTER TABLE` operations. Tables: `Parametro`, `Produto`, `Separacao`, `Inventario`, `LoteSaida`.

**Service split**: Most business domains have two service classes — a `*LocalService` (reads/writes SQLite) and a `*RemoteService` or plain `*Service` (calls the REST API). Controllers receive both and orchestrate between them.

## Module overview

| Module | Domain |
|--------|--------|
| `separacao` | Order picking (pre-venda items) |
| `carga` | Truck load management and expenses |
| `entrega` | Delivery confirmation (hsaida = histórico saída, prevenda) |
| `inventario` | Stock count with barcode scanner |
| `auditoria` | Stock audit — product address and lot verification |
| `cadastro` | Master data: filial, produto, usuário |
| `parametro` | Device configuration (server URL, filial, PDA ID) stored in SQLite |

## Environment

The `.env` file (bundled as a Flutter asset) must be present at project root. It holds:
- `AUTH_API_CADS1` — Basic auth credentials for the main REST API
- Google Maps API keys (used by `geolocator`)

The server base URL is not hardcoded; it is stored in the local `Parametro` table and configured per-device via the Parâmetros screen.