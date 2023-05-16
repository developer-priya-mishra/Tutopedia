import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tutopedia/components/loading_dialog.dart';
import 'package:tutopedia/constants/hive_boxes.dart';
import 'package:tutopedia/constants/styling.dart';
import 'package:tutopedia/screens/email_verify_screen.dart';
import 'package:tutopedia/services/api_service.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();

  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
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
          "Forgot Password",
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
                'assets/svg/forgot_password.svg',
                width: MediaQuery.of(context).size.width,
              ),
              const SizedBox(height: 15.0),
              const Text(
                "Please enter your email address to receive a verification code.",
                style: TextStyle(
                  fontSize: 18.0,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                validator: (value) {
                  if (value != null && value.trim() == "") {
                    return "Please enter your email";
                  }
                  if (!EmailValidator.validate(value!)) {
                    return "Please enter a valid email";
                  }
                  return null;
                },
                controller: emailController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.email_rounded),
                  labelText: "Email",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50.0)),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20.0),
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
                        ApiService().forgotPassword(emailController.text.trim()).then((value) {
                          setState(() {
                            isLoading = false;
                          });
                          Navigator.pop(context);
                          if (value["success"] == true) {
                            authInfoBox.put('name', "");
                            authInfoBox.put('email', emailController.text.trim());
                            authInfoBox.put('profilePhoto', "");
                            authInfoBox.put('authToken', value["data"]["token"] ?? "");

                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const EmailVerifyScreen(),
                              ),
                            );
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text("Invalid email"),
                                content: const Text("Unable to verfiy email, please try again."),
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
                              content: const Text("Unable to proceed, please try again."),
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
