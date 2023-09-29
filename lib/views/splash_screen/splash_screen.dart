import 'package:wedease/consts/consts.dart';
import 'package:wedease/views/splash_screen/auth_screen/login_screen.dart';
import 'package:wedease/widgets_common/applogo_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // method to change screen
  changeScreen() {
    Future.delayed(const Duration(seconds: 3), () {
      Get.to(() => const LoginScreen());
      // auth.authStateChanges().listen((User? user) {
      //   if (user == null && mounted) {
      //     Get.to(() => const LoginScreen());
      //   } else {
      //     Get.to(() => const Home());
      //   }
      // });
    });
  }

  // changeScreen() {
  //   Future.delayed(const Duration(seconds: 3), () {
  //     Get.to(() => const LoginScreen());
  //     auth.authStateChanges().listen((User? user) {
  //       if (user == null && mounted) {
  //         Get.to(() => const LoginScreen());
  //       } else {
  //         Get.to(() => const Home());
  //       }
  //     });
  //   });
  // }

  @override
  void initState() {
    changeScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blueColor,
      body: Center(
        child: Column(
          children: [
            const Spacer(),
            40.heightBox,
            applogoWidget(),
            10.heightBox,
            appname.text.fontFamily(bold).size(22).white.make(),
            5.heightBox,
            appversion.text.white.make(),
            const Spacer(),
            credits.text.white.fontFamily(semibold).make(),
            30.heightBox,
          ],
        ),
      ),
    );
  }
}
