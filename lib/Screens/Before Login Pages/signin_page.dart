import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:yume/Utlities/Auth/resuable_comp_auth.dart';
import 'package:yume/Utlities/Auth/user_model.dart' as model;
import 'package:yume/Utlities/Auth/user_provider.dart';
import 'package:yume/Screens/Before%20Login%20Pages/login_page.dart';
import 'package:yume/Screens/HomePage/homepage.dart';
import 'package:yume/Utlities/mainNavBar.dart';

class SignInPage extends StatefulWidget {
  static const String routeName = '/signup';
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPage();
}

class _SignInPage extends State<SignInPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController passConfirmController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    passConfirmController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    ageController.dispose();
    super.dispose();
  }

  Future addUserDetails() async {}

  void signinAuth() async {
    if (emailController.text == '' ||
        passController.text == '' ||
        passConfirmController.text == '' ||
        firstNameController.text == '' ||
        lastNameController.text == '' ||
        ageController.text == '') {
      worngCred("Please Fill all the Fields to Continue", context);
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return const Center(child: CircularProgressIndicator());
          });
      try {
        final error = valdob(ageController.text);
        if (error != null) {
          Navigator.pop(context);
          worngCred(error, context);
        } else if (passController.text == passConfirmController.text) {
          UserCredential cred = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
                  email: emailController.text.trim(),
                  password: passController.text.trim());
          model.User user = model.User(
            uid: cred.user!.uid,
            email: emailController.text.trim(),
            firstname: firstNameController.text.trim(),
            lastname: lastNameController.text.trim(),
            dob: ageController.text,
          );
          await FirebaseFirestore.instance
              .collection('users')
              .doc(cred.user!.uid)
              .set(user.toMap());
          var res = await FirebaseAuth.instance.signInWithEmailAndPassword(
              email: emailController.text, password: passController.text);
          Provider.of<UserProvider>(context, listen: false)
              .setUser(model.User.fromMap(await getuser(res.user!.uid) ?? {}));
          Navigator.pushReplacementNamed(context, MainNavBar.routeName);
        } else {
          Navigator.pop(context);
          worngCred("Passwords Doesn't match!", context);
        }
      } on FirebaseAuthException catch (e) {
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
        // ignore: use_build_context_synchronously
        worngCred(e.code, context);
      }
    }
  }

  Future<Map<String, dynamic>?> getuser(String? uid) async {
    if (uid != null) {
      final snap =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      return snap.data();
    }
    return null;
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
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
                child: Column(
                  children: [
                    SizedBox(
                      height: size.height * 0.04,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        logo(size.height / 5, size.height / 5, context),
                        richText(
                            25, "Let's Create a \nAccount for you!", context),
                        SizedBox(
                          height: size.height * 0.025,
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            textInputField(
                                size: size,
                                controller: firstNameController,
                                inputType: TextInputType.text,
                                hintText: "First name",
                                icon: Icons.person_2_outlined,
                                width: 2.20,
                                context: context),
                            SizedBox(
                              width: size.height * 0.007,
                            ),
                            textInputField(
                                size: size,
                                controller: lastNameController,
                                inputType: TextInputType.text,
                                hintText: "Last name",
                                icon: Icons.person_2_outlined,
                                width: 2.215,
                                context: context),
                          ],
                        ),
                        SizedBox(
                          height: size.height * 0.005,
                        ),
                        textInputField(
                          size: size,
                          controller: ageController,
                          inputType: TextInputType.datetime,
                          hintText: 'Date of Birth (DD/MM/YYYY)',
                          icon: Icons.date_range_outlined,
                          context: context,
                          formatters: [
                            CustomDateTextFormatter(),
                            FilteringTextInputFormatter.allow(RegExp('[0-9/]')),
                            LengthLimitingTextInputFormatter(10)
                          ],
                        ),
                        SizedBox(
                          height: size.height * 0.005,
                        ),
                        textInputField(
                          size: size,
                          controller: emailController,
                          inputType: TextInputType.emailAddress,
                          hintText: 'Enter your email',
                          icon: Icons.email_outlined,
                          context: context,
                        ),
                        SizedBox(
                          height: size.height * 0.005,
                        ),
                        textInputField(
                            size: size,
                            controller: passController,
                            inputType: TextInputType.visiblePassword,
                            hintText: 'Enter your Password',
                            icon: Icons.password_rounded,
                            context: context,
                            ob: true),
                        SizedBox(
                          height: size.height * 0.005,
                        ),
                        textInputField(
                            size: size,
                            controller: passConfirmController,
                            inputType: TextInputType.visiblePassword,
                            hintText: 'Enter your Password',
                            icon: Icons.password_rounded,
                            context: context,
                            ob: true),
                        SizedBox(
                          height: size.height * 0.008,
                        ),
                        styledButton(size, "Sign In", context, signinAuth),
                      ],
                    ),
                    SizedBox(
                      height: size.height * 0.03,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Aleady Have an Account?",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => {Navigator.pop(context)},
                          child: Text(
                            " Log In",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.surface,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
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
