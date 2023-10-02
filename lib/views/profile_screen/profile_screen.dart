import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart'; // Import url_launcher package
import 'package:wedease/controllers/auth_controller.dart';
import 'package:wedease/controllers/profile_controller.dart';
import 'package:wedease/consts/consts.dart';
import 'package:wedease/consts/lists.dart';
import 'package:wedease/views/profile_screen/edit_profile_screen.dart';
import 'package:wedease/views/splash_screen/auth_screen/login_screen.dart';
import 'package:wedease/widgets_common/bg_widget.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  void sendEmail() async {
    final Uri _emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'studentproblem2020@gmail.com', // Replace with your Gmail address
      queryParameters: {
        'subject': 'Feedback/Inquiry from WeDease App', // Set the email subject
      },
    );

    final String emailUri = _emailLaunchUri.toString();

    if (await canLaunch(emailUri)) {
      await launch(emailUri);
    } else {
      // Handle error, e.g., show an error message to the user
      print('Could not launch email');
    }
  }

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProfileController());
    return bgWidget(
      child: Scaffold(
        body: StreamBuilder<DocumentSnapshot>(
          stream: FirestorServices.getUser(currentUser!.uid),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(blueColor),
                ),
              );
            } else if (!snapshot.hasData || !snapshot.data!.exists) {
              return const Center(
                child: Text("No data available."),
              );
            } else {
              var data = snapshot.data!.data() as Map<String, dynamic>;
              return SafeArea(
                child: Column(
                  children: [
                    // edit profile button
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Align(
                        alignment: Alignment.centerRight,
                        child: Icon(
                          Icons.edit,
                          color: whiteColor,
                        ),
                      ).onTap(() {
                        controller.nameController.text = data['name'];
                        Get.to(() => EditProfileScreen(data: data));
                        print(data);
                      }),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          data['imageUrl'] == ''
                              ? Image.asset(imgProfile,
                                      width: 100, fit: BoxFit.cover)
                                  .box
                                  .roundedFull
                                  .clip(Clip.antiAlias)
                                  .make()
                              : Image.network(data['imageUrl'],
                                      width: 100, fit: BoxFit.cover)
                                  .box
                                  .roundedFull
                                  .clip(Clip.antiAlias)
                                  .make(),
                          10.widthBox,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                "${data['name']}"
                                    .text
                                    .fontFamily(semibold)
                                    .white
                                    .make(),
                                5.heightBox,
                                "${data['email']}".text.white.make(),
                              ],
                            ),
                          ),
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: whiteColor),
                            ),
                            onPressed: () async {
                              VxToast.show(context, msg: loggedout);
                              await Get.put(AuthController())
                                  .signoutMethod(context);
                              Get.offAll(() => const LoginScreen());
                            },
                            child: const Text(
                              'Logout',
                              style: TextStyle(
                                fontFamily: semibold,
                                color: whiteColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // button section
                    ListView.separated(
                      shrinkWrap: true,
                      separatorBuilder: (context, index) {
                        return const Divider(
                          color: lightGrey,
                          height: 10,
                        );
                      },
                      itemCount: profileButtonsList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          leading: Image.asset(
                            profileButtonsIcon[index],
                            width: 30,
                          ),
                          title: profileButtonsList[index]
                              .text
                              .fontFamily(semibold)
                              .color(darkFontGrey)
                              .make(),
                          onTap: () {
                            if (profileButtonsList[index] == mail) {
                              sendEmail(); // Execute sendEmail function for "Mail Us" button
                            } else {
                              // Handle other button taps if needed
                            }
                          },
                        );
                      },
                    )
                        .box
                        .gray100
                        .rounded
                        .margin(const EdgeInsets.all(6))
                        .padding(
                          const EdgeInsets.symmetric(horizontal: 16),
                        )
                        .shadowSm
                        .make()
                        .box
                        .color(lightGrey)
                        .make(),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
