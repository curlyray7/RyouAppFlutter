import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ryou_app/features/auth/data/auth_repository.dart';

class SignInController extends AsyncNotifier<void>{
  @override
  FutureOr<dynamic> build() {}

  Future<void> signIn(String email, String password) async{
    state = const AsyncLoading();
    final result = await AsyncValue.guard(() => ref.read(authRepositoryProvider).signIn(email, password));
    if(ref.mounted) state = result;
  }

}

final signInControllerProvider = AsyncNotifierProvider.autoDispose<SignInController,void>(SignInController.new);