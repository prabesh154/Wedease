import 'package:wedease/consts/consts.dart';
import 'package:wedease/controllers/home_controller.dart';
import 'package:wedease/views/save_screen/save_screen.dart';
import 'package:wedease/views/service_screen/service_screen.dart';
import 'package:wedease/views/home_screen/home_screen.dart';
import 'package:wedease/views/profile_screen/profile_screen.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  get home => null;

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(HomeController());

    var navbarItem = [
      BottomNavigationBarItem(
          icon: Image.asset(icHome, width: 26), label: 'Home'),
      BottomNavigationBarItem(
          icon: Image.asset(icservice, width: 26), label: 'services'),
      BottomNavigationBarItem(
          icon: Image.asset(icSave, width: 26), label: 'Saved'),
      BottomNavigationBarItem(
          icon: Image.asset(icProfile, width: 26), label: 'Account'),
    ];

    var navBody = [
      const HomeScreen(),
      const ServiceScreen(),
      const SaveScreen(),
      const ProfileScreen()
    ];

    return Scaffold(
      body: Column(
        children: [
          Obx(() => Expanded(
              child: navBody.elementAt(controller.currentNavIndex.value))),
        ],
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: controller.currentNavIndex.value,
          selectedItemColor: blueColor,
          selectedLabelStyle: const TextStyle(fontFamily: semibold),
          type: BottomNavigationBarType.fixed,
          backgroundColor: whiteColor,
          items: navbarItem,
          onTap: (value) {
            controller.currentNavIndex.value = value;
          },
        ),
      ),
    );
  }
}
