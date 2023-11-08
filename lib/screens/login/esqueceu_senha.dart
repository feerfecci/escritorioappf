import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:email_validator/email_validator.dart';
import 'package:escritorioappf/widgets/snackbar/snack.dart';
import '../../consts/consts.dart';
import '../../Consts/consts_widget.dart';
import 'package:flutter/material.dart';
import 'login_screen.dart';

class EsqueceuSenha extends StatefulWidget {
  const EsqueceuSenha({super.key});

  @override
  State<EsqueceuSenha> createState() => _EsqueceuSenhaState();
}

class _EsqueceuSenhaState extends State<EsqueceuSenha>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  recuperar() async {
    var url = Uri.parse(
        '${Consts.comecoAPI}recuperar_senha/?fn=recuperar_senha&email=${_emailController.text}');
    var resposta = await http.get(url);

    if (resposta.statusCode == 200) {
      return json.decode(resposta.body);
    } else {
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    Widget builEmailRecuperar(double widthPaddin) {
      return TextFormField(
        controller: _emailController,
        textInputAction: TextInputAction.next,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        // ignore: prefer_const_literals_to_create_immutables
        autofillHints: [AutofillHints.email],
        validator: (email) => email != null && !EmailValidator.validate(email)
            ? 'Preencha com e-mail válido'
            : null,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: size.width * widthPaddin),
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

    Widget buildBotaoRecuperar() {
      return Padding(
          padding: EdgeInsets.all(8),
          child: ConstsWidget.buildCustomButton(
            context,
            'Recuperar Senha',
            onPressed: () {
              final formValid = formKey.currentState?.validate() ?? false;
              if (formValid) {
                recuperar();
                buildMinhaSnackBar(
                  context,
                  categoria: 'login_erro',
                );
              } else if (_emailController.text != '') {
                buildMinhaSnackBar(context, categoria: 'login_erro');
              }
            },
          ));
    }

    Widget buildBotaoVoltar() {
      return Row(
        children: [
          TextButton(
            onPressed: () {
              Navigator.pop(
                context,
                MaterialPageRoute(
                  builder: (contex) => LoginScreen(),
                ),
              );
            },
            child: Text(
              'Voltar',
              textAlign: TextAlign.left,
            ),
          ),
        ],
      );
    }

    Widget buildTelaRecuperar(double paddinWidth) {
      return Wrap(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * paddinWidth),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: size.height * 0.018),
                  child: Image(
                    alignment: Alignment.centerRight,
                    image:
                        NetworkImage('${Consts.arquivoAssets}logo-login-f.png'),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  height: size.height * 0.05,
                  width: size.width * 0.80,
                  child: Text(
                    'Esqueceu a Senha?',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  height: size.height * 0.05,
                  width: size.width * 0.80,
                  child: Text(
                    'Para recuperar o acesso, informe o email cadastrado no Escritório Virtual',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.025,
                      vertical: size.height * 0.020),
                  child: Form(
                    key: formKey,
                    child: ConstsWidget.buildLayout(context,
                        seMobile: builEmailRecuperar(0.05),
                        seWeb: builEmailRecuperar(0.0001)),
                  ),
                ),
                buildBotaoRecuperar(),
                buildBotaoVoltar(),
              ],
            ),
          ),
        ],
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Center(
            child: ConstsWidget.buildLayout(
          context,
          seMobile: buildTelaRecuperar(0.04),
          seWeb: buildTelaRecuperar(0.3),
        )),
      ),
    );
  }
}
