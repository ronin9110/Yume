import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:yume/Utlities/Auth/resuable_comp_auth.dart';
import 'package:yume/Screens/Before%20Login%20Pages/login_page.dart';

class WelcomePage extends StatefulWidget {
  static const String routeName = '/welcomepage';
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.secondary,
            Theme.of(context).colorScheme.surface
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Container(
            height: size.height,
            width: size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                logo(size.height / 2.5, size.height / 2.5, context),
                richText(30, "Welcome to Yume,\nTune into Happiness.", context),
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
                  child: styledButton(size, "Get Started", context,
                      () => Navigator.pushNamed(context, LogInPage.routeName)),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
