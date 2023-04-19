import 'package:escritorioappf/repository/theme_moldals.dart';
import 'package:escritorioappf/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'repository/theme_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  RendererBinding.instance.setSemanticsEnabled(true);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
        child: ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      builder: (context, _) {
        final themeProvider = Provider.of<ThemeProvider>(context);
        return MaterialApp(
          themeMode: themeProvider.themeMode,
          debugShowCheckedModeBanner: false,
          theme: light_theme(context),
          darkTheme: dark_theme(context),
          home: SplashScreen(),
          builder: (context, child) {
            return MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
                child: child!);
          },
        );
      },
    ));
  }
}
