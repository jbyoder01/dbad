# DBAD (Don't Be a Dumbass)

A minimal flashcard app built with Flutter. Create categories, add flashcards, and quiz yourself with a 3D card-flip game mode.

## Features

- **Categories** — organize flashcards into named groups
- **Flashcards** — create, edit, and delete question/answer pairs
- **Game mode** — shuffled cards with a 3D flip animation, progress counter, and completion screen
- **Search** — filter categories and flashcards by name/content
- **Slide-to-delete** — swipe categories to reveal a delete action
- **Dark theme** — Material 3 dark theme with blue accent

## Tech Stack

- **Database**: Drift (SQLite) with code generation
- **Routing**: go_router (nested routes)
- **State management**: Provider + ChangeNotifier with stream subscriptions
- **UI**: Material 3, flutter_slidable

## Project Structure

```
lib/
  main.dart              # App entry, provider wiring
  app.dart               # MaterialApp.router config
  router.dart            # GoRouter route definitions
  data/
    database.dart        # Drift database definition
    tables/              # Drift table schemas
    daos/                # Data access objects (CRUD + streams)
  providers/
    categories_provider.dart
    flashcards_provider.dart
    game_provider.dart
  screens/
    home/                # Category list + search + create dialog
    category/            # Flashcard list + start game
    flashcard/           # Create/edit flashcard form
    game/                # Card flip game + completion
  theme/
    app_theme.dart       # Dark theme config
```

## Setup

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

After modifying Drift tables or DAOs, re-run the `build_runner` command to regenerate `.g.dart` files.

## TODO

- Add error handling for async database operations (deletes, creates, updates) — currently fire-and-forget, which would be a problem with a remote DB
