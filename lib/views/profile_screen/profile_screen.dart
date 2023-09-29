// import 'package:wedease/consts/consts.dart';
// import 'package:wedease/consts/lists.dart';
// import 'package:wedease/controllers/profile_controller.dart';
// import 'package:wedease/views/profile_screen/edit_profile_screen.dart';
// import 'package:wedease/views/splash_screen/auth_screen/login_screen.dart';
// import 'package:wedease/widgets_common/bg_widget.dart';
// import 'package:wedease/controllers/auth_controller.dart';

// // import 'package:wedease/consts/consts.dart';
// // import 'package:wedease/consts/lists.dart';
// // import 'package:wedease/controllers/profile_controller.dart';
// // import 'package:wedease/views/profile_screen/edit_profile_screen.dart';
// // import 'package:wedease/views/splash_screen/auth_screen/login_screen.dart';
// // import 'package:wedease/widgets_common/bg_widget.dart';
// // import 'package:wedease/controllers/auth_controller.dart';
// // import 'package:wedease/services/firestore_services.dart'; // Import your Firestore service here
// // import 'package:flutter/material.dart'; // Import Flutter's material package
// // import 'package:get/get.dart'; // Import Get package for state management

// class ProfileScreen extends StatelessWidget {
//   const ProfileScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     var controller = Get.put(ProfileController());

//     return bgWidget(
//       child: Scaffold(
//         body: StreamBuilder<DocumentSnapshot>(
//           stream: FirestorServices.getUser(
//               currentUser!.uid), // Stream of a single document
//           builder:
//               (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(
//                 child: CircularProgressIndicator(
//                   valueColor: AlwaysStoppedAnimation(blueColor),
//                 ),
//               );
//             } else if (!snapshot.hasData || !snapshot.data!.exists) {
//               return const Center(
//                 child: Text("No data available."),
//               );
//             } else {
//               var data = snapshot.data!.data() as Map<String, dynamic>;
//               return SafeArea(
//                 child: Column(
//                   children: [
//                     // edit profile button
//                     Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 8),
//                       child: Align(
//                         alignment: Alignment.centerRight,
//                         child: Icon(
//                           Icons.edit,
//                           color: whiteColor,
//                         ),
//                       ).onTap(() {
//                         controller.nameController.text = data['name'];
//                         Get.to(() => EditProfileScreen(data: data));
//                         print(data);
//                       }),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Row(
//                         children: [
//                           data['imageUrl'] == ''
//                               ? Image.asset(
//                                   imgProfile,
//                                   width: 100,
//                                   fit: BoxFit.cover,
//                                 ).box.roundedFull.clip(Clip.antiAlias).make()
//                               : Image.network(
//                                   data['imageUrl'],
//                                   width: 100,
//                                   fit: BoxFit.cover,
//                                 ).box.roundedFull.clip(Clip.antiAlias).make(),
//                           10.widthBox,
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 "${data['name']}"
//                                     .text
//                                     .fontFamily(semibold)
//                                     .white
//                                     .make(),
//                                 5.heightBox,
//                                 "${data['email']}".text.white.make(),
//                               ],
//                             ),
//                           ),
//                           OutlinedButton(
//                             style: OutlinedButton.styleFrom(
//                               side: const BorderSide(color: whiteColor),
//                             ),
//                             onPressed: () async {
//                               VxToast.show(context, msg: loggedout);
//                               await Get.put(AuthController())
//                                   .signoutMethod(context);
//                               Get.offAll(() => const LoginScreen());
//                             },
//                             child: const Text(
//                               'Logout',
//                               style: TextStyle(
//                                 fontFamily: semibold,
//                                 color: whiteColor,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     // Rest of your UI
//                   ],
//                 ),
//               );
//             }
//           },
//         ),
//       ),
//     );
//   }
// }
import 'package:wedease/consts/consts.dart';
import 'package:wedease/consts/lists.dart';
import 'package:wedease/controllers/profile_controller.dart';
import 'package:wedease/views/profile_screen/edit_profile_screen.dart';
import 'package:wedease/views/splash_screen/auth_screen/login_screen.dart';
import 'package:wedease/widgets_common/bg_widget.dart';
import 'package:wedease/controllers/auth_controller.dart';
import 'package:wedease/services/firestore_services.dart';
//import 'package:flutter/services.dart';

//import 'package:wedease/views/profile_screen/edit_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

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
                          )).onTap(() {
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
