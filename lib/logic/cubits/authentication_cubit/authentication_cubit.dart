import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:smart_garage_final_project/cached/cache_helper.dart';
import 'package:smart_garage_final_project/core/utils/keys_manager.dart';
import 'package:smart_garage_final_project/firebase/firebase_auth_consumer.dart';

part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  AuthenticationCubit() : super(AuthenticationInitial());

  createNewAccount({required String email, required String password}) async {
    emit(AuthenticationLoading());
    final result = await FirebaseAuthConsumer.createNewAccount(
      email: email,
      password: password,
    );
    result.fold(
      (ifLeft) => emit(AuthenticationError(errorMessage: ifLeft)),
      (ifRight) => emit(AuthenticationSuccess(message: ifRight)),
    );
  }
  //!========================================================================================

  signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    emit(AuthenticationLoading());
    final result = await FirebaseAuthConsumer.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return result.fold(
      (result) => emit(AuthenticationError(errorMessage: result)),
      (result) {
        CachedData.setData(key: KeysManager.signInMethod, value: 'email');
        emit(AuthenticationSuccess(message: result));
      },
    );
  }
  //!========================================================================================

  signOut() async {
    emit(LoggingOutLoading());

    String signInMethod = CachedData.getData(key: KeysManager.signInMethod);

    switch (signInMethod) {
      case 'email':
        await FirebaseAuthConsumer.signOut();
        break;
      case 'google':
        await FirebaseAuthConsumer.signOutFromGoogle();
        break;
      case 'facebook':
        await FirebaseAuthConsumer.signOutFromFacebook();
        await FirebaseAuthConsumer.signOut(); // manually sign out from Firebase
        break;
      default:
        break;
    }
    Future.delayed(
      Duration(seconds: 2),
    ).then((value) => emit(LoggingOutSuccess()));
  }

  //!========================================================================================
  sendResetPasswordMail({required String email}) async {
    emit(ResetPasswordMailSentLoading());
    final result = await FirebaseAuthConsumer.sendResetPasswordMail(email);
    result.fold(
      (ifLeft) => emit(ResetPasswordMailSentFailed(errorMessage: ifLeft)),
      (ifRight) => emit(ResetPasswordMailSentSuccess(message: ifRight)),
    );
  }

  //!========================================================================================
  Future<void> signInWithGoogle() async {
    emit(GoogleSignInLoading());
    final userCredential = await FirebaseAuthConsumer.signInWithGoogle();
    Future.delayed(Duration(seconds: 2)).then(
      (value) => userCredential.fold(
        (ifLeft) => emit(GoogleSignInFailed(errorMessage: ifLeft.toString())),
        (ifRight) {
          CachedData.setData(key: KeysManager.signInMethod, value: 'google');
          emit(GoogleSignInSuccess());
        },
      ),
    );
  }

  Future<void> signInWithFacebook() async {
    emit(FacebookSignInLoading());
    final userCredential = await FirebaseAuthConsumer.signInWithFacebook();
    Future.delayed(Duration(seconds: 2)).then(
      (value) => userCredential.fold(
        (ifLeft) => emit(FacebookSignInFailed(errorMessage: ifLeft.toString())),
        (ifRight) {
          CachedData.setData(key: KeysManager.signInMethod, value: 'facebook');
          emit(FacebookSignInSuccess());
        },
      ),
    );
  }
}
