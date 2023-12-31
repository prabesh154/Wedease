import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
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
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'rijalprabesh154@gmail.com', // Replace with your Gmail address
      queryParameters: {
        'subject': 'Feedback/Inquiry for WedEase App', // Set the email subject
      },
    );

    final String emailUri = emailLaunchUri.toString();

    if (await canLaunch(emailUri)) {
      await launch(emailUri);
    } else {
      // Handle error, e.g., show an error message to the user
      print('Could not launch email');
    }
  }

  void sendSMS() async {
    final Uri smsLaunchUri = Uri(
      scheme: 'sms',
      path: '+977 9860807203', // Replace with the recipient's phone number
      queryParameters: {
        'body': 'Feedback to WedEase', // Set the SMS body
      },
    );

    final String smsUri = smsLaunchUri.toString();

    if (await canLaunch(smsUri)) {
      await launch(smsUri);
    } else {
      // Handle error, e.g., show an error message to the user
      print('Could not launch SMS');
    }
  }

  void openDialer() async {
    final Uri dialLaunchUri = Uri(
      scheme: 'tel',
      path: '+9779860807203', // Replace with the phone number you want to dial
    );

    final String dialUri = dialLaunchUri.toString();

    if (await canLaunch(dialUri)) {
      await launch(dialUri);
    } else {
      // Handle error, e.g., show an error message to the user
      print('Could not open the dialer');
    }
  }

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProfileController());
    print("user id ${currentUser!.uid}");
    return Scaffold(
      backgroundColor: whiteColor,
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
          } else if (!snapshot.hasData) {
            return const Center(
              child: Text("No data available."),
            );
          } else {
            var data = snapshot.data!.data() as Map<String, dynamic>;
            return SafeArea(
              child: Column(
                children: [
                  // Edit profile button
                  Padding(
                    padding: const EdgeInsets.only(right: 14, top: 10),
                    child: const Align(
                      alignment: Alignment.centerRight,
                      child: Icon(
                        Icons.edit,
                        color: blackColor,
                      ),
                    ).onTap(() {
                      controller.nameController.text = data['name'];
                      Get.to(() => EditProfileScreen(data: data));
                      print(data);
                    }),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(1.0),
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
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              "${data['name']}"
                                  .text
                                  .size(18)
                                  .fontFamily(bold)
                                  .black
                                  .make(),
                              5.heightBox,
                              " ${data['email']}".text.black.make(),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: blackColor),
                            ),
                            onPressed: () {
                              // Show a confirmation dialog
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Logout Confirmation'),
                                    content: const Text(
                                        'Are you sure you want to logout?'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pop(); // Close the dialog
                                        },
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          // Perform logout and navigate to the login screen
                                          VxToast.show(context, msg: loggedout);
                                          await Get.put(AuthController())
                                              .signoutMethod(context);
                                          Get.offAll(() => const LoginScreen());
                                        },
                                        child: const Text('Logout'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: const Text(
                              'Logout',
                              style: TextStyle(
                                fontFamily: semibold,
                                color: blackColor,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  30.heightBox,
                  const Divider(
                    thickness: 3,
                    color: fontGrey,
                  ),

                  // Button section
                  SingleChildScrollView(
                    child: ListView.separated(
                      shrinkWrap: true,
                      separatorBuilder: (context, index) {
                        return const Divider(
                          color: blackColor,
                        );
                      },
                      itemCount: profileButtonsList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          child: ListTile(
                            leading: Image.asset(
                              profileButtonsIcon[index],
                              width: 30,
                            ),
                            title: profileButtonsList[index]
                                .text
                                .fontFamily(semibold)
                                .color(blackColor)
                                .make(),
                            onTap: () {
                              if (profileButtonsList[index] == mail) {
                                sendEmail(); // Execute sendEmail function for "Mail Us" button
                              } else if (profileButtonsList[index] == chat) {
                                sendSMS(); // Execute sendSMS function for "Contact Us" button
                              } else if (profileButtonsList[index] == contact) {
                                openDialer(); // Execute openDialer function for "Contact Us" button
                              } else {
                                sendEmail();
                              }
                            },
                          ),
                        );
                      },
                    ).paddingOnly(left: 8, right: 8),
                  )
                  // .box
                  // .gray100
                  // .rounded
                  // .margin(const EdgeInsets.all(6))
                  // .padding(
                  //   const EdgeInsets.symmetric(horizontal: 16),
                  // )
                  // .shadowSm
                  // .make()
                  // .box
                  // .color(lightGrey)
                  // .make(),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
