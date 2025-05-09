import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_error_handler.dart';

class FirebaseAuthConsumer {
  //!========================================================================================

  static trackAuthenticationState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        log('User is currently signed out!');
      } else {
        log('User is signed in!');
      }
    });
  }
  //!========================================================================================

  static Future<Either<String, String>> createNewAccount({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: email.trim(),
            password: password.trim(),
          );
      sendVerificationMail();
      return Right('Account created successfully, please verify your email.');
    } on FirebaseException catch (e) {
      log(e.code);
      log(e.runtimeType.toString());
      return Left(FirebaseErrorHandler.handle(e.code));
    } on Exception catch (e) {
      log(e.runtimeType.toString());
      return Left(FirebaseErrorHandler.handle(e));
    }
  }

  //!========================================================================================
  static Future<Either<String, dynamic>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      if (!FirebaseAuth.instance.currentUser!.emailVerified) {
        return Right('Please verify your email before signing in.');
      }

      return Right(null);
    } on FirebaseException catch (e) {
      log(e.code);
      log(e.runtimeType.toString());
      return Left(FirebaseErrorHandler.handle(e.code));
    } on Exception catch (e) {
      log(e.runtimeType.toString());
      return Left(FirebaseErrorHandler.handle(e));
    }
  }

  //!========================================================================================

  static signOutEmailPasswordMethod() async {
    await FirebaseAuth.instance.signOut();
  }

  static Future<bool> sendVerificationMail() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
      return true;
    }
    return false;
  }

  //!========================================================================================

  static Future<Either<String, String>> sendResetPasswordMail(
    String email,
  ) async {
    if (email.isNotEmpty) {
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email.trim());
        return Right('Please check your email to reset your password.');
      } on FirebaseException catch (e) {
        return Left(FirebaseErrorHandler.handle(e.code));
      }
    } else {
      return Left('Please enter your email address.');
    }
  }

  //!========================================================================================
  static bool isUserAuthorized() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;

    // Check the provider
    final providerId =
        user.providerData.isNotEmpty ? user.providerData[0].providerId : '';

    if (providerId == 'password') {
      // If signed up with email/password, require email verification
      return user.emailVerified;
    } else {
      // If signed up with Facebook, Google, etc., assume authorized
      return true;
    }
  }

  //!========================================================================================

  static Future<Either<dynamic, UserCredential>> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      //if the user get back and didn't  choose any email
      if (googleUser == null) {
        return Left(false); //indication that authentication doesn't completed
      }
      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return Right(
        await FirebaseAuth.instance.signInWithCredential(credential),
      );
    } on PlatformException catch (e) {
      log('Google Sign-In Error: ${e.code}');
      return Left(FirebaseErrorHandler.handle(e.code));
    } catch (e) {
      log('Google Sign-In Error: $e');
      return Left(e);
    }
  }

  //!========================================================================================
  static signOutFromGoogle() async {
    try {
      await GoogleSignIn().signOut();
    } catch (e) {
      log(e.toString());
    }
  }

  //!========================================================================================
  static Future<Either<String, UserCredential>> signInWithFacebook() async {
    try {
      // Trigger the Facebook login flow
      final LoginResult result = await FacebookAuth.instance.login();

      // Handle login status
      switch (result.status) {
        case LoginStatus.cancelled:
          return Left('Facebook login cancelled by user');
        case LoginStatus.failed:
          return Left('Facebook login failed');
        case LoginStatus.success:
          // Get the access token - works with different package versions
          final String? accessToken =
              result.accessToken?.tokenString ??
              result.accessToken?.tokenString;

          if (accessToken == null) {
            return Left('Failed to retrieve Facebook access token');
          }

          // Create Facebook credential
          final OAuthCredential credential = FacebookAuthProvider.credential(
            accessToken,
          );

          // Sign in to Firebase with Facebook credential
          final UserCredential userCredential = await FirebaseAuth.instance
              .signInWithCredential(credential);

          return Right(userCredential);
        default:
          return Left('Unknown Facebook login error');
      }
    } on FirebaseAuthException catch (e) {
      log('Facebook Sign-In Error: ${e.code}');
      return Left(FirebaseErrorHandler.handle(e.code));
    } on PlatformException catch (e) {
      log('Facebook Sign-In Error: ${e.code}');
      return Left(FirebaseErrorHandler.handle(e.code));
    } catch (e) {
      log('Facebook Sign-In Error: $e');
      return Left(FirebaseErrorHandler.handle(e));
    }
  }

  //!========================================================================================
  static signOutFromFacebook() async {
    await FacebookAuth.instance.logOut();
  }

  //!========================================================================================
 
}
