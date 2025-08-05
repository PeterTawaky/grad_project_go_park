import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';
import '../cached/cache_helper.dart';
import '../core/utils/keys_manager.dart';
import '../model/park_area_model.dart';
import '../core/routes/app_routes.dart';
import '../core/utils/theme/colors_manager.dart';
import '../core/utils/theme/fonts_manager.dart';
import '../firebase/firebase_auth_consumer.dart';
import 'go_park_screen.dart';

class LocalAuthenticationScreen extends StatefulWidget {
  const LocalAuthenticationScreen({super.key});

  @override
  State<LocalAuthenticationScreen> createState() =>
      _LocalAuthenticationScreenState();
}

class _LocalAuthenticationScreenState extends State<LocalAuthenticationScreen> {
  final LocalAuthentication auth = LocalAuthentication();

  Future<bool?> _activeFingerPrintAuth() async {
    try {
      final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;

      if (canAuthenticateWithBiometrics) {
        bool didAuth = false;

        while (!didAuth) {
          didAuth = await auth.authenticate(
            localizedReason: 'Please authenticate Tawaky',
            options: AuthenticationOptions(
              biometricOnly: true, // Use fingerprint only
              stickyAuth: true, // Prevent authentication dismissal
            ),
          );
        }

        return didAuth;
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  _ensureUserValidity() async {
    final bool? userIsValid = await _activeFingerPrintAuth();
    if (userIsValid != null && userIsValid) {
      if (FirebaseAuthConsumer.isUserAuthorized()) {
        if (CachedData.getData(key: KeysManager.userIsUsingService) == null) {
          CachedData.setData(key: KeysManager.userIsUsingService, value: false);
        } else {
          if (CachedData.getData(key: KeysManager.userIsUsingService)) {
            context.pushReplacementNamed(
              AppRoutes.profileScreen,
              extra: ParkAreaModel(
                id: CachedData.getData(key: KeysManager.id),
                floor: CachedData.getData(key: KeysManager.floor),
                zone: CachedData.getData(key: KeysManager.zone),
                spot: CachedData.getData(key: KeysManager.spot),
                available: CachedData.getData(key: KeysManager.available),
                userId: CachedData.getData(key: KeysManager.userId),
                startTime: CachedData.getData(key: KeysManager.startTime),
                parkNumber: CachedData.getData(key: KeysManager.parkNumber),
              ),
            );
          } else {
            context.pushReplacementNamed(AppRoutes.goParkScreen);
          }
        }
      } else {
        context.pushReplacementNamed(AppRoutes.loginScreen);
      }
    }
  }

  @override
  void initState() {
    _ensureUserValidity();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: 100,
          alignment: Alignment.center,
          child: Text(
            'GoPark',
            style: TextStyle(
              color: ColorsManager.white,
              fontWeight: FontWeight.bold,
              fontFamily: FontsManager.stinger,
              fontSize: 28.sp,
            ),
          ),
        ),
      ),
    );
  }
}
