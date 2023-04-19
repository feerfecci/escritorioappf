import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class LocalAuthApi {
  static final _auth = LocalAuthentication();

  static Future<bool> hasBiometrics() async {
    try {
      return await _auth.isDeviceSupported();
    } on PlatformException {
      return false;
    }
  }

  static Future<bool> authenticate() async {
    final isAvaliable = await hasBiometrics();
    if (!isAvaliable) return false;
    try {
      return await _auth.authenticate(

        options: AuthenticationOptions(

            sensitiveTransaction: true,
            stickyAuth: true,
            useErrorDialogs: true,
            ),
        localizedReason: 'Desbloqueie seu celular',
      );
    } on PlatformException {
      return false;
    }
  }
}
