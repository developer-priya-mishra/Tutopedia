import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tutopedia/components/loading_dialog.dart';
import 'package:tutopedia/constants/styling.dart';
import 'package:tutopedia/screens/signin_screen.dart';
import 'package:tutopedia/services/api_service.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  bool hidePassword = true;
  bool hideConfirmPassword = true;
  bool isLoading = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
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
                    text: "Welcome!",
                    children: const [
                      TextSpan(text: "\nSign up to continue!"),
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
                    return "Please enter your full name";
                  }
                  return null;
                },
                controller: nameController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.person_rounded),
                  labelText: "Name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50.0)),
                  ),
                ),
                keyboardType: TextInputType.name,
              ),
              const SizedBox(height: 15),
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
              const SizedBox(height: 15),
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
              const SizedBox(height: 20),
              const Text(
                "By signing up you are agreed with our friendly terms and condition.",
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
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
                            .signup(
                          name: nameController.text.trim(),
                          email: emailController.text.trim(),
                          password: passwordController.text.trim(),
                          confirmPassword: confirmPasswordController.text.trim(),
                        )
                            .then((value) {
                          setState(() {
                            isLoading = false;
                          });
                          Navigator.pop(context);
                          if (value["success"] == "You have Registered Successfully !!") {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => const SigninScreen(),
                              ),
                            );
                            Fluttertoast.showToast(
                              msg: "Your are successfully sign up.",
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: primaryColor.shade500,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text("Already registered"),
                                content: const Text("A user is already registered with this email, please use some other email."),
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
                              content: const Text("Unable to sign up, please try again."),
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
                "Already have an account?",
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 5.0),
              InkWell(
                onTap: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const SigninScreen(),
                    ),
                  );
                },
                borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                child: const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    "Sign in",
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
