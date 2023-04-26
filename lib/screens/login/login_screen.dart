// ignore_for_file: unrelated_type_equality_checks, prefer_const_literals_to_create_immutables
import 'dart:async';
// import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:escritorioappf/screens/politica_privacidade/politica_privacidade.dart';
import 'package:escritorioappf/repository/shared_preferences.dart';
import 'package:escritorioappf/widgets/alert_dialogs/alert_update.dart';
import 'package:escritorioappf/widgets/snackbar/snack.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_version_checker/flutter_app_version_checker.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:validatorless/validatorless.dart';
import '../../logado.dart';
import '../../../logado.dart' as logado;
import '../../widgets/custom_drawer.dart';
import 'esqueceu_senha.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final LocalSetting _prefService = LocalSetting();
  final emailController =
      TextEditingController(/*text: 'cesarreballo@gmail.com'*/);
  final senhaController = TextEditingController(/*text: '123456'*/);
  // ConnectivityResult result = ConnectivityResult.none;
  bool _obscure = true;
  bool carregando = false;
  late StreamSubscription subscrition;
  final _checker = AppVersionChecker(
    appId: 'com.escritorioapp.ap2',
    androidStore: AndroidStore.googlePlayStore,
  );
  @override
  void dispose() {
    subscrition.cancel();
    super.dispose();
  }

  @override
  void initState() {
    checkerVersion();

    // subscrition =
    //     Connectivity().onConnectivityChanged.listen(showConnectivitySnackBar);
    super.initState();
  }

  void checkerVersion() {
    _checker.checkUpdate().then((value) {
      if (value.canUpdate) {
        alertDialogUpdate(context);
      }
    });
  }

  _startLoading() async {
    setState(() {
      carregando = !carregando;
    });

    Timer(Duration(seconds: 3), () async {
      await efetuaLogin(
          context, emailController.text, senhaController.text, logado.codigo);
      setState(() {
        carregando = !carregando;
      });
    });
  }

  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    Widget buildTextFormEmail(double sizes) {
      return TextFormField(
        // initialValue: emailSalvo,
        keyboardType: TextInputType.emailAddress,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: emailController,

        validator: Validatorless.multiple([
          Validatorless.required('Email é obrigatório'),
          Validatorless.email('Preencha com um email Válido')
        ]),
        autofillHints: [AutofillHints.email],
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: size.width * sizes),
          filled: true,
          fillColor: Theme.of(context).primaryColor,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.black26)),
          hintText: 'Digite seu Email',
        ),
      );
    }

    Widget buildTextFormSenha(double sizes) {
      return Column(
        children: [
          TextFormField(
            textInputAction: TextInputAction.done,
            controller: senhaController,
            autofillHints: [AutofillHints.password],
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: Validatorless.multiple([
              Validatorless.required('Senha é obrigatório'),
              Validatorless.min(6, 'Mínimo de 6 caracteres')
            ]),
            onEditingComplete: () => TextInput.finishAutofillContext(),
            obscureText: _obscure,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(left: size.width * sizes),
              filled: true,
              fillColor: Theme.of(context).primaryColor,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Colors.black26)),
              hintText: 'Digite sua Senha',
              suffixIcon: GestureDetector(
                onTap: (() {
                  setState(() {
                    _obscure = !_obscure;
                  });
                }),
                child: _obscure
                    ? Icon(Icons.visibility_off_outlined)
                    : Icon(Icons.visibility_outlined),
              ),
            ),
          ),
          CheckboxListTile(
            title: Text('Mantenha-me conectado'),
            value: isChecked,
            activeColor: logado.kButtonColor,
            onChanged: (bool? value) {
              setState(() {
                isChecked = value!;
              });
            },
          )
        ],
      );
    }

    Widget buildLoading(double height, double widgth) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(
            height: size.height * height,
            width: size.width * widgth,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white,
            ),
          ),
        ],
      );
    }

    Widget buildLoginButton({required double alturaBotao}) {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: size.height * alturaBotao),
            // fixedSize: Size(double.maxFinite, size.height),
            backgroundColor: logado.kButtonColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(logado.borderButton))),
        onPressed: () async {
          var formValid = formKey.currentState?.validate() ?? false;
          if (formValid && isChecked == true) {
            await _prefService
                .createChache(emailController.text, senhaController.text)
                .whenComplete(() async {
              _startLoading();
            });
          } else if (formValid && isChecked == false) {
            _startLoading();
          } else if (emailController.text != '' && senhaController != '') {
            buildMinhaSnackBar(context, categoria: 'login_erro');
          } else {
            buildMinhaSnackBar(
              context,
              categoria: 'login_erro',
            );
          }
        },
        child: carregando == false
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    'Entrar',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              )
            : logado.buildLayout(
                context,
                seMobile: buildLoading(0.020, 0.05),
                seWeb: buildLoading(0.03, 0.02),
              ),
      );
    }

    Widget buildPosLogin(double padding) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: size.width * padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EsqueceuSenha(),
                      ),
                    );
                  },
                  child: Text(
                    'Esqueci minha senha',
                    style: TextStyle(color: Theme.of(context).iconTheme.color),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PoliticaPrivacidade(),
                      ),
                    );
                  },
                  child: Text(
                    'Política de Privacidade',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Theme.of(context).iconTheme.color),
                  ),
                ),
              ],
            ),
            TextButton(
              onPressed: () {
                launchWhatsAppSuporte();
              },
              child: Text(
                'Não lembro meus dados de acesso',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Theme.of(context).iconTheme.color),
              ),
            ),
          ],
        ),
      );
    }

    return AutofillGroup(
      child: Form(
        key: formKey,
        child: Scaffold(
          body: Center(
            child: logado.buildLayout(
              context,
              seMobile: Wrap(
                children: [
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: size.width * 0.05),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: size.height * 0.04),
                          child: Image(
                            image: NetworkImage(
                                '${logado.arquivoAssets}logo-login-f.png'),
                          ),
                        ),
                        buildTextFormEmail(0.04),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        buildTextFormSenha(0.04),
                        buildLoginButton(alturaBotao: 0.025)
                      ],
                    ),
                  ),
                  buildPosLogin(0.05)
                ],
              ),
              seWeb: Wrap(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: size.width * 0.3),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: size.height * 0.08),
                          child: Image(
                            image: NetworkImage(
                                '${logado.arquivoAssets}logo-login-f.png'),
                          ),
                        ),
                        buildTextFormEmail(0.01),
                        SizedBox(
                          height: size.height * 0.023,
                        ),
                        buildTextFormSenha(0.01),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        buildLoginButton(alturaBotao: 0.035),
                        SizedBox(
                          height: size.height * 0.028,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.028,
                  ),
                  buildPosLogin(0.3),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

//   showConnectivitySnackBar(ConnectivityResult result) {
//     final bool hasNoInternet = result == ConnectivityResult.none;
//     final titulo =
//         hasNoInternet ? 'Você não tem internet' : 'Você está conectado';
//     final subTitulo = hasNoInternet
//         ? 'Verifique as configurações de conexão'
//         : 'Conexão de internet restabalecida';
//     final color = hasNoInternet ? Colors.red : Colors.green;
//     //  Utils.showTopSnackBar(context, titulo, subTitulo, color);
//     switch (hasNoInternet) {
//       case true:
//         return Utils.showTopSnackBar(context, titulo, subTitulo, color);

//       default:
//         null;
//     }
//   }
// }

// class Utils {
//   static void showTopSnackBar(
//           BuildContext context, String titulo, String subTitulo, Color color) =>
//       showSimpleNotification(Text(titulo),
//           subtitle: Text(subTitulo), background: color);
// }
}
