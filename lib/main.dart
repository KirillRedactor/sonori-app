import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:musicplayer_app/pages/home_page.dart';
import 'package:musicplayer_app/pages/navigation_page.dart';

import 'classes/music_player_class.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    null;
  } else if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    null;
  } else if (Platform.isAndroid) {
    null;
  } else if (Platform.isIOS) {
    null;
  } else {
    null;
  }

  GetIt.I.registerSingleton<MusicPlayerClass>(MusicPlayerClass());

  runApp(NewModularApp.get());
}

class NewModularApp {
  static get() {
    return ModularApp(
      module: MyModule(),
      child: const MyWidget(),
    );
  }
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
      title: 'Exontix music (alpha version)',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        // useMaterial3: true,
        textTheme: GoogleFonts.ralewayTextTheme(),
        // textTheme: GoogleFonts.robotoTextTheme(),
      ),
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
      ChildRoute('/home', child: (context) => const HomePage()),
    ]);
  }
}
