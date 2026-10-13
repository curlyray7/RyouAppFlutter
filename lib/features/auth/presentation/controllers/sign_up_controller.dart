import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ryou_app/features/auth/data/auth_repository.dart';

class SignUpController extends AsyncNotifier<void> {
  @override
  FutureOr<dynamic> build() {}

  Future<void> signUp(String name, String email, String password) async {
    state = const AsyncLoading();
    final result = await AsyncValue.guard(() async {
      await ref.read(authRepositoryProvider).signUp(name, email, password);
    });
    if (ref.mounted) state = result;
  }

}

final signUpControllerProvider = AsyncNotifierProvider.autoDispose<SignUpController, void>(SignUpController.new);
