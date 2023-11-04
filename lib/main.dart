import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization_loader/easy_localization_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get_it/get_it.dart';
import 'package:musicplayer_app/pages/home_page.dart';
import 'package:musicplayer_app/pages/navigation_page.dart';
import 'package:musicplayer_app/pages/profile_page.dart';
import 'package:musicplayer_app/pages/settings_page.dart';
import 'package:musicplayer_app/themes/light_theme.dart';
import 'package:url_strategy/url_strategy.dart';

import 'classes/music_player_class.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  if (kIsWeb) {
    null;
  } else if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    null;
  } else if (Platform.isAndroid) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.black,
      ),
    );
  } else if (Platform.isIOS) {
    null;
  } else {
    null;
  }

  setPathUrlStrategy();
  GetIt.I.registerSingleton<MusicPlayerClass>(MusicPlayerClass());

  // runApp(NewModularApp.get);
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ru')],
      fallbackLocale: const Locale('en'),
      path: 'assets/translations',
      assetLoader: const YamlAssetLoader(),
      child: NewModularApp.get,
    ),
  );
}

class NewModularApp {
  static get get => ModularApp(
        module: MyModule(),
        child: const MyWidget(),
      );
}

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    Modular.setInitialRoute('/home');
    return MaterialApp.router(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,

      debugShowCheckedModeBanner: false,
      title: 'Exontix music (alpha version)',
      theme: lightTheme,
      // darkTheme: darkTheme,
      routerConfig: Modular.routerConfig,
    );
  }
}

class MyModule extends Module {
  @override
  void binds(i) {}

  @override
  void routes(r) {
    r.child('/', child: (context) => const NavigationPage(), children: [
      ChildRoute(
        '/home',
        child: (context) => const HomePage(),
        transition: TransitionType.rightToLeft,
      ),
      ChildRoute(
        '/profile',
        child: (context) => const ProfilePage(),
        transition: TransitionType.rightToLeft,
      ),
      ChildRoute(
        '/settings',
        child: (context) => const SettingsPage(),
        transition: TransitionType.rightToLeft,
      ),
    ]);
    // r.child("/home", child: (context) => const HomePage());
  }
}
