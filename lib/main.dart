import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ryou_app/core/firebase/firebase_providers.dart';
import 'package:ryou_app/features/auth/presentation/controllers/sign_up_controller.dart';
import 'package:ryou_app/features/auth/presentation/views/sign_up_screen.dart';
import 'package:ryou_app/features/home/presentation/home_screen.dart';

import 'core/theme/app_theme.dart';
import 'firebase_options.dart';


void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp( const ProviderScope(child: MainApp()) );
}


class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    ref.listen(authStateProvider, ((previous, next) {
      if(previous!.value == null && next.value is User) {
        Navigator.popUntil(context, ((route) => route.isFirst));
      }
    }));

    final authState = ref.watch(authStateProvider);
    final isSigningUp = ref.watch(signUpControllerProvider).isLoading;
    return authState.when(
      data: (user) =>
          user == null || isSigningUp ? SignUpScreen() : HomeScreen(),
      error: (_,_) => SignUpScreen(), 
      loading: () => Center(child: CircularProgressIndicator()) 
    );
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      home: AuthGate(),
    );
  }
}
