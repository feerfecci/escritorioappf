// ignore_for_file: use_build_context_synchronously
import 'dart:async';
import 'package:escritorioappf/logado.dart';
import 'package:escritorioappf/screens/login/login_screen.dart';
import 'package:escritorioappf/repository/shared_preferences.dart';
import 'package:flutter/material.dart';
import '../Consts/consts_future.dart';
import '../repository/biometric_data.dart';
import '../../Consts/consts_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  final LocalSetting prefService = LocalSetting();
  startLogin() {
    prefService.readChache().then((value) async {
      Map<String, dynamic> infos = value;
      if (infos['email'] == null || infos['senha'] == null) {
        ConstsFuture.navigatorPageRoute(context, LoginScreen());
      } else if (infos['email'] != null || infos['senha'] != null) {
        Future authentic() async {
          final auth = await LocalAuthApi.authenticate();
          final hasBiometrics = await LocalAuthApi.hasBiometrics();
          if (hasBiometrics) {
            if (auth) {
              return efetuaLogin(context, infos['email'], infos['senha'], '');
            } else {
              false;
            }
          } else {
            return efetuaLogin(context, infos['email'], infos['senha'], '');
          }
        }

        return authentic();
      } else {
        ConstsFuture.navigatorPageRoute(context, LoginScreen());
      }
    });
  }

  @override
  void initState() {
    Timer(Duration(seconds: 3), () {
      startLogin();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(),
          SizedBox(
            height: size.height * 0.2,
            width: size.width * 0.6,
            child: Image.asset('assets/logo.png'),
          ),
          Spacer(),
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: size.height * 0.03, horizontal: size.width * 0.03),
            child: ConstsWidget.buildCustomButton(
              context,
              'Autenticar Biometria',
              icon: Icons.lock_open_outlined,
              onPressed: () {
                startLogin();
              },
            ),
          ),
        ],
      ),
    );
  }
}
