import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ryou_app/features/auth/presentation/controllers/sign_up_controller.dart';
import 'package:ryou_app/features/auth/presentation/views/sign_in_screen.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() {
    return _SignUpScreenState();
  }
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  var _obscureText = true;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _valideForm(String name, String email, String password) async {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      await ref.read(signUpControllerProvider.notifier).signUp(name, email, password);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSignUp = ref.watch(signUpControllerProvider);

    ref.listen(signUpControllerProvider, (previous, next) {
      if (next is AsyncError && !next.isLoading) {
        final error = next.error;
        final message = switch(error) {
          FirebaseAuthException(code: 'email-already-in-use') => "Cet email est déjà utilisé",
          FirebaseAuthException(code: 'weak-password') => "Mot de passe trop faible",
          FirebaseAuthException(code: 'invalid-email') => "Adresse email invalide",
          FirebaseAuthException(code: 'network-request-failed') => "Erreur réseau",
          FirebaseException() => "Impossible de créer ton profil, réessaie",
          TimeoutException() => "Conneion trop lente, réessaie",
          _ => "Oups erreur..."
        };
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Erreur : $message")));
      }
    });

    return Scaffold(
      // Le clavier passe par-dessus les boutons au lieu de les faire remonter.
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset('assets/images/ryou_logo2.png', height: 100),
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
                  'Créons ton compte',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text('Trente secondes, promis'),
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
                        // Valide ce champ dès qu'on y tape, sans toucher aux autres.
                        autovalidateMode: AutovalidateMode.onUnfocus,
                        controller: _nameController,
                        onTapOutside: (_) {
                          FocusScope.of(context).unfocus();
                        },
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Vous devez entrer un prenom !';
                          }
                          return null;
                        },
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(labelText: 'Prénom'),
                      ),
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
                        onTapOutside: (_) {
                          FocusScope.of(context).unfocus();
                        },
                        controller: _passwordController,
                        autovalidateMode: AutovalidateMode.onUnfocus,
                        validator: (value) {
                          if (value == null ||
                              value.trim().isEmpty ||
                              value.length < 6) {
                            return 'Mot de passe non valide !';
                          }
                          return null;
                        },
                        obscureText: _obscureText,
                        onFieldSubmitted: (_) => _valideForm(
                          _nameController.text,
                          _emailController.text,
                          _passwordController.text,
                        ),
                        textInputAction: TextInputAction.done,
                        autocorrect: false,
                        enableSuggestions: false,
                        autofillHints: const [AutofillHints.newPassword],
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
                  onPressed: isSignUp.isLoading
                      ? null
                      : () => _valideForm(
                          _nameController.text,
                          _emailController.text,
                          _passwordController.text,
                        ),
                  child: isSignUp.isLoading
                      ? Center(child: CircularProgressIndicator())
                      : const Text('Créer mon compte'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Déjà un compte ?'),
                    TextButton(
                      onPressed: () {
                        if (Navigator.canPop(context)) {
                          Navigator.of(context).pop();
                        } else {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (ctx) => const SignInScreen(),
                            ),
                          );
                        }
                      },
                      child: Text(
                        "Se connecter",
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
