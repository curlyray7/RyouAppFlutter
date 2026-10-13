import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ryou_app/core/firebase/firebase_providers.dart';

class AuthRepository {
  const AuthRepository(this._auth, this._firestore);

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  Future<void> signIn(String email, String password) {
    return _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  Future<void> signUp(String name, String email, String password) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    final user = credential.user!;
    try {
      await _firestore
          .collection("User")
          .doc(user.uid)
          .set({
            "Nom": name.trim(),
            "email": email.trim(),
            "createdAt": FieldValue.serverTimestamp(),
          })
          .timeout(const Duration(seconds: 10));
    } catch (_) {
      // Sans profil Firestore le compte est inutilisable : on annule l'inscription.
      try {
        await user.delete();
      } catch (_) {
        await _auth.signOut();
      }
      rethrow;
    }
  }

  Future<void> signOut() => _auth.signOut();
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final firebaseAuthInstance = ref.watch(firebaseAuthProvider);
  final firestoreInstance = ref.watch(firestoreProvider);
  return AuthRepository(firebaseAuthInstance, firestoreInstance);
});
