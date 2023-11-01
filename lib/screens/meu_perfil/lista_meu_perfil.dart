// ignore_for_file: file_names

import 'dart:convert';
import 'package:escritorioappf/widgets/box_shadow.dart';
import 'package:escritorioappf/widgets/erro_servidor.dart';
import 'package:escritorioappf/widgets/snackbar/snack.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../../logado.dart' as logado;
import '../../Consts/consts_widget.dart';
import 'package:http/http.dart' as http;
import 'package:validatorless/validatorless.dart';
import '../../widgets/shimmer_widget.dart';
import 'user_model.dart';

class ListaMeuPerfil extends StatefulWidget {
  const ListaMeuPerfil({super.key});

  @override
  State<ListaMeuPerfil> createState() => ListaMeuPerfilState();
}

String seila = '';

Future<dynamic> pegarDadosCliente() async {
  // http.Response resposta = await http.get(_url);

  // return jsonDecode(resposta.body);

  final url = Uri.parse(
      '${logado.comecoAPI}clientes/?fn=dadoscliente&idcliente=${logado.idCliente}');

  var resposta = await http.get(url);

  if (resposta.statusCode == 200) {
    return json.decode(resposta.body);
  } else {
    return null;
  }
}

class ListaMeuPerfilState extends State<ListaMeuPerfil> {
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    conexao = pegarDadosCliente();
  }

  void alertaSalvarDados() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(
              'Os dados de Cobranças serão analisado e alterado pela nossa equipe'),
        );
      },
    );
  }

  late Future<dynamic> conexao;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final formkey = GlobalKey<FormState>();
    TextEditingController novaSenhaController = TextEditingController();
    TextEditingController confirmaSenhaController = TextEditingController();

    listTileLoading({
      double paddingHeight = 0.01,
      double height = 0.01,
      double width = double.infinity,
    }) {
      return Padding(
        padding: EdgeInsets.symmetric(
          vertical: size.height * paddingHeight,
        ),
        child: ShimmerWidget.rectangular(
          height: size.height * height,
          width: size.width * width,
        ),
      );
    }

    Widget loadingtextfiel() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: size.height * 0.015,
          ),
          listTileLoading(width: 0.2, paddingHeight: 0.005),
          listTileLoading(height: 0.05, paddingHeight: 0),
        ],
      );
    }

    return FutureBuilder<dynamic>(
        future: conexao,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return MeuBoxShadow(
                child: Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  listTileLoading(width: 0.5, height: 0.02),
                  listTileLoading(width: 0.65, paddingHeight: 0.015),
                  //
                  loadingtextfiel(),

                  loadingtextfiel(),
                  //
                  SizedBox(
                    height: size.height * 0.015,
                  ),
                  listTileLoading(width: 0.5, height: 0.02),
                  loadingtextfiel(),
                  //
                  loadingtextfiel(),
                  //

                  loadingtextfiel(),
                  //

                  loadingtextfiel(),
                  //

                  loadingtextfiel(),
                  //
                ],
              ),
            ));
          } else if (snapshot.hasData == false || snapshot.hasError == true) {
            return ErroServidor();
          }
          String tipo_cliente = snapshot.data['dados_cliente']['tipo'];
          var user = UserModel();

          Widget buildTituloIndice(String title) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: size.height * 0.015),
              child: Text(
                title,
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }

          Widget buildSubIndice(String title) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: size.height * 0.008),
              child: Text(
                title,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          }

          Widget buildTituloField(String title) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: size.height * 0.008),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }

          Widget buildTextForm({
            required String titulo,
            required String categoriaApi,
            required String dadoApi,
            TextInputType? keyboardType,
            final void Function(String? text)? onSaved,
          }) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: size.height * 0.006),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildTituloField(titulo),
                  TextFormField(
                    keyboardType: keyboardType,
                    onSaved: onSaved,
                    initialValue: snapshot.data[categoriaApi][dadoApi],
                    textAlign: TextAlign.start,
                    maxLines: 5,
                    minLines: 1,
                    textAlignVertical: TextAlignVertical.center,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: size.width * 0.04),
                      filled: true,
                      fillColor: Theme.of(context).primaryColor,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: Colors.black26)),
                    ),
                  ),
                ],
              ),
            );

            // ConstsWidget.buildLayout(
            //   context,
            //   seMobile: Padding(
            //     padding: EdgeInsets.symmetric(vertical: size.height * 0.006),
            //     child: Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         buildTituloField('$titulo :'),
            //         TextFormField(
            //           keyboardType: keyboardType,
            //           onSaved: onSaved,
            //           initialValue: snapshot.data[categoriaApi][dadoApi],
            //           textAlign: TextAlign.start,
            //           maxLines: 5,
            //           minLines: 1,
            //           textAlignVertical: TextAlignVertical.center,
            //           textInputAction: TextInputAction.next,
            //           decoration: InputDecoration(
            //             contentPadding:
            //                 EdgeInsets.only(left: size.width * 0.04),
            //             filled: true,
            //             fillColor: Theme.of(context).primaryColor,
            //             border: OutlineInputBorder(
            //                 borderRadius: BorderRadius.circular(16)),
            //             enabledBorder: OutlineInputBorder(
            //                 borderRadius: BorderRadius.circular(16),
            //                 borderSide: BorderSide(color: Colors.black26)),
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            //   seWeb: Padding(
            //     padding: EdgeInsets.symmetric(vertical: size.height * 0.006),
            //     child: Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         buildTituloField('$titulo :'),
            //         TextFormField(
            //           keyboardType: keyboardType,
            //           onSaved: onSaved,
            //           initialValue: snapshot.data[categoriaApi][dadoApi],
            //           textAlign: TextAlign.start,

            //           maxLines: 5,
            //           minLines: 1,
            //           textAlignVertical: TextAlignVertical.center,
            //           // controller: controller,
            //           textInputAction: TextInputAction.next,

            //           decoration: InputDecoration(
            //             contentPadding:
            //                 EdgeInsets.only(left: size.width * 0.04),
            //             filled: true,
            //             fillColor: Theme.of(context).primaryColor,
            //             border: OutlineInputBorder(
            //                 borderRadius: BorderRadius.circular(16)),
            //             enabledBorder: OutlineInputBorder(
            //                 borderRadius: BorderRadius.circular(16),
            //                 borderSide: BorderSide(color: Colors.black26)),
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // );
          }

          Widget buildTextFormFormat({
            required String titulo,
            required String categoriaApi,
            required String dadoApi,
            required String mask,
            TextInputType? keyboardType,
            final void Function(String? text)? onSaved,
          }) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: size.height * 0.006),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildTituloField(titulo),
                  TextFormField(
                    keyboardType: keyboardType,
                    onSaved: onSaved,
                    initialValue: snapshot.data[categoriaApi][dadoApi],
                    textAlign: TextAlign.start,
                    inputFormatters: [MaskTextInputFormatter(mask: mask)],
                    textAlignVertical: TextAlignVertical.center,
                    // controller: controller,
                    textInputAction: TextInputAction.next,

                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: size.width * 0.04),
                      filled: true,
                      fillColor: Theme.of(context).primaryColor,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: Colors.black26)),
                    ),
                  ),
                ],
              ),
            );
          }

          alertaSenha(BuildContext context) {
            bool obscureNova = true;
            bool obscureConfi = true;
            return showDialog(
              context: context,
              builder: (BuildContext context) => Form(
                key: formkey,
                child: AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  content: SizedBox(
                    width: size.width * 0.98,
                    child: StatefulBuilder(builder: (context, setState) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          buildTituloField('Nova Senha:'),
                          TextFormField(
                            textInputAction: TextInputAction.next,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            controller: novaSenhaController,
                            validator: Validatorless.multiple([
                              Validatorless.required(
                                  'Senha precisa ser preenchida'),
                              Validatorless.min(
                                  6, 'Senha precisa ter 6 caracteres'),
                            ]),
                            obscureText: obscureNova,
                            decoration: InputDecoration(
                              suffixIcon: GestureDetector(
                                onTap: (() {
                                  setState(() {
                                    obscureNova = !obscureNova;
                                  });
                                }),
                                child: obscureNova
                                    ? Icon(Icons.visibility_off_outlined)
                                    : Icon(Icons.visibility_outlined),
                              ),
                              contentPadding:
                                  EdgeInsets.only(left: size.width * 0.04),
                              filled: true,
                              fillColor: Theme.of(context).primaryColor,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide:
                                      BorderSide(color: Colors.black26)),
                            ),
                          ),
                          buildTituloField('Confirmar Senha:'),
                          TextFormField(
                            textInputAction: TextInputAction.done,
                            controller: confirmaSenhaController,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: Validatorless.multiple([
                              Validatorless.required('Confirme a senha'),
                              Validatorless.min(
                                  6, 'Senha precisa ter 6 caracteres'),
                              Validatorless.compare(
                                  novaSenhaController, 'Senhas não são iguais')
                            ]),
                            obscureText: obscureConfi,
                            decoration: InputDecoration(
                              suffixIcon: GestureDetector(
                                onTap: (() {
                                  setState(() {
                                    obscureConfi = !obscureConfi;
                                  });
                                }),
                                child: obscureConfi
                                    ? Icon(Icons.visibility_off_outlined)
                                    : Icon(Icons.visibility_outlined),
                              ),
                              contentPadding:
                                  EdgeInsets.only(left: size.width * 0.04),
                              filled: true,
                              fillColor: Theme.of(context).primaryColor,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide:
                                      BorderSide(color: Colors.black26)),
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: Text(
                        "Cancelar",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        var formValid =
                            formKey.currentState?.validate() ?? false;
                        if ((formValid &&
                                novaSenhaController.text ==
                                    confirmaSenhaController.text) &&
                            (novaSenhaController.text != '' ||
                                confirmaSenhaController.text != '')) {
                          changeApi(
                              '${logado.comecoAPI}/clientes/?fn=alterar_senha&email_principal=${logado.emailUser}&senha=${novaSenhaController.text}');
                          Navigator.of(context).pop();
                          buildMinhaSnackBar(
                            context,
                            categoria: 'senha_alterada',
                          );
                        } else {
                          // ignore: unrelated_type_equality_checks
                          formValid = formKey.currentState == false;
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue),
                      child: Text(
                        "Trocar Senha",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return Form(
            key: formKey,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.01),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MeuBoxShadow(
                      child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: size.width * 0.025),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildTituloIndice('Dados Correspondências'),
                        buildSubIndice(
                          'E-mails para envios de correspondências',
                        ),
                        buildTextForm(
                          titulo: 'Responsável',
                          categoriaApi: 'dados_app',
                          dadoApi: 'responsavel',
                          onSaved: (text) =>
                              user = user.copyWith(responsavel: text),
                        ),
                        buildTextForm(
                          titulo: 'Email',
                          categoriaApi: 'dados_app',
                          dadoApi: 'email_principal',
                          onSaved: (text) =>
                              user = user.copyWith(email_principal: text),
                        ),
                        buildSubIndice(
                            'Endereço físico para envio de correspondências'),
                        buildTextFormFormat(
                            titulo: 'CEP',
                            categoriaApi: 'dados_cliente',
                            dadoApi: 'cep',
                            onSaved: (text) => user = user.copyWith(cep: text),
                            keyboardType: TextInputType.number,
                            mask: '##### - ###'),
                        buildTextForm(
                          titulo: 'Endereço',
                          categoriaApi: 'dados_cliente',
                          dadoApi: 'endereco',
                          onSaved: (text) =>
                              user = user.copyWith(endereco: text),
                        ),
                        buildTextForm(
                          titulo: 'Número',
                          categoriaApi: 'dados_cliente',
                          dadoApi: 'numero',
                          onSaved: (text) => user = user.copyWith(numero: text),
                        ),
                        buildTextForm(
                          titulo: 'Complemento',
                          categoriaApi: 'dados_cliente',
                          dadoApi: 'complemento',
                          onSaved: (text) =>
                              user = user.copyWith(complemento: text),
                        ),
                        buildTextForm(
                          titulo: 'Bairro',
                          categoriaApi: 'dados_cliente',
                          dadoApi: 'bairro',
                          onSaved: (text) => user = user.copyWith(bairro: text),
                        ),
                        buildTextForm(
                          titulo: 'Cidade',
                          categoriaApi: 'dados_cliente',
                          dadoApi: 'cidade',
                          onSaved: (text) => user = user.copyWith(cidade: text),
                        ),
                        buildTextForm(
                          titulo: 'Estado',
                          categoriaApi: 'dados_cliente',
                          dadoApi: 'estado',
                          onSaved: (text) => user = user.copyWith(estado: text),
                        ),
                      ],
                    ),
                  )),
                  //dados cobranca
                  MeuBoxShadow(
                      child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: size.width * 0.025),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildTituloIndice('Dados de Cobranças'),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: size.height * 0.008),
                          child: Text(
                            'Esses são os dados que aparecerão nas suas faturas e notas fiscais e só serão alterados se estiverem idênticos ao seu cartão CNPJ.',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: logado.fontSubTitulo),
                          ),
                        ),
                        buildTextForm(
                          titulo: 'Nome de Cobrança',
                          categoriaApi: 'dados_cobranca',
                          dadoApi: 'nome_iugu',
                          onSaved: (text) =>
                              user = user.copyWith(nome_iugu: text),
                        ),
                        buildTextFormFormat(
                          titulo: 'Telefone de Cobrança',
                          categoriaApi: 'dados_cobranca',
                          dadoApi: 'telefone_cobranca',
                          onSaved: (text) =>
                              user = user.copyWith(telefone_cobranca: text),
                          keyboardType: TextInputType.number,
                          mask: '(##) # #### - ####',
                        ),
                        buildTextForm(
                          titulo: 'Email',
                          categoriaApi: 'dados_cobranca',
                          dadoApi: 'email_cobranca',
                          onSaved: (text) =>
                              user = user.copyWith(email_cobranca: text),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        buildTextFormFormat(
                            titulo: 'CEP',
                            categoriaApi: 'dados_cobranca',
                            dadoApi: 'cep_cobranca',
                            onSaved: (text) =>
                                user = user.copyWith(cep_cobranca: text),
                            keyboardType: TextInputType.number,
                            mask: '##### - ###'),
                        buildTextForm(
                          titulo: 'Endereço',
                          categoriaApi: 'dados_cobranca',
                          dadoApi: 'endereco_cobranca',
                          onSaved: (text) =>
                              user = user.copyWith(endereco_cobranca: text),
                        ),
                        buildTextForm(
                          titulo: 'Número',
                          categoriaApi: 'dados_cobranca',
                          dadoApi: 'numero_cobranca',
                          onSaved: (text) =>
                              user = user.copyWith(numero_cobranca: text),
                        ),
                        buildTextForm(
                          titulo: 'Complemento',
                          categoriaApi: 'dados_cobranca',
                          dadoApi: 'complemento_cobranca',
                          onSaved: (text) =>
                              user = user.copyWith(complemento_cobranca: text),
                        ),
                        buildTextForm(
                          titulo: 'Bairro',
                          categoriaApi: 'dados_cobranca',
                          dadoApi: 'bairro_cobranca',
                          onSaved: (text) =>
                              user = user.copyWith(bairro_cobranca: text),
                        ),
                        buildTextForm(
                          titulo: 'Cidade',
                          categoriaApi: 'dados_cobranca',
                          dadoApi: 'cidade_cobranca',
                          onSaved: (text) =>
                              user = user.copyWith(cidade_cobranca: text),
                        ),
                        buildTextForm(
                          titulo: 'Estado',
                          categoriaApi: 'dados_cobranca',
                          dadoApi: 'estado_cobranca',
                          onSaved: (text) =>
                              user = user.copyWith(estado_cobranca: text),
                        ),
                      ],
                    ),
                  )),
                  //dados app
                  MeuBoxShadow(
                      child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: size.width * 0.025),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildTituloIndice('Dados App'),
                        tipo_cliente == 'CPF'
                            ? buildTextForm(
                                titulo: 'Razão Social (quando pessoa física)',
                                categoriaApi: 'dados_cliente',
                                dadoApi: 'razao_social_pf',
                                onSaved: (text) =>
                                    user = user.copyWith(razao_social_pf: text),
                              )
                            : buildTextForm(
                                titulo: 'Razão Social',
                                categoriaApi: 'dados_cliente',
                                dadoApi: 'razao_social',
                                onSaved: (text) =>
                                    user = user.copyWith(razao_social: text),
                              ),
                        buildTextForm(
                          titulo: 'Nome Fantasia',
                          categoriaApi: 'dados_cliente',
                          dadoApi: 'nome_fantasia',
                          onSaved: (text) =>
                              user = user.copyWith(nome_fantasia: text),
                        ),
                        buildTextFormFormat(
                          titulo: 'Telefone 1',
                          categoriaApi: 'dados_cliente',
                          dadoApi: 'telefone1',
                          onSaved: (text) =>
                              user = user.copyWith(telefone1: text),
                          keyboardType: TextInputType.number,
                          mask: '(##) # #### - ####',
                        ),
                        buildTextFormFormat(
                          titulo: 'Telefone 2',
                          categoriaApi: 'dados_cliente',
                          dadoApi: 'telefone2',
                          onSaved: (text) =>
                              user = user.copyWith(telefone2: text),
                          keyboardType: TextInputType.number,
                          mask: '(##) # #### - ####',
                        ),
                        //adicionais
                        ExpansionTile(
                            title: buildSubIndice('Adicionar Outros contatos'),
                            children: [
                              //2
                              buildTextForm(
                                titulo: 'Responsável 2',
                                categoriaApi: 'dados_app',
                                dadoApi: 'responsavel_2',
                                onSaved: (text) =>
                                    user = user.copyWith(responsavel2: text),
                              ),
                              buildTextForm(
                                titulo: 'Email 2',
                                categoriaApi: 'dados_app',
                                dadoApi: 'email_secundario',
                                onSaved: (text) =>
                                    user = user.copyWith(email2: text),
                                keyboardType: TextInputType.emailAddress,
                              ),
                              //3
                              buildTextForm(
                                titulo: 'Responsável 3',
                                categoriaApi: 'dados_app',
                                dadoApi: 'responsavel3',
                                onSaved: (text) =>
                                    user = user.copyWith(responsavel3: text),
                              ),
                              buildTextForm(
                                titulo: 'Email',
                                categoriaApi: 'dados_app',
                                dadoApi: 'email3',
                                onSaved: (text) =>
                                    user = user.copyWith(email3: text),
                                keyboardType: TextInputType.emailAddress,
                              ),
                              //4
                              buildTextForm(
                                titulo: 'Responsável 4',
                                categoriaApi: 'dados_app',
                                dadoApi: 'responsavel4',
                                onSaved: (text) =>
                                    user = user.copyWith(responsavel4: text),
                              ),
                              buildTextForm(
                                titulo: 'Email',
                                categoriaApi: 'dados_app',
                                dadoApi: 'email4',
                                onSaved: (text) =>
                                    user = user.copyWith(email4: text),
                                keyboardType: TextInputType.emailAddress,
                              ),
                              //5
                              buildTextForm(
                                titulo: 'Responsável 5',
                                categoriaApi: 'dados_app',
                                dadoApi: 'responsavel5',
                                onSaved: (text) =>
                                    user = user.copyWith(responsavel5: text),
                              ),
                              buildTextForm(
                                titulo: 'Email 5',
                                categoriaApi: 'dados_app',
                                dadoApi: 'email5',
                                onSaved: (text) =>
                                    user = user.copyWith(email5: text),
                                keyboardType: TextInputType.emailAddress,
                              ),
                            ]),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: size.height * 0.01),
                          child: ConstsWidget.buildCustomButton(
                              context, 'Trocar minha senha de acesso',
                              onPressed: () {
                            alertaSenha(context);
                          }),
                        ),
                      ],
                    ),
                  )),

                  SizedBox(
                    height: size.height * 0.008,
                  ),
                  Center(
                    child: ConstsWidget.buildCustomButton(context, 'Salvar',
                        icon: Icons.save_alt_sharp, onPressed: () {
                      if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();
                      }
                      changeApi(
                          '${logado.comecoAPI}clientes/?fn=alteracao_cliente&idcliente=${logado.idCliente}&responsavel=${user.responsavel}&email_principal=${user.email_principal}&cep=${user.cep}&endereco=${user.endereco}&numero=${user.numero}&complemento=${user.complemento}&bairro=${user.bairro}&cidade=${user.cidade}&estado=${user.estado}&email_cobranca=${user.email_cobranca}&telefone_cobranca=${user.telefone_cobranca}&endereco_cobranca=${user.endereco_cobranca}&numero_cobranca=${user.numero_cobranca}&complemento_cobranca=${user.complemento_cobranca}&bairro_cobranca=${user.bairro_cobranca}&cidade_cobranca=${user.cidade_cobranca}&cep_cobranca=${user.cep_cobranca}&estado_cobranca=${user.estado_cobranca}&razao_social_pf=${user.razao_social_pf}&razao_social=${user.razao_social}&nome_fantasia=${user.nome_fantasia}&telefone1=${user.telefone1}&telefone2=${user.telefone2}&responsavel_2=${user.responsavel2}&email_secundario=${user.email2}&responsavel3=${user.responsavel3}&email3=${user.email3}&responsavel4=${user.responsavel4}&email4=${user.email4}&responsavel5=${user.responsavel5}&email5=${user.email5}');
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ListaMeuPerfil()),
                      );

                      buildMinhaSnackBar(
                        context,
                        categoria: 'dados_alterados',
                      );
                    }),
                  ),
                  SizedBox(
                    height: size.height * 0.015,
                  )
                ],
              ),
            ),
          );
        });
  }
}

Future<http.Response> changeApi(String api) {
  return http.post(
    Uri.parse(api),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );
}

class Validator {
  static FormFieldValidator compare(
      TextEditingController? valueEC, String mensagem) {
    return (value) {
      final valueCompare = valueEC?.text ?? '';
      if (value == null || (value != null && value != valueCompare)) {
        return mensagem;
      }
      return null;
    };
  }
}
