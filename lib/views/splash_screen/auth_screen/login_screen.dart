import 'package:wedease/consts/consts.dart';
import 'package:wedease/consts/lists.dart';
import 'package:wedease/controllers/auth_controller.dart';
import 'package:wedease/views/home_screen/home.dart';
import 'package:wedease/views/splash_screen/auth_screen/signup_screen.dart';
import 'package:wedease/widgets_common/applogo_widget.dart';
import 'package:wedease/widgets_common/bg_widget.dart';
import 'package:wedease/widgets_common/our_button.dart';

final emailController = TextEditingController();
final passwordController = TextEditingController();

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(AuthController());
    return bgWidget(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Center(
          child: Column(
            children: [
              (context.screenHeight * 0.1).heightBox,
              applogoWidget(),
              10.heightBox,
              "Log In $appname".text.fontFamily(bold).white.size(20).make(),
              15.heightBox,
              Obx(
                () => Column(
                  children: [
                    TextField(
                      controller: controller.emailController,
                      decoration: const InputDecoration(
                        hintText: emailHint,
                        labelText: email,
                      ),
                      obscureText: false,
                    ),
                    TextField(
                      controller: controller.passwordController,
                      decoration: const InputDecoration(
                        hintText: passwordHint,
                        labelText: password,
                      ),
                      obscureText: true,
                    ),
                    5.heightBox,
                    controller.isloading.value
                        ? const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(blueColor),
                          )
                        : ourButton(
                            color: blueColor,
                            title: login,
                            textColor: whiteColor,
                            onPress: () async {
                              controller.isloading(true);
                              await controller
                                  .loginMethod(context: context)
                                  .then((value) {
                                if (value != null) {
                                  VxToast.show(context, msg: loggedin);
                                  Get.offAll(() => const Home());
                                } else {
                                  controller.isloading(false);
                                }
                              });
                            },
                          ).box.width(context.screenWidth - 50).make(),
                    10.heightBox,
                    const Text(
                      "Not Registered?",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontFamily: bold,
                      ),
                    ),
                    const Text(
                      "Create an Accoount",
                      style: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 14,
                        fontFamily: bold,
                      ),
                    ),
                    15.heightBox,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ourButton(
                            color: lightGolden,
                            title: "Signup",
                            textColor: blueColor,
                            onPress: () {
                              // user logic
                              Get.to(() => const SignupScreen());
                            },
                          ).box.make(),
                        ),
                        // const SizedBox(width: 5),
                        // Expanded(
                        //   child: ourButton(
                        //     color: lightGolden,
                        //     title: "service",
                        //     textColor: blueColor,
                        //     onPress: () {
                        //       // service logic
                        //       Get.to(() => const SignupScreen());
                        //     },
                        //   ).box.make(),
                        // ),
                      ],
                    ),
                    10.heightBox,
                  ],
                )
                    .box
                    .white
                    .rounded
                    .padding(const EdgeInsets.all(16))
                    .width(context.screenWidth - 70)
                    .shadowSm
                    .make(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
