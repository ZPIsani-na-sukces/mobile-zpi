# mobile-zpi

Aplikacja mobilna Flutter dla projektu ZPI (ZPIsani na sukces).

## Wymagania

- [FVM](https://fvm.app/) — Flutter **3.47.2**
- Xcode (iOS) / Android SDK (Android)

## Setup

```sh
fvm install
fvm flutter pub get
fvm flutter run
```

IDE (VS Code / Cursor) powinno automatycznie użyć SDK z `.fvm/flutter_sdk`.

## Linter

Reguły są w `analysis_options.yaml` (`flutter_lints` + `riverpod_lint` + strict modes).

#### Analiza kodu - błędy, ostrzeżenia i lints:

```sh
fvm flutter analyze
```

#### Podgląd automatycznych poprawek

```sh
fvm dart fix --dry-run
```

#### Zastosowanie automatycznych poprawek

```sh
fvm dart fix --apply
```

#### Podgląd formatowania (bez zmian w plikach)

```sh
fvm dart format --output=none --set-exit-if-changed .
```

#### Formatowanie kodu

```sh
fvm dart format .
```
