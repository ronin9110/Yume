import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:yume/Utlities/Auth/resuable_comp_auth.dart';
import 'package:yume/Utlities/Auth/user_provider.dart';
import 'package:yume/Screens/Before%20Login%20Pages/welcome_page.dart';
import 'package:yume/Utlities/Auth/user_model.dart' as model;
import 'package:yume/Utlities/NetworkChecker.dart';

class ProfilePage extends StatefulWidget {
  static const String routeName = '/profilepage';
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool res = false;
  bool edit = false;

  void logout() {
    FirebaseAuth.instance.signOut();
    // Navigator.pop(context);
    Navigator.pushReplacementNamed(context, WelcomePage.routeName);
  }

  TextEditingController emailController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController ageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    firstNameController.value = TextEditingValue(
        text: Provider.of<UserProvider>(context).user.firstname.toString());
    lastNameController.value = TextEditingValue(
        text: Provider.of<UserProvider>(context).user.lastname.toString());
    emailController.value = TextEditingValue(
        text: Provider.of<UserProvider>(context).user.email.toString());
    ageController.value = TextEditingValue(
        text: Provider.of<UserProvider>(context).user.dob.toString());
    var user = Provider.of<UserProvider>(context).user;
    final size = MediaQuery.of(context).size;
    void submitEdit() async {
      if (emailController.text == '' ||
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
          } else {
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .update({
              "Date of Birth": ageController.text,
              "Last name": lastNameController.text.trim(),
              "email": emailController.text.trim(),
              "first name": firstNameController.text.trim()
            });
            var snap = await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .get();
            var temp = snap.data();
            Provider.of<UserProvider>(context, listen: false)
                .setUser(model.User.fromMap(temp ?? {}));
            print(
                "Sucker ${Provider.of<UserProvider>(context, listen: false).user.firstname}");
            Navigator.pop(context);
            succsessCred("User Details Updated", context);
            setState(() {
              edit = false;
              user = Provider.of<UserProvider>(context).user;
            });
          }
        } on FirebaseAuthException catch (e) {
          // ignore: use_build_context_synchronously
          Navigator.pop(context);
          // ignore: use_build_context_synchronously
          worngCred(e.code, context);
        }
      }
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        actions: [
          Text(edit ? "Edit:ON" : "Edit:OFF"),
          IconButton(
              onPressed: () {
                setState(() {
                  edit = !edit;
                  print(edit);
                });
              },
              icon: Icon(
                Icons.edit,
                size: 25,
              ))
        ],
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: NetworkChecker(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  maxRadius: 100,
                  child: Icon(
                    Icons.person,
                    size: 150,
                  ),
                ),
                SizedBox(
                  height: size.height * 0.03,
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        textInputField(
                            en: edit,
                            size: size,
                            controller: firstNameController,
                            inputType: TextInputType.text,
                            hintText: user.firstname,
                            icon: Icons.person_2_outlined,
                            width: 2.20,
                            context: context),
                        SizedBox(
                          width: size.height * 0.01,
                        ),
                        Flexible(
                          child: textInputField(
                              en: edit,
                              size: size,
                              controller: lastNameController,
                              inputType: TextInputType.text,
                              hintText: user.lastname,
                              icon: Icons.person_2_outlined,
                              width: 2.232,
                              context: context),
                        ),
                      ],
                    ),
                    textInputField(
                      en: edit,
                      size: size,
                      controller: ageController,
                      inputType: TextInputType.datetime,
                      hintText: user.dob,
                      icon: Icons.date_range_outlined,
                      context: context,
                      formatters: [
                        CustomDateTextFormatter(),
                        FilteringTextInputFormatter.allow(RegExp('[0-9/]')),
                        LengthLimitingTextInputFormatter(10)
                      ],
                    ),
                    SizedBox(
                      height: size.height * 0.001,
                    ),
                    textInputField(
                      en: edit,
                      size: size,
                      controller: emailController,
                      inputType: TextInputType.emailAddress,
                      hintText: user.email,
                      icon: Icons.email_outlined,
                      context: context,
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    edit
                        ? Column(
                            children: [
                              styledButton(
                                  size, "Submit", context, () => submitEdit()),
                              SizedBox(
                                height: size.height * 0.02,
                              ),
                            ],
                          )
                        : SizedBox.shrink(),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    styledButton(size, "LogOut", context, () => logout()),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
