import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ryou_app/features/auth/presentation/controllers/sign_in_controller.dart';
import 'package:ryou_app/features/auth/presentation/views/sign_up_screen.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _SignInScreenState();
  }
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  var _obscureText = true;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void valideForm() async {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      await ref
          .read(signInControllerProvider.notifier)
          .signIn(_emailController.text, _passwordController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final signInState = ref.watch(signInControllerProvider);

    ref.listen(signInControllerProvider, (previous, next) {
      if (next.hasError && !next.isLoading) {
        final message = switch (next.error) {
          FirebaseAuthException(code: 'network-request-failed') =>
            'Pas de connexion internet. Vérifie ton réseau.',
          FirebaseAuthException(
            code: 'invalid-credential' || 'wrong-password' || 'user-not-found',
          ) =>
            'Email ou mot de passe incorrect',
          FirebaseAuthException(code: 'too-many-requests') =>
            'Trop de tentatives. Réessaie dans quelques minutes.',
          FirebaseAuthException(code: 'user-disabled') =>
            'Ce compte a été désactivé.',
          TimeoutException() =>
            'La connexion prend trop de temps. Vérifie ton réseau.',
          _ => 'Une erreur est survenue, réessaie.',
        };

        ScaffoldMessenger.of(context)
          ..clearSnackBars()
          ..showSnackBar(SnackBar(content: Text(message)));
      }
    });
    return Scaffold(
      // Le clavier passe par-dessus les boutons au lieu de les faire remonter.
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset('assets/images/ryou_wordmark.png', height: 100),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          spacing: 35,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Content de te revoir',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text('Ryou a gardé ta place au chaud'),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                // Place pour défiler au-dessus du clavier.
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: Form(
                  key: _formKey,
                  child: Column(
                    spacing: 40,
                    children: [
                      TextFormField(
                        controller: _emailController,
                        autovalidateMode: AutovalidateMode.onUnfocus,
                        onTapOutside: (_) {
                          FocusScope.of(context).unfocus();
                        },
                        validator: (value) {
                          if (value == null ||
                              value.trim().isEmpty ||
                              !value.contains('@')) {
                            return "Cette adresse email semble incomplète !";
                          }
                          return null;
                        },
                        keyboardType: TextInputType.emailAddress,
                        autocorrect: false,
                        enableSuggestions: false,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(labelText: 'Email'),
                      ),
                      TextFormField(
                        controller: _passwordController,
                        onTapOutside: (_) {
                          FocusScope.of(context).unfocus();
                        },
                        autovalidateMode: AutovalidateMode.onUnfocus,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Entre ton mot de passe !';
                          }
                          return null;
                        },
                        obscureText: _obscureText,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => valideForm(),
                        autocorrect: false,
                        enableSuggestions: false,
                        autofillHints: const [AutofillHints.password],
                        decoration: InputDecoration(
                          labelText: 'Mot de passe',
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() => _obscureText = !_obscureText);
                            },
                            icon: Platform.isIOS
                                ? Icon(
                                    _obscureText
                                        ? CupertinoIcons.eye_slash
                                        : CupertinoIcons.eye,
                                  )
                                : Icon(
                                    _obscureText
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                          ),
                        ),
                        keyboardType: TextInputType.visiblePassword,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Column(
              spacing: 10,
              children: [
                FilledButton(
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(58),
                  ),
                  onPressed: signInState.isLoading ? null : valideForm,
                  child: signInState.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : const Text('Se connecter'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Pas encore de compte ?'),
                    TextButton(
                      onPressed: () {
                        if (Navigator.canPop(context)) {
                          Navigator.of(context).pop();
                        } else {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (ctx) => const SignUpScreen(),
                            ),
                          );
                        }
                      },
                      child: Text(
                        "S'inscrire",
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
