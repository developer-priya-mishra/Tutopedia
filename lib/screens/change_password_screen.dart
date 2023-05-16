import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tutopedia/components/loading_dialog.dart';
import 'package:tutopedia/constants/hive_boxes.dart';
import 'package:tutopedia/constants/styling.dart';
import 'package:tutopedia/services/api_service.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  bool hidePassword = true;
  bool hideConfirmPassword = true;
  bool isLoading = false;

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
            size: 22.0,
          ),
          splashRadius: 25.0,
          tooltip: "Back",
        ),
        title: Text(
          "Create New Password",
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Form(
          key: formkey,
          child: ListView(
            padding: const EdgeInsets.all(15.0),
            children: [
              SvgPicture.asset(
                'assets/svg/change_password.svg',
                width: MediaQuery.of(context).size.width * 0.85,
              ),
              const SizedBox(height: 15.0),
              const Text(
                "Set the new password for your account so you can login and access all the features.",
                style: TextStyle(
                  fontSize: 18.0,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                validator: (value) {
                  if (value != null && value.trim() == "") {
                    return "Please enter your password";
                  }
                  if (value!.length < 8) {
                    return "Password must be atleast 8 characters";
                  }
                  return null;
                },
                controller: passwordController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.password_rounded),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        hidePassword = !hidePassword;
                      });
                    },
                    icon: hidePassword ? const Icon(Icons.visibility_rounded) : const Icon(Icons.visibility_off_rounded),
                    splashRadius: 20.0,
                    tooltip: hidePassword ? "View" : "Hide",
                  ),
                  labelText: "Password",
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50.0)),
                  ),
                ),
                obscureText: hidePassword,
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 15),
              TextFormField(
                validator: (value) {
                  if (value != null && value.trim() == "") {
                    return "Please confirm your password";
                  }
                  if (passwordController.text != confirmPasswordController.text) {
                    return "Password do not match";
                  }
                  return null;
                },
                controller: confirmPasswordController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.password_rounded),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        hideConfirmPassword = !hideConfirmPassword;
                      });
                    },
                    icon: hideConfirmPassword ? const Icon(Icons.visibility_rounded) : const Icon(Icons.visibility_off_rounded),
                    splashRadius: 20.0,
                    tooltip: hideConfirmPassword ? "View" : "Hide",
                  ),
                  labelText: "Confirm Password",
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50.0)),
                  ),
                ),
                obscureText: hideConfirmPassword,
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 15.0),
              SizedBox(
                height: 50.0,
                width: MediaQuery.of(context).size.width,
                child: TextButton(
                  onPressed: () {
                    if (formkey.currentState!.validate() == true) {
                      formkey.currentState!.save();
                      if (!isLoading) {
                        setState(() {
                          isLoading = true;
                        });
                        LoadingDialog(context);
                        ApiService()
                            .changePassword(
                          password: passwordController.text.trim(),
                          confirmPassword: confirmPasswordController.text.trim(),
                          token: authInfoBox.get("authToken"),
                        )
                            .then((value) {
                          setState(() {
                            isLoading = false;
                          });
                          Navigator.pop(context);
                          if (value["message"] == "Your password has been changed") {
                            authInfoBox.put('name', "");
                            authInfoBox.put('email', "");
                            authInfoBox.put('profilePhoto', "");
                            authInfoBox.put('authToken', "");

                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text("Password Changed"),
                                content: const Text("Your password has been successfully changed, please sign in again."),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Okay"),
                                  )
                                ],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                                actionsPadding: const EdgeInsets.only(bottom: 12.0, right: 15.0),
                              ),
                            );
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text("Something went wrong"),
                                content: const Text("Unable to change password, please try again."),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Okay"),
                                  )
                                ],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                                actionsPadding: const EdgeInsets.only(bottom: 12.0, right: 15.0),
                              ),
                            );
                          }
                        }).onError((error, stackTrace) {
                          setState(() {
                            isLoading = false;
                          });
                          Navigator.pop(context);
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text("Got some error"),
                              content: const Text("Unable to change password, please try again."),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text("Okay"),
                                )
                              ],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              actionsPadding: const EdgeInsets.only(bottom: 12.0, right: 15.0),
                            ),
                          );
                        });
                      }
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(primaryColor),
                  ),
                  child: const Text(
                    "Submit",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
