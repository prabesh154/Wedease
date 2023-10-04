import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wedease/consts/consts.dart';
import 'package:wedease/views/splash_screen/auth_screen/login_screen.dart';
import 'package:wedease/widgets_common/applogo_widget.dart';
import 'package:wedease/widgets_common/custom_textfield.dart';
import 'package:wedease/widgets_common/bg_widget.dart';
import 'package:wedease/widgets_common/our_button.dart';
import 'package:wedease/controllers/auth_controller.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool isCheck = false;
  var controller = Get.put(AuthController());

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final retypepasswordController = TextEditingController();

  final emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  // Name validation function
  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name cannot be empty';
    } else if (value.length < 3) {
      return 'Name should be at least 3 characters long';
    } else if (!value.contains(RegExp(r'^[a-zA-Z]'))) {
      return 'Name should contain only alphabetic characters';
    }
    return null;
  }

  // Password validation function
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password cannot be empty';
    } else if (value.length < 5) {
      return 'Password should be at least 5 characters long';
    } else if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password should contain at least one uppercase letter';
    } else if (!value.contains(RegExp(r'[a-z]'))) {
      return 'Password should contain at least one lowercase letter';
    } else if (!value.contains(RegExp(r'\d'))) {
      return 'Password should contain at least one number';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email cannot be empty';
    } else if (!emailRegex.hasMatch(value)) {
      return 'Invalid email address';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return bgWidget(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Center(
          child: Column(
            children: [
              (context.screenHeight * 0.1).heightBox,
              applogoWidget(),
              10.heightBox,
              const Text(
                "Join the $appname",
                style: TextStyle(
                  fontFamily: bold,
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              15.heightBox,
              Obx(
                () => Column(
                  children: [
                    customTextField(
                      hint: nameHint,
                      title: name,
                      validator: validateName,
                      controller: nameController,
                      isPass: false,
                    ),
                    customTextField(
                      hint: emailHint,
                      title: email,
                      controller: emailController,
                      validator: validateEmail,
                      isPass: false,
                    ),
                    customTextField(
                      hint: passwordHint,
                      title: password,
                      controller: passwordController,
                      validator: validatePassword,
                      isPass: true,
                    ),
                    customTextField(
                      hint: passwordHint,
                      title: retypePassword,
                      controller: retypepasswordController,
                      isPass: true,
                    ),
                    Row(
                      children: [
                        Checkbox(
                          checkColor: blueColor,
                          value: isCheck,
                          onChanged: (newValue) {
                            setState(() {
                              isCheck = newValue!;
                            });
                          },
                        ),
                        10.widthBox,
                        Expanded(
                          child: RichText(
                            text: const TextSpan(
                              children: [
                                TextSpan(
                                  text: "I agree to the",
                                  style: TextStyle(
                                    fontFamily: regular,
                                    color: fontGrey,
                                  ),
                                ),
                                TextSpan(
                                  text: termAndCond,
                                  style: TextStyle(
                                    fontFamily: regular,
                                    color: blueColor,
                                  ),
                                ),
                                TextSpan(
                                  text: "&",
                                  style: TextStyle(
                                    fontFamily: regular,
                                    color: fontGrey,
                                  ),
                                ),
                                TextSpan(
                                  text: privacyPolicy,
                                  style: TextStyle(
                                    fontFamily: regular,
                                    color: blueColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    controller.isloading.value
                        ? const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(blueColor),
                          )
                        : ourButton(
                            color: isCheck ? blueColor : lightGrey,
                            title: 'Sign Up',
                            textColor: whiteColor,
                            onPress: () async {
                              bool isSigningUp =
                                  false; // Flag to track signup process

                              if (isCheck != false && !isSigningUp) {
                                isSigningUp =
                                    true; // Set the flag to indicate signup process is ongoing

                                try {
                                  // Validate the form
                                  String? nameError =
                                      validateName(nameController.text);
                                  String? emailError =
                                      validateEmail(emailController.text);
                                  String? passwordError =
                                      validatePassword(passwordController.text);

                                  if (nameError != null) {
                                    VxToast.show(context, msg: nameError);
                                  } else if (emailError != null) {
                                    VxToast.show(context, msg: emailError);
                                  } else if (passwordError != null) {
                                    VxToast.show(context, msg: passwordError);
                                  } else {
                                    // Check if the account already exists
                                    bool accountExists =
                                        await controller.checkAccountExists(
                                            emailController.text);
                                    if (accountExists) {
                                      VxToast.show(context,
                                          msg: 'Account already exists');
                                    } else if (passwordController.text !=
                                        retypepasswordController.text) {
                                      // Passwords do not match, show an error message
                                      VxToast.show(context,
                                          msg: 'Passwords do not match');
                                    } else {
                                      // Account doesn't exist and passwords match, proceed with signup
                                      await controller.signupMethod(
                                        context: context,
                                        email: emailController.text,
                                        password: passwordController.text,
                                      );
                                      await controller.storeUserData(
                                        name: nameController.text,
                                        password: passwordController.text,
                                        email: emailController.text,
                                      );
                                      VxToast.show(context, msg: signedin);
                                      Get.offAll(() => const LoginScreen());
                                    }
                                  }
                                } catch (e) {
                                  auth.signOut();
                                  VxToast.show(context, msg: e.toString());
                                } finally {
                                  // Reset the flag to allow future signup attempts
                                  isSigningUp = false;
                                }
                              }
                            },
                          ).box.width(context.screenWidth - 50).make(),
                    10.heightBox,
                    RichText(
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: alreadyHaveAccount,
                            style: TextStyle(
                              fontFamily: bold,
                              color: fontGrey,
                            ),
                          ),
                          TextSpan(
                            text: login,
                            style: TextStyle(
                              fontFamily: bold,
                              fontWeight: FontWeight.bold,
                              color: blackColor,
                            ),
                          ),
                        ],
                      ),
                    ).onTap(() {
                      Navigator.pop(context);
                    }),
                  ],
                )
                    .box
                    .white
                    .rounded
                    .padding(const EdgeInsets.all(16))
                    .width(context.screenWidth - 50)
                    .make(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
