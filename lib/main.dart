import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app.dart';
import 'repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // FIX 1: Pass the names of the environment variables here
  const url = String.fromEnvironment('SUPABASE_URL');
  const key = String.fromEnvironment('SUPABASE_ANON_KEY');

  final validKey = key.startsWith('sb_publishable_') || key.startsWith('eyJ');

  if (url.isEmpty || key.isEmpty || url.contains('YOUR_') || key.contains('YOUR_') || !validKey) {
    runApp(const _MessageApp(
      'Add your Supabase URL and publishable key to config/app.json, then rebuild the app. '
      'Never use a database password or secret key here.',
    ));
    return;
  }

  try {
    await Supabase.initialize(
      url: url,
      anonKey: key, // FIX 2: Change publishableKey to anonKey
      authOptions: const FlutterAuthClientOptions(
        localStorage: EmptyLocalStorage(), // no session persistence
        detectSessionInUri: false,
      ),
    );
    runApp(
      StudentApp(
        repository: SupabaseStudentRepository(Supabase.instance.client),
      ),
    );
  } catch (_) {
    runApp(const _MessageApp(
      'The app could not start. Check config/app.json and your connection, then refresh.',
    ));
  }
}

class _MessageApp extends StatelessWidget {
  const _MessageApp(this.message);
  final String message;

  @override
  Widget build(BuildContext context) => MaterialApp(
        home: Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(message),
            ),
          ),
        ),
      );
}