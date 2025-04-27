import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
      (result) => emit(AuthenticationSuccess(message: result)),
    );
  }
  //!========================================================================================

  signOut() {
    emit(LoggingOutLoading());
    FirebaseAuthConsumer.signOutFromGoogle();
    FirebaseAuthConsumer.signOut();
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
    userCredential.fold(
      (ifLeft) => emit(GoogleSignInFailed(errorMessage: ifLeft.toString())),
      (ifRight) => emit(GoogleSignInSuccess()),
    );
    // log('type is ${userCredential.runtimeType.toString()}');
    // if (userCredential is Future<UserCredential>) {
    //   return emit(GoogleSignInSuccess());
    // } else {
    //   return emit(GoogleSignInFailed());
    // }
  }

  // signInWithGoogle() {
  //   emit(GoogleSignInLoading());
  //   FirebaseAuthConsumer.signInWithGoogle().then((value) {
  //     if (value != null) {
  //       emit(GoogleSignInSuccess());
  //     } else {
  //       emit(GoogleSignInFailed());
  //     }
  //   });
  // }
}
