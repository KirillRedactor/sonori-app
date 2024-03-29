import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:gap/gap.dart';
import 'package:musicplayer_app/classes/classes_shortcuts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  late final TextEditingController nameController;

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  void signUserIn() async {
    late UserCredential userCredential;
    try {
      userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      // await FirebaseAuth.instance.signInWithCustomToken(token)
    } on FirebaseAuthException catch (e) {
      return print(e);
    }

    settings.logIn(
      userCredential: userCredential,
      email: emailController.text,
      password: passwordController.text,
    );

    Modular.to.navigate('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 253, 89, 22),
              Color.fromARGB(255, 244, 49, 166),
              Color.fromARGB(255, 204, 52, 198),
            ],
          ).createShader(bounds),
          child: const Text(
            "Login",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 30,
            ),
          ),
        ),
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(25),
                  child: ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color.fromARGB(255, 253, 89, 22),
                        Color.fromARGB(255, 244, 49, 166),
                        Color.fromARGB(255, 204, 52, 198),
                      ],
                    ).createShader(bounds),
                    child: const Icon(
                      Icons.music_note_rounded,
                      size: 100,
                      fill: 1.0,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(25),
                  child: TextField(
                    controller: emailController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: "Email",
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade400),
                      ),
                      fillColor: Colors.grey.shade900,
                      filled: true,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(25),
                  child: TextField(
                    controller: passwordController,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: "Password",
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade400),
                      ),
                      fillColor: Colors.grey.shade900,
                      filled: true,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(25),
                  child: GestureDetector(
                    onTap: signUserIn,
                    child: Container(
                      padding: const EdgeInsets.all(25),
                      // margin: const EdgeInsets.symmetric(horizontal: 25),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Text(
                          "Sign in",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 0),
                  child: TextButton(
                    onPressed: () => Modular.to.navigate("/registration"),
                    child: Text(
                      "Sign up",
                      style: TextStyle(
                        // color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                Gap(100),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
