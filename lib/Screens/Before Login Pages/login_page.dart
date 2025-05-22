import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yume/Utlities/Auth/resuable_comp_auth.dart';
import 'package:yume/Utlities/Auth/user_provider.dart';
import 'package:yume/Screens/Before%20Login%20Pages/recovery_pass_page.dart';
import 'package:yume/Screens/Before%20Login%20Pages/signin_page.dart';
import 'package:yume/Utlities/mainNavBar.dart';
import 'package:yume/Utlities/Auth/user_model.dart' as model;

class LogInPage extends StatefulWidget {
  static String routeName = '/login';
  const LogInPage({super.key});

  @override
  State<LogInPage> createState() => _LogInPage();
}

class _LogInPage extends State<LogInPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }

  Future<Map<String, dynamic>?> getuser(String? uid) async {
    if (uid != null) {
      final snap =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      return snap.data();
    }
    return null;
  }

  void loginauth() async {
    if (emailController.text == '' || passController.text == '') {
      worngCred("Please Fill all the Fields to Continue", context);
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return const Center(child: CircularProgressIndicator());
          });
      try {
        var res = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: emailController.text, password: passController.text);
        Provider.of<UserProvider>(context, listen: false)
            .setUser(model.User.fromMap(await getuser(res.user!.uid) ?? {}));
        Navigator.pushReplacementNamed(context, MainNavBar.routeName);
      } on FirebaseAuthException catch (e) {
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
        // ignore: use_build_context_synchronously
        worngCred(e.code, context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.surface,
              Theme.of(context).colorScheme.secondary
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: SafeArea(
            child: Container(
              color: Colors.transparent,
              alignment: Alignment.topCenter,
              width: size.width,
              height: size.height,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        logo(size.height / 4, size.height / 4, context),
                        richText(
                            25, "Welcome Back, \nYou've been Missed!", context),
                        SizedBox(
                          height: size.height * 0.04,
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        textInputField(
                            size: size,
                            controller: emailController,
                            inputType: TextInputType.text,
                            hintText: "Enter your Email",
                            icon: Icons.person_2_outlined,
                            context: context),
                        SizedBox(
                          height: size.height * 0.01,
                        ),
                        textInputField(
                            size: size,
                            controller: passController,
                            inputType: TextInputType.visiblePassword,
                            hintText: "Enter your Password",
                            icon: Icons.password_outlined,
                            context: context,
                            ob: true),
                        SizedBox(
                          height: size.height * 0.01,
                        ),
                        GestureDetector(
                          onTap: () => {
                            Navigator.pushNamed(context, RecoveryPass.routeName)
                          },
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              child: Text(
                                'Recovery Password?',
                                style: TextStyle(
                                  fontSize: 11.0,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .inversePrimary,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.01,
                        ),
                        styledButton(size, "LogIn", context, loginauth),
                        SizedBox(
                          height: size.height * 0.03,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Don’t have an account? ',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.pushNamed(
                                  context, SignInPage.routeName),
                              child: Text(
                                "Sign In",
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.surface,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
