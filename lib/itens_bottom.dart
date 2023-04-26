// ignore_for_file: depend_on_referenced_packages, unnecessary_string_interpolations

import 'package:badges/badges.dart' as badge;
import 'package:escritorioappf/screens/carrinho/widgets/lista_carrinho.dart';
import 'package:escritorioappf/widgets/fundo_screen.dart';
import 'package:flutter/material.dart';
import 'screens/carrinho/carrinho_screen.dart';
import 'screens/duvidas/duvidas_screen.dart';
import 'screens/home/home_principal.dart';
import 'widgets/custom_drawer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:escritorioappf/screens/carrinho/widgets/lista_carrinho.dart'
    as carrinho;
import '../../logado.dart' as logado;

// ignore: must_be_immutable
class ItensBottom extends StatefulWidget {
  int currentTab;
  BuildContext? context;
  ItensBottom({this.context, required this.currentTab, super.key});

  @override
  State<ItensBottom> createState() => _ItensBottomState();
}

class _ItensBottomState extends State<ItensBottom> {
  DateTime timeBackPressed = DateTime.now();
  static const String oneSignalAppId = "56d855ee-f534-4c40-97b5-272bebcee2f1";

  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    initPlatformState();
    _pageController = PageController();
  }

  Future<void> initPlatformState() async {
    OneSignal.shared.setAppId(oneSignalAppId);
    OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
      OneSignal.shared.setEmail(email: "${logado.emailUser}");
      OneSignal.shared.setExternalUserId(logado.idCliente.toString());
      OneSignal.shared
          .sendTags({'isAndroid': 1, 'idweb': logado.idCliente.toString()});
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    Widget buildItensBottons(double height) {
      return BottomNavigationBar(
        iconSize: size.height * height,
        showUnselectedLabels: logado.bolinha == 0 ? true : false,
        currentIndex: widget.currentTab,
        onTap: (p) {
          _pageController.jumpToPage(p);
        },
        items: [
          BottomNavigationBarItem(
            label: 'Início',
            icon: Icon(
              widget.currentTab == 0 ? Icons.home_sharp : Icons.home_outlined,
            ),
          ),
          BottomNavigationBarItem(
            icon: badge.Badge(
              showBadge: logado.bolinha == 0 ? false : true,
              // toAnimate: false,
              child: Icon(
                widget.currentTab == 1
                    ? Icons.shopping_cart_rounded
                    : Icons.shopping_cart_outlined,
              ),
            ),
            label: 'Carrinho',
          ),
          BottomNavigationBarItem(
            label: 'Dúvidas',
            icon: Icon(
              widget.currentTab == 2
                  ? Icons.question_mark_sharp
                  : Icons.question_mark_outlined,
            ),
          ),
        ],
      );
    }

    carrinhoApi();
    return WillPopScope(
      onWillPop: () async {
        final differenceBack = DateTime.now().difference(timeBackPressed);
        final isExitWarming = differenceBack >= Duration(seconds: 1);
        timeBackPressed = DateTime.now();

        if (isExitWarming) {
          String menssagem = 'Pressione novamente para sair';
          Fluttertoast.showToast(
              msg: menssagem, fontSize: 18, backgroundColor: Colors.black);

          return false;
        } else {
          print(differenceBack);
          Fluttertoast.cancel();
          return true;
        }
      },
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        endDrawer: CustomDrawer(
          fundo: '${logado.fundoAssets}principal.jpg',
        ),
        bottomNavigationBar: logado.buildLayout(
          context,
          seMobile: buildItensBottons(0.035),
          seWeb: buildItensBottons(0.03),
        ),
        body: Stack(
          children: [
            FundoScreen('${logado.fundoAssets}principal.jpg'),
            logado.buildLayout(context,
                seMobile: NestedScrollView(
                  headerSliverBuilder:
                      (BuildContext context, bool innerBoxIsScrolled) {
                    return [
                      SliverAppBar(
                        leading: Padding(
                          padding: EdgeInsets.only(
                              left: size.width * 0.02,
                              top: size.height * 0.0115),
                          child: SizedBox(
                            child: Image.network(
                                '${logado.arquivoAssets}logo-topo-app.png'),
                          ),
                        ),
                        iconTheme: IconThemeData(
                          color: Colors.black,
                        ),
                        backgroundColor: Colors.transparent,
                        floating: true,
                        toolbarHeight: size.height * 0.05,
                        pinned: true,
                      ),
                    ];
                  },
                  body: PageView(
                    physics: NeverScrollableScrollPhysics(),
                    controller: _pageController,
                    onPageChanged: (p) {
                      setState(() {
                        carrinhoApi();
                        widget.currentTab = p;
                      });
                    },
                    children: const [
                      HomePrincipal(),
                      CarrinhoScreen(),
                      DuvidasScreen(),
                    ],
                  ),
                ),
                seWeb: NestedScrollView(
                  headerSliverBuilder:
                      (BuildContext context, bool innerBoxIsScrolled) {
                    return [
                      SliverAppBar(
                        leading: Padding(
                          padding: EdgeInsets.only(
                              left: size.width * 0.02,
                              top: size.width * 0.0001),
                          child: Image.network(
                              '${logado.arquivoAssets}logo-topo-app.png'),
                        ),
                        iconTheme: IconThemeData(
                          color: Colors.black,
                        ),
                        backgroundColor: Colors.transparent,
                        floating: true,
                        toolbarHeight: 60,
                        pinned: true,
                      ),
                    ];
                  },
                  body: PageView(
                    physics: NeverScrollableScrollPhysics(),
                    controller: _pageController,
                    onPageChanged: (p) {
                      setState(() {
                        carrinhoApi();
                        widget.currentTab = p;
                      });
                    },
                    children: const [
                      HomePrincipal(),
                      CarrinhoScreen(),
                      DuvidasScreen(),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
