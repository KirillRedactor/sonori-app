import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:musicplayer_app/classes/classes_shortcuts.dart';
import 'package:musicplayer_app/classes/profile_class.dart';
import 'package:musicplayer_app/classes/user_class.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsClass {
  bool savingTraffic = false;
  late final SharedPreferences prefs;

  //* Auth part
  UserCredential? userCredential;
  String? email;
  String? password;
  FirebaseAuth auth = FirebaseAuth.instance;
  UserClass? user;

  String get hiddenEmail {
    String res = "";
    if (email != null && email != "") {
      int to = settings.email!.indexOf("@") - 2;
      res = email!.replaceRange(2, to, "*" * (to - 2));
    }
    return res;
  }

  Future<bool> get isLogged async {
    if (email != null && password != null) {
      userCredential == null ? tryLogIn() : null;
      return true;
    }
    return false;
  }

  SettingsClass({required this.prefs}) {
    // userCredential = prefs.getString("userCredential");
    email = prefs.getString("email");
    password = prefs.getString("password");
    savingTraffic = prefs.getBool("savingTraffic") ?? false;
  }

  Future<bool> tryLogIn() async {
    if (email != null && password != null) {
      try {
        userCredential = await auth.signInWithEmailAndPassword(
          email: email!,
          password: password!,
        );
        user = await fc.getUserFromEmailAndPassword(email!, password!);
        return true;
      } on FirebaseAuthException catch (e) {
        print(e);
        Modular.to.navigate("/login");
        return false;
      }
    }
    Modular.to.navigate("/login");
    return false;
  }

  void logIn({
    UserCredential? userCredential,
    String? email,
    String? password,
  }) async {
    this.userCredential = userCredential;
    if (email != null && password != null) {
      this.email = email;
      this.password = password;
      prefs.setString("email", email);
      prefs.setString("password", password);
      user = await fc.getUserFromEmailAndPassword(email, password);
    }
  }

  void registration({
    UserCredential? userCredential,
    String? email,
    String? password,
    String? name,
  }) async {
    this.userCredential = userCredential;
    if (email != null && password != null && name != null) {
      this.email = email;
      this.password = password;
      prefs.setString("email", email);
      prefs.setString("password", password);

      final id = await fc.getIdForUser();
      final userClass = UserClass(
        id: id,
        email: email,
        password: password,
        name: name,
        avatarUri: "",
      );
      final profileClass = ProfileClass(
        id: id,
        name: name,
        avatarUri: "",
      );
      await fc.createUser(userClass, profileClass);
      user = await fc.getUser(id);
    }
  }

  void signOut() async {
    prefs.remove("email");
    prefs.remove("password");
    email = null;
    password = null;
    user = null;
    userCredential = null;
    auth.signOut();

    Modular.to.navigate("/login");
  }
}
