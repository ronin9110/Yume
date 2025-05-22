import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:yume/Utlities/Auth/resuable_comp_auth.dart';

class RecoveryPass extends StatefulWidget {
  static const String routeName = '/recover';
  const RecoveryPass({super.key});

  @override
  State<RecoveryPass> createState() => _RecoveryPassState();
}

class _RecoveryPassState extends State<RecoveryPass> {
  TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future emailRecover() async {
    if (emailController.text == '') {
      worngCred("Please Enter the Email", context);
    } else {
      try {
        await FirebaseAuth.instance
            .sendPasswordResetEmail(email: emailController.text);
        showDialog(
          // ignore: use_build_context_synchronously
          context: context,
          builder: (context) {
            return AlertDialog(
              icon: const Icon(
                Icons.mark_email_read_outlined,
                size: 50,
              ),
              title: const Center(
                child: Text(
                  "Reset Mail Sent",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
              ),
              elevation: 20,
              shadowColor: Theme.of(context).colorScheme.primary,
            );
          },
        );
      } on FirebaseAuthException catch (e) {
        worngCred(e.code.toString(), context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back)),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
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
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
            child: Column(
              children: [
                const Text(
                  "Recover Password",
                  style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: size.height * 0.025,
                ),
                textInputField(
                    size: size,
                    controller: emailController,
                    inputType: TextInputType.emailAddress,
                    hintText: "Enter the email",
                    icon: Icons.mail_outline_outlined,
                    context: context),
                SizedBox(
                  height: size.height * 0.015,
                ),
                styledButton(size, "Reset Password", context, emailRecover)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
