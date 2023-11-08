import 'package:escritorioappf/screens/payment_metod/payment_meto_screen.dart';
import 'package:escritorioappf/screens/login/login_screen.dart';
import 'package:escritorioappf/screens/planos/planos_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../logado.dart' as logado;
import '../../Consts/consts_widget.dart';
import '../Consts/Consts.dart';
import '../Consts/consts_future.dart';
import '../repository/theme_provider.dart';
import '../screens/politica_privacidade/politica_privacidade.dart';
import '../repository/shared_preferences.dart';

class CustomDrawer extends StatefulWidget {
  final String fundo;

  const CustomDrawer({super.key, required this.fundo});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

launchWhatsAppSuporte() async {
  final zapzap = Uri.parse('http://bit.ly/3mQa0A5');
  await launchUrl(Uri.parse(zapzap.toString()),
      mode: LaunchMode.externalApplication);
}

class _CustomDrawerState extends State<CustomDrawer> {
  final LocalSetting _prefService = LocalSetting();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    Widget buildListTile(String text, leading, {void Function()? onTap}) {
      return ListTile(
        onTap: onTap,
        leading: leading,
        iconColor: Theme.of(context).primaryIconTheme.color,
        trailing: Icon(Icons.keyboard_arrow_right_outlined),
        title: Text(
          text,
          style: TextStyle(
            fontSize: Consts.fontTitulo,
          ),
        ),
      );
    }

    return SafeArea(
      child: SizedBox(
        height: size.height * 0.95,
        child: Drawer(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              bottomLeft: Radius.circular(30),
            ),
          ),
          child: (Column(
            children: [
              SizedBox(
                height: size.height * 0.10,
                width: size.width * 0.85,
                child: DrawerHeader(
                  padding: EdgeInsets.symmetric(
                    vertical: size.height * 0.02,
                    horizontal: size.width * 0.03,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      topLeft: Radius.circular(30),
                    ),
                    image: DecorationImage(
                      image: NetworkImage(
                        widget.fundo,
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Text(
                    'Menu',
                    style: TextStyle(
                      fontSize: 30,
                      color:
                          widget.fundo == '${Consts.fundoAssets}principal.jpg'
                              ? Colors.black
                              : Colors.white,
                    ),
                  ),
                ),
              ),
              buildListTile(onTap: () {
                ConstsFuture.navigatorPageRoute(context, PlanosScreen());
              }, 'Planos', Icon(Icons.assignment_ind_rounded)),
              buildListTile(onTap: () {
                ConstsFuture.navigatorPageRoute(context, PaymentMethod());
              }, 'Forma de Pagamento', Icon(Icons.attach_money)),
              buildListTile(
                'Suporte via Whatsapp',
                Icon(Icons.call_end_rounded),
                onTap: () {
                  launchWhatsAppSuporte();
                },
              ),
              buildListTile(
                'Política de Privacidade',
                Icon(Icons.privacy_tip_outlined),
                onTap: () {
                  ConstsFuture.navigatorPageRoute(
                      context, PoliticaPrivacidade());
                },
              ),
              ChangeThemeButtonWidget(),
              Spacer(),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.05,
                    vertical: size.height * 0.02),
                child: ConstsWidget.buildCustomButton(
                  context,
                  "Sair",
                  onPressed: () {
                    _prefService.removeChache().whenComplete(() {
                      logado.creditoCliente = 0;
                      logado.totalEmpresas = 0;
                      logado.codigo = '';
                      logado.razaoSocial = '';
                      logado.senhaUser = '';
                      logado.razao2 = '';
                      logado.periodo = '';
                      logado.emailUser = '';
                      logado.idCliente = 0;
                      logado.nomeSaudacao = '';
                      logado.sessCar = '';
                      logado.statusCliente = '';
                      ConstsFuture.navigatorPageRoute(context, LoginScreen());
                    });
                  },
                ),
              )
            ],
          )),
        ),
      ),
    );
  }
}

class ChangeThemeButtonWidget extends StatefulWidget {
  const ChangeThemeButtonWidget({super.key});

  @override
  State<ChangeThemeButtonWidget> createState() =>
      _ChangeThemeButtonWidgetState();
}

class _ChangeThemeButtonWidgetState extends State<ChangeThemeButtonWidget> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    String titulo = themeProvider.isDarkMode == true
        ? 'Ativar Modo Claro'
        : 'Ativar Modo Escuro';
    return SwitchListTile.adaptive(
      secondary: themeProvider.isDarkMode == true
          ? Icon(
              Icons.light_mode_outlined,
              color: Theme.of(context).primaryIconTheme.color,
            )
          : Icon(
              Icons.nightlight_outlined,
              color: Theme.of(context).primaryIconTheme.color,
            ),
      title: Text(
        titulo,
      ),
      value: themeProvider.isDarkMode,
      onChanged: (value) {
        final provider = Provider.of<ThemeProvider>(context, listen: false);
        setState(() {
          value = !value;
          provider.toggleTheme(value);
        });
      },
    );
  }
}
