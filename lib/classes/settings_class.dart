import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsClass {
  bool savingTraffic = false;
  User? user;
  FirebaseAuth auth = FirebaseAuth.instance;
  late final SharedPreferences prefs;

  bool get isLogged => true;

  SettingsClass({required this.prefs}) {
    savingTraffic = prefs.getBool("savingTraffic") ?? false;
  }
}
