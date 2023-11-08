// ignore_for_file: non_constant_identifier_names
library globals;

import 'package:escritorioappf/consts/consts_future.dart';
import 'package:escritorioappf/itens_bottom.dart';
import 'package:escritorioappf/widgets/box_shadow.dart';
import 'package:escritorioappf/widgets/erro_servidor.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../consts/consts.dart';
import '../../../Consts/consts_widget.dart';
import '../../../logado.dart' as logado;

import 'dart:convert';
import 'package:http/http.dart' as http;

import 'loading_carrinho.dart';

int? bolinhaCarrinho;
carrinhoApi() async {
  var url = Uri.parse(
      '${Consts.comecoAPI}carrinho/index.php?fn=listacarrinho&idcliente=${logado.idCliente}');
  var resposta = await http.get(url);
  if (resposta.statusCode == 200) {
    return json.decode(resposta.body);
  } else {
    return null;
  }
}

class ListaItensCarrinho extends StatefulWidget {
  const ListaItensCarrinho({
    super.key,
  });

  @override
  State<ListaItensCarrinho> createState() => _ListaItensCarrinhoState();
}

class _ListaItensCarrinhoState extends State<ListaItensCarrinho> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return FutureBuilder<dynamic>(
        future: carrinhoApi(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingCarinhho();
          } else if (snapshot.hasData) {
            if (!snapshot.data['erro'] && snapshot.data['mensagem'] == "") {
              return ListView.builder(
                  physics: ClampingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: snapshot.data["carrinho"].length,
                  itemBuilder: ((context, index) {
                    logado.bolinha = snapshot.data["carrinho"].length;
                    var carrinhoIndex = snapshot.data['carrinho'][index];
                    int idCorresp = carrinhoIndex['id'];
                    String remetente = carrinhoIndex['remetente'];
                    String descricao = carrinhoIndex['descricao'];
                    String valor_unitario = carrinhoIndex['valor_unitario'];
                    String dataCorresp = DateFormat('dd/MM/yyyy')
                        .format(DateTime.parse(carrinhoIndex['data']));
                    String tipo_envio = carrinhoIndex['tipo_envio'];
                    int qtd_arquivos = carrinhoIndex['qtd_arquivos'];
                    String valor_total_unitario = carrinhoIndex['valor_total'];

                    excluirCarrinho() async {
                      var url = Uri.parse(
                          '${Consts.comecoAPI}carrinho/index.php?fn=deleta_corresp_carrinho&idcorresp=$idCorresp');
                      var resposta = await http.get(url);
                      if (resposta.statusCode == 200) {
                        return json.decode(resposta.body);
                      } else {
                        return null;
                      }
                    }

                    alerta(BuildContext context) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Remover Item"),
                            content: Text(
                                'Certeza que deseja remover esse item do carrinho?'),
                            actions: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                                child: Text("Cancelar"),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  excluirCarrinho();
                                  ConstsFuture.restApi(
                                          'carrinho/index.php?fn=deleta_corresp_carrinho&idcorresp=$idCorresp')
                                      .then((value) {
                                    if (!value['erro']) {
                                      setState(() {
                                        // CarrinhoScreen.valorCarrinho;
                                        // CarrinhoScreen();
                                      });
                                      Navigator.of(context).pop();
                                      ConstsFuture.navigatorRemoveUntil(
                                          context, ItensBottom(currentTab: 0));
                                    }
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                ),
                                child: Text("Excluir"),
                              ),
                            ],
                          );
                        },
                      );
                    }

                    Widget buildDetalhesCompra(
                        String? titulo, String? conteudo) {
                      return Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: size.height * 0.005),
                          child: Row(
                            children: [
                              ConstsWidget.buildTextTitle('$titulo: '),
                              ConstsWidget.buildTextSubTitle('$conteudo')
                            ],
                          ));
                    }

                    return ConstsWidget.buildLayout(
                      context,
                      seMobile: MeuBoxShadow(
                        isCardHome: true,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: size.width * 0.03),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: size.width * 0.77,
                                    child:
                                        ConstsWidget.buildTextTitle(remetente),
                                  ),
                                  ConstsWidget.buildTextSubTitle(descricao),
                                  ConstsWidget.buildTextSubTitle(dataCorresp),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: size.height * 0.01),
                                    child: Text(
                                      tipo_envio,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  buildDetalhesCompra(
                                      'Quantidade', '$qtd_arquivos x'),
                                  buildDetalhesCompra(
                                      'Valor Unitário', valor_unitario),
                                  buildDetalhesCompra(
                                      'Total', valor_total_unitario),
                                ],
                              ),
                              GestureDetector(
                                onTap: () {
                                  alerta(context);
                                },
                                child: Icon(Icons.delete,
                                    size: size.height * 0.05,
                                    color: Colors.red),
                              )
                            ],
                          ),
                        ),
                      ),
                      seWeb: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: size.width * 0.02),
                        child: MeuBoxShadow(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: size.height * 0.01,
                                horizontal: size.width * 0.001),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ConstsWidget.buildTextTitle('remetente'),
                                    ConstsWidget.buildTextSubTitle(descricao),
                                    ConstsWidget.buildTextSubTitle(dataCorresp),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: size.height * 0.01),
                                      child: Text(
                                        tipo_envio,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    buildDetalhesCompra(
                                        'Quantidade', '$qtd_arquivos'),
                                    buildDetalhesCompra(
                                        'Valor Unitário', valor_unitario),
                                    buildDetalhesCompra(
                                        'Total', valor_total_unitario),
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () {
                                    alerta(context);
                                  },
                                  child: Icon(Icons.delete,
                                      size: size.height * 0.05,
                                      color: Colors.red),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }));
            } else {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network('${Consts.arquivoAssets}ico-lupa.png'),
                  Text(
                    textAlign: TextAlign.center,
                    'Carrinho vazio. Adicione uma correspondência aqui',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ],
              );
            }
          } else {
            return ErroServidor();
          }
        });
    //
  }
}
