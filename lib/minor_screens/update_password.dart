// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ms_customer_app/providers/auht_repo.dart';
import 'package:ms_customer_app/widgets/appbar_widgets.dart';
import 'package:ms_customer_app/widgets/snackbar.dart';
import 'package:ms_customer_app/widgets/yellow_button.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';

class UpdatePassword extends StatefulWidget {
  const UpdatePassword({Key? key}) : super(key: key);

  @override
  State<UpdatePassword> createState() => _UpdatePasswordState();
}

class _UpdatePasswordState extends State<UpdatePassword> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();

  bool checkOldPasswordValidation = true;

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: scaffoldKey,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            title: const AppBarTitle(title: 'Change Password'),
            leading: const AppBarBackButton()),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 50, 10, 30),
            child: Form(
              key: formKey,
              child: Column(children: [
                const Text(
                  'to Change your password  please fill in the form below  and click Save Changes',
                  style: TextStyle(
                      fontSize: 20,
                      letterSpacing: 1.1,
                      color: Colors.blueGrey,
                      fontFamily: 'Acme',
                      fontStyle: FontStyle.italic),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'enter your password';
                      }
                      return null;
                    },
                    controller: oldPasswordController,
                    decoration: passwordFormDecoration.copyWith(
                      labelText: 'Old Password',
                      hintText: 'Enter your Current Password',
                      errorText: checkOldPasswordValidation != true
                          ? 'not valid password'
                          : null,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'enter new password';
                      }
                      return null;
                    },
                    controller: newPasswordController,
                    decoration: passwordFormDecoration.copyWith(
                      labelText: 'New Password',
                      hintText: 'Enter your New Password',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    validator: (value) {
                      if (value != newPasswordController.text) {
                        return 'Password Not Maching';
                      } else if (value!.isEmpty) {
                        return 'Re-Enter New password';
                      }
                      return null;
                    },
                    decoration: passwordFormDecoration.copyWith(
                      labelText: 'Repeat Password',
                      hintText: 'Re-Enter your New Password',
                    ),
                  ),
                ),
                FlutterPwValidator(
                    controller: newPasswordController,
                    minLength: 8,
                    uppercaseCharCount: 1,
                    numericCharCount: 2,
                    specialCharCount: 1,
                    width: 400,
                    height: 150,
                    onSuccess: () {},
                    onFail: () {}),
                const Spacer(),
                YellowButton(
                  label: 'Save Changes',
                  onPressed: () async {
                    print(FirebaseAuth.instance.currentUser);
                    if (formKey.currentState!.validate()) {
                      checkOldPasswordValidation =
                          await AuthRepo.checkOldPassword(
                              FirebaseAuth.instance.currentUser!.email!,
                              oldPasswordController.text);
                      setState(() {});
                      checkOldPasswordValidation == true
                          ? await AuthRepo.updateUserPassword(
                                  newPasswordController.text.trim())
                              .whenComplete(() {
                              formKey.currentState!.reset();
                              newPasswordController.clear();
                              newPasswordController.clear();
                              MyMessageHandler.showSnackBar(scaffoldKey,
                                  'your password has been updated');
                              Future.delayed(const Duration(seconds: 3))
                                  .whenComplete(() => Navigator.pop(context));
                            })
                          : print('not valid old password');
                      print('form valid');
                    } else {
                      print('form not valid');
                    }
                  },
                  width: 0.7,
                )
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

var passwordFormDecoration = InputDecoration(
  labelText: 'Full Name',
  hintText: 'Enter your full name',
  border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
  enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.purple, width: 1),
      borderRadius: BorderRadius.circular(6)),
  focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.deepPurpleAccent, width: 2),
      borderRadius: BorderRadius.circular(6)),
);
