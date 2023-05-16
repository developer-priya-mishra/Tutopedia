import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tutopedia/components/loading_dialog.dart';
import 'package:tutopedia/constants/hive_boxes.dart';
import 'package:tutopedia/constants/styling.dart';
import 'package:tutopedia/screens/forgot_password_screen.dart';
import 'package:tutopedia/screens/signup_screen.dart';
import 'package:tutopedia/services/api_service.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  bool hidePassword = true;
  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: formkey,
          child: ListView(
            padding: const EdgeInsets.all(15.0),
            children: [
              const SizedBox(height: 40.0),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: RichText(
                  text: TextSpan(
                    text: "Welcome back!",
                    children: const [
                      TextSpan(text: "\nSign in to continue!"),
                    ],
                    style: TextStyle(
                      fontSize: 30.0,
                      color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                      fontWeight: FontWeight.w500,
                      fontFamily: secondaryFont,
                    ),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 30.0),
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
              const SizedBox(height: 15.0),
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
              const SizedBox(height: 5.0),
              Container(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const ForgotPasswordScreen(),
                      ),
                    );
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 5.0),
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
                            .signin(
                          email: emailController.text.trim(),
                          password: passwordController.text.trim(),
                        )
                            .then((value) {
                          if (value["success"] == true) {
                            ApiService().myCourses(value["data"]["token"]).then((myCourseList) {
                              setState(() {
                                isLoading = false;
                              });
                              Navigator.pop(context);

                              for (var item in myCourseList) {
                                myCoursesBox.put(item.id, 0.0);
                              }

                              authInfoBox.put('name', value["data"]["name"] ?? "");
                              authInfoBox.put('email', value["data"]["email"] ?? "");
                              authInfoBox.put('profilePhoto', value["data"]["profile_image"] ?? "");
                              authInfoBox.put('authToken', value["data"]["token"] ?? "");

                              Navigator.of(context).pop();
                              Fluttertoast.showToast(
                                msg: "Your are successfully sign in.",
                                gravity: ToastGravity.BOTTOM,
                                backgroundColor: primaryColor.shade500,
                                textColor: Colors.white,
                                fontSize: 16.0,
                              );
                            }).onError((error, stackTrace) {
                              setState(() {
                                isLoading = false;
                              });
                              Navigator.pop(context);
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text("Got some error"),
                                  content: const Text("Unable to sign in, please try again."),
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
                          } else {
                            setState(() {
                              isLoading = false;
                            });
                            Navigator.pop(context);
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text("Signing failed"),
                                content: const Text("That email and password combination didn't work. Try again."),
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
                              content: const Text("Unable to sign in, please try again."),
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
              const SizedBox(height: 25.0),
              const Text(
                "Don't have an account?",
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 5.0),
              InkWell(
                onTap: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const SignupScreen(),
                    ),
                  );
                },
                borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                child: const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    "Sign up",
                    style: TextStyle(
                      color: primaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
            ],
          ),
        ),
      ),
    );
  }
}
