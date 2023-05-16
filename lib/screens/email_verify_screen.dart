import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tutopedia/components/loading_dialog.dart';
import 'package:tutopedia/constants/hive_boxes.dart';
import 'package:tutopedia/constants/styling.dart';
import 'package:tutopedia/screens/change_password_screen.dart';
import 'package:tutopedia/services/api_service.dart';

class EmailVerifyScreen extends StatefulWidget {
  const EmailVerifyScreen({super.key});

  @override
  State<EmailVerifyScreen> createState() => _EmailVerifyScreenState();
}

class _EmailVerifyScreenState extends State<EmailVerifyScreen> {
  final TextEditingController otpController = TextEditingController();

  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  bool isLoading = false;

  @override
  void dispose() {
    otpController.dispose();
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
          "Verify your email",
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
                'assets/svg/email_verify.svg',
                width: MediaQuery.of(context).size.width,
              ),
              const SizedBox(height: 15.0),
              Text(
                "Please enter the 4 digit code sent to ${authInfoBox.get("email")}.",
                style: const TextStyle(
                  fontSize: 18.0,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                validator: (value) {
                  if (value != null && value.trim() == "") {
                    return "Please enter the otp";
                  }
                  return null;
                },
                controller: otpController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.password_rounded),
                  labelText: "OTP",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50.0)),
                  ),
                  counterText: "",
                ),
                keyboardType: TextInputType.number,
                maxLength: 4,
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
                        ApiService()
                            .verifyEmail(
                          otp: otpController.text.trim(),
                          token: authInfoBox.get("authToken"),
                        )
                            .then((value) {
                          setState(() {
                            isLoading = false;
                          });
                          Navigator.pop(context);
                          if (value["success"] == "You Can Change Your Password !") {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => const ChangePasswordScreen(),
                              ),
                            );
                          } else if (value["error"] == "access denied") {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text("Access Denied"),
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
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text("Invalid OTP"),
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
