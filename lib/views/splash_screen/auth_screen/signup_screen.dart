import 'package:wedease/consts/consts.dart';
import 'package:wedease/views/splash_screen/auth_screen/login_screen.dart';
//import 'package:wedease/views/splash_screen/auth_screen/login_screen.dart';
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
                      controller: nameController,
                      isPass: false,
                    ),
                    customTextField(
                      hint: emailHint,
                      title: email,
                      controller: emailController,
                      isPass: false,
                    ),
                    customTextField(
                      hint: passwordHint,
                      title: password,
                      controller: passwordController,
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
                                  // Check if the account already exists
                                  bool accountExists = await controller
                                      .checkAccountExists(emailController.text);
                                  if (accountExists) {
                                    // Account already exists, show an error message or take appropriate action
                                    VxToast.show(context,
                                        msg: 'Account already exists');
                                  }
                                  if (passwordController.text !=
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
