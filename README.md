# DBAD (Don't Be a Dumbass)

A minimal flashcard app built with Flutter. Create categories, add flashcards, and quiz yourself with a 3D card-flip game mode. Data is stored in Supabase for multi-device sync and cloud backup.

## Features

- **Categories** — organize flashcards into named groups
- **Flashcards** — create, edit, and delete question/answer pairs
- **Game mode** — shuffled cards with a 3D flip animation, progress counter, and completion screen
- **Search** — filter categories and flashcards by name/content
- **Slide-to-delete** — swipe categories to reveal a delete action
- **Dark theme** — Material 3 dark theme with blue accent
- **Multi-device sync** — create cards on one device, study on another
- **Auth** — email/password sign-in via Supabase Auth

## Tech Stack

- **Backend**: Supabase (Postgres + Auth + RLS)
- **Routing**: go_router (nested routes)
- **State management**: Provider + ChangeNotifier with fetch-and-refresh
- **UI**: Material 3, flutter_slidable

## Project Structure

```
lib/
  main.dart              # App entry, Supabase init
  app.dart               # MaterialApp.router config
  auth_gate.dart         # Auth state gate (login vs main app)
  router.dart            # GoRouter route definitions
  data/
    models/              # Category and Flashcard data classes
    services/            # Supabase CRUD service classes
  providers/
    categories_provider.dart
    flashcards_provider.dart
    game_provider.dart
  screens/
    auth/                # Login screen
    home/                # Category list + search + create dialog
    category/            # Flashcard list + start game
    flashcard/           # Create/edit flashcard form
    game/                # Card flip game + completion
  theme/
    app_theme.dart       # Dark theme config
```

## Setup

1. Create a Supabase project and run the migration in `supabase/migrations/` via `supabase db push`
2. Create a user in the Supabase dashboard (Authentication > Users)
3. Copy `dart_defines.example.json` to `dart_defines.json` and fill in your Supabase URL and publishable key
4. Run `flutter pub get`

### Running in VS Code

Use the **Run and Debug** sidebar (or press `F5`) and select the "DBAD" configuration. Do not use the inline "Run" / "Debug" buttons above `main()` — those don't load the Supabase credentials. Select the device to run on from the **Flutter** sidebar.

### Building a release version

**Android** (connect phone via USB):
```bash
flutter build apk --release --dart-define-from-file=dart_defines.json
flutter install --release
```

**macOS**:
```bash
flutter build macos --release --dart-define-from-file=dart_defines.json
```
Then install to Applications:
```bash
cp -r build/macos/Build/Products/Release/dbad.app /Applications/
```
Re-running this will overwrite the previous install.

## TODO

### Error handling for Supabase operations

No async methods across any service or provider class have error handling. Failed network requests (no internet, server errors, RLS violations) bubble up as unhandled `PostgrestException`s. The app silently fails or crashes. Additionally, `_loadData()` in both `CategoriesProvider` and `FlashcardsProvider` sets `_isLoading = true` at the start but never resets it to `false` if an exception is thrown, leaving the UI stuck in a loading state on failure.

Can be addressed using a `Result` object pattern with success/error states, as described in the [Flutter docs](https://docs.flutter.dev/app-architecture/design-patterns/result).

**Files:** All 3 providers, `home_screen.dart`, `category_screen.dart`, `game_screen.dart`

### Realtime updates + offline support

These are best implemented together. Realtime keeps data fresh across devices; offline support requires a local cache — and once you have a local cache, realtime is how you keep it in sync with the server.

**Plan:**
1. **Re-add Drift/SQLite as a local cache** — same schema as Supabase, but without `user_id` (single user locally). This gives instant reads and offline access.
2. **Create a repository layer** between providers and services that coordinates local + remote:
   - Reads come from the local DB (fast, works offline)
   - Writes go to Supabase first, then update the local DB on success
   - If offline, queue writes locally and sync when connectivity returns
3. **Subscribe to Supabase Realtime** channels for `categories` and `flashcards` tables. When a change arrives (e.g., a card created on another device), update the local DB and notify providers.
4. **Add a connectivity listener** (`connectivity_plus` package) to detect online/offline state and trigger sync of queued mutations when connectivity is restored.
5. **Conflict resolution** — last-write-wins using `updated_at` timestamps. For a single-user app, conflicts are rare (only if you edit the same card on two devices while one is offline).
6. **Providers switch back to streams** — Drift's `.watch()` on the local DB gives reactive UI updates again, now backed by a local cache that stays in sync via Realtime.

**New packages:** `drift`, `sqlite3_flutter_libs`, `connectivity_plus`

**New files:**
- `lib/data/repositories/categories_repository.dart`
- `lib/data/repositories/flashcards_repository.dart`
- `lib/data/local/` — local Drift database (cache)
- `lib/data/sync/` — sync engine + mutation queue

**Files modified:** All 3 providers (back to stream-based), `main.dart` (init local DB + Realtime subscriptions), `pubspec.yaml`
