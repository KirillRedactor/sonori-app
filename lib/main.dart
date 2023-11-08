import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization_loader/easy_localization_loader.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get_it/get_it.dart';
import 'package:musicplayer_app/classes/classes_shortcuts.dart';
import 'package:musicplayer_app/classes/firebaseclass.dart';
import 'package:musicplayer_app/classes/settings_class.dart';
import 'package:musicplayer_app/firebase_options.dart';
import 'package:musicplayer_app/pages/error_page.dart';
import 'package:musicplayer_app/pages/home_page.dart';
import 'package:musicplayer_app/pages/login_page.dart';
import 'package:musicplayer_app/pages/navigation_page.dart';
import 'package:musicplayer_app/pages/playlist_page.dart';
import 'package:musicplayer_app/pages/profile_page.dart';
import 'package:musicplayer_app/pages/registration_page.dart';
import 'package:musicplayer_app/pages/settings_page.dart';
import 'package:musicplayer_app/themes/light_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_strategy/url_strategy.dart';

import 'classes/music_player_class.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ru')],
      fallbackLocale: const Locale('en'),
      path: 'assets/translations',
      assetLoader: const YamlAssetLoader(),
      child: NewModularApp.get,
    ),
  );

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

  GetIt.I.registerSingleton<SettingsClass>(
      SettingsClass(prefs: await SharedPreferences.getInstance()));
  GetIt.I.registerSingleton<MusicPlayerClass>(MusicPlayerClass());
  GetIt.I.registerSingleton<FirabaseClass>(FirabaseClass());

  // runApp(NewModularApp.get);
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

class AuthGuard extends RouteGuard {
  AuthGuard() : super(redirectTo: '/login');

  @override
  Future<bool> canActivate(String path, ModularRoute route) async {
    return settings.isLogged;
  }
}

class MyModule extends Module {
  @override
  void binds(i) {}

  @override
  void routes(r) {
    r.child("/login", child: (context) => const LoginPage());
    r.child("/registration", child: (context) => const RegistrationPage());
    r.child(
      '/',
      child: (context) => const NavigationPage(),
      guards: [AuthGuard()],
      children: [
        ChildRoute(
          '/home',
          child: (context) => const HomePage(),
          transition: TransitionType.fadeIn,
        ),
        ChildRoute(
          '/playlist/:playlistId',
          child: (context) =>
              PlaylistPage(playlistId: r.args.params['playlistId']),
          transition: TransitionType.fadeIn,
        ),
        ChildRoute(
          '/profile',
          child: (context) => const ProfilePage(),
          transition: TransitionType.fadeIn,
        ),
        ChildRoute(
          '/profile/:userId',
          child: (context) => ProfilePage(userId: r.args.params['userId']),
          transition: TransitionType.fadeIn,
        ),
        ChildRoute(
          '/settings',
          child: (context) => const SettingsPage(),
          transition: TransitionType.fadeIn,
        ),
        ChildRoute(
          '/error',
          child: (context) => const ErrorPage(),
          transition: TransitionType.fadeIn,
        ),
        WildcardRoute(child: (context) => const ErrorPage()),
      ],
    );
    // r.child("/home", child: (context) => const HomePage());
  }
}
