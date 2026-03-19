import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:dbad/app.dart';
import 'package:dbad/data/services/categories_service.dart';
import 'package:dbad/data/services/flashcards_service.dart';
import 'package:dbad/providers/categories_provider.dart';
import 'package:dbad/screens/auth/login_screen.dart';
import 'package:dbad/theme/app_theme.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        final session = snapshot.data?.session;
        if (session == null) {
          return MaterialApp(
            title: 'DBAD',
            theme: AppTheme.darkTheme,
            debugShowCheckedModeBanner: false,
            home: const LoginScreen(),
          );
        }

        final client = Supabase.instance.client;
        return MultiProvider(
          providers: [
            Provider(create: (_) => CategoriesService(client)),
            Provider(create: (_) => FlashcardsService(client)),
            ChangeNotifierProvider(
              create: (ctx) => CategoriesProvider(
                ctx.read<CategoriesService>(),
              ),
            ),
          ],
          child: const App(),
        );
      },
    );
  }
}
