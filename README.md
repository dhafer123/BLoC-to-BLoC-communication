# Shelf

Shelf is a small Flutter book-tracking app built to demonstrate communication
between independent BLoCs while keeping features separated with clean
architecture.

## What The App Does

- Signs a mock reader in and out
- Displays a small catalog of books
- Adds and removes books from a personal shelf
- Shows live online/offline status
- Allows the shelf to be borrowed only when it contains books and the device
  is online
- Clears the shelf automatically when the reader signs out

## Architecture

The project uses a feature-first clean architecture. Each feature is split
into data, domain, and presentation responsibilities:

```text
lib/
  app.dart                         Composition root and BLoC providers
  main.dart                        Application entrypoint
  core/
    di/injection.dart              get_it dependency registration
    theme/app_theme.dart            Material 3 light/dark themes
  features/
    auth/
      data/                         Mock data source and repository
      domain/                       User entity and repository contract
      presentation/bloc/            AuthBloc, events, and states
    connectivity/
      data/                         connectivity_plus repository adapter
      domain/                       Connectivity repository contract
      presentation/bloc/            ConnectivityBloc
    shelf/
      data/                         In-memory book catalog
      domain/                       Book entity and repository contract
      presentation/bloc/            ShelfBloc
      presentation/pages/           Catalog screen
    checkout/
      presentation/bloc/            CheckoutBloc and derived checkout state
```

### Layer Responsibilities

- **Data** implements repository contracts and adapts external or mock data
  sources.
- **Domain** contains entities and repository interfaces owned by each
  feature.
- **Presentation** contains Flutter widgets and BLoCs that coordinate user
  interaction and visual state.
- **Core** contains cross-cutting configuration such as dependency injection
  and theming.

Dependencies point inward: the presentation layer depends on domain
contracts, while data provides their implementations. `app.dart` wires the
concrete implementations together through constructor injection.

## BLoC-to-BLoC Communication

The app demonstrates two practical communication patterns without having one
BLoC access another BLoC's internal methods or state management logic.

### AuthBloc -> ShelfBloc

`ShelfBloc` receives `AuthBloc` through its constructor and subscribes to its
public stream. When an `AuthSignedOut` state is emitted, `ShelfBloc` adds its
own internal `ShelfCleared` event. The subscription is cancelled in `close()`.

This keeps the sign-out side effect testable and makes `ShelfBloc` responsible
for its own state transition.

### ShelfBloc + ConnectivityBloc -> CheckoutBloc

`CheckoutBloc` receives both dependencies through its constructor. It listens
to their public streams and adds `CheckoutDependenciesChanged` whenever either
dependency changes. Its derived state exposes:

- `itemCount`
- `isOnline`
- `canCheckout`
- `isSubmitting`
- `completed`

Checkout is allowed only when the shelf is non-empty, the device is online, and
no checkout request is already running.

## Technology Used

### Runtime

- **Flutter** — UI toolkit
- **Dart** — application language
- **flutter_bloc** — BLoC implementation and provider widgets
- **equatable** — value equality for entities, events, and states
- **connectivity_plus** — device connectivity stream
- **get_it** — service locator used only at the composition root

### Presentation

- **Material 3** — component system and color schemes
- **google_fonts** — DM Sans body typography and DM Serif Display headings
- **flutter_animate** — entrance and state transition animations
- Responsive `SliverGrid` catalog layout
- System light/dark theme support
- Material 3 `Badge` for the shelf count
- Safe-area-aware checkout bar for mobile navigation controls

### Testing and Quality

- **flutter_test** — widget tests
- **bloc_test** — BLoC testing utilities
- **mocktail** — test doubles
- `flutter analyze` — static analysis
- `dart format` — source formatting

## Running The Project

```sh
flutter pub get
flutter run
```

## Validation

```sh
flutter analyze
flutter test
flutter build apk --debug
```

The tests cover the cross-BLoC behaviors that define the project:

- signing out clears the shelf
- connectivity changes recompute checkout eligibility
- the catalog screen renders successfully
