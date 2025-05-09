import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'app/go_park_app.dart';
import 'cached/cache_helper.dart';
import 'core/utils/device/device_utility.dart';
import 'firebase/firebase_auth_consumer.dart';
import 'observer/bloc_observer.dart';

void main() async {
  //TODO DI
  WidgetsFlutterBinding.ensureInitialized();
  // setupDI();
  Bloc.observer = MyBlocObserver();
  await CachedData.cacheInitialization(); //initialize cache
  DeviceUtility.firebaseInitialization();
  DeviceUtility.hideStatusBar();
  DeviceUtility.lockOrientation();
  runApp(SmartGarage());
}
