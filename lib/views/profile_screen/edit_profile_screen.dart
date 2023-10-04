import 'dart:io';
import 'package:wedease/controllers/profile_controller.dart';
import 'package:wedease/widgets_common/bg_widget.dart';
import 'package:wedease/consts/consts.dart';
import 'package:wedease/widgets_common/custom_textfield.dart';
import 'package:wedease/widgets_common/our_button.dart';

class EditProfileScreen extends StatelessWidget {
  final dynamic data;
  const EditProfileScreen({Key? key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<ProfileController>();
    return bgWidget(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Obx(
            () => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                data['imageUrl'] == '' && controller.profileImgPath.isEmpty
                    ? Image.asset(
                        imgProfile,
                        width: 100,
                        fit: BoxFit.cover,
                      ).box.roundedFull.clip(Clip.antiAlias).make()
                    : data['imageUrl'] != '' &&
                            controller.profileImgPath.isEmpty
                        ? Image.network(data['imageUrl'],
                                width: 100, fit: BoxFit.cover)
                            .box
                            .roundedFull
                            .clip(Clip.antiAlias)
                            .make()
                        : Image.file(
                            File(controller.profileImgPath.value),
                            width: 100,
                            fit: BoxFit.cover,
                          ).box.roundedFull.clip(Clip.antiAlias).make(),
                10.heightBox,
                ourButton(
                  color: blueColor,
                  onPress: () {
                    controller.changeImage(context);
                  },
                  textColor: whiteColor,
                  title: "Change",
                ),
                const Divider(),
                10.heightBox,
                SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      customTextField(
                        controller: controller.nameController,
                        hint: nameHint,
                        title: name,
                        isPass: false,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Name cannot be empty';
                          } else if (value.length < 3) {
                            return 'Name should be at least 3 characters long';
                          } else if (!value.contains(RegExp(r'^[a-zA-Z]+$'))) {
                            return 'Name should contain only alphabetic characters';
                          }
                          return null;
                        },
                      ),
                      10.heightBox,
                      customTextField(
                        controller: controller.oldpassController,
                        hint: passwordHint,
                        title: oldpass,
                        isPass: true,
                      ),
                      10.heightBox,
                      customTextField(
                        controller: controller.newpassController,
                        hint: passwordHint,
                        title: newpass,
                        isPass: true,
                        validator: (value) {
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
                        },
                      ),
                    ],
                  ),
                ),
                20.heightBox,
                controller.isloading.value
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(blueColor),
                      )
                    : SizedBox(
                        width: context.screenWidth - 60,
                        child: ourButton(
                          color: blueColor,
                          onPress: () async {
                            controller.isloading(true);

                            // Validate the name and new password
                            String? nameError = (controller
                                    .nameController.text.isEmpty)
                                ? 'Name cannot be empty'
                                : (controller.nameController.text.length < 3)
                                    ? 'Name should be at least 3 characters long'
                                    : (!controller.nameController.text
                                            .contains(RegExp(r'^[a-zA-Z]+$')))
                                        ? 'Name should contain only alphabetic characters'
                                        : null;

                            String? newPasswordError = (controller
                                    .newpassController.text.isEmpty)
                                ? 'Password cannot be empty'
                                : (controller.newpassController.text.length < 5)
                                    ? 'Password should be at least 5 characters long'
                                    : (!controller.newpassController.text
                                            .contains(RegExp(r'[A-Z]')))
                                        ? 'Password should contain at least one uppercase letter'
                                        : (!controller.newpassController.text
                                                .contains(RegExp(r'[a-z]')))
                                            ? 'Password should contain at least one lowercase letter'
                                            : (!controller
                                                    .newpassController.text
                                                    .contains(RegExp(r'\d')))
                                                ? 'Password should contain at least one number'
                                                : null;

                            if (nameError != null || newPasswordError != null) {
                              VxToast.show(context,
                                  msg: 'Please fix name or password validaiton');
                            } else {
                              // Check if a new password is provided
                              if (controller
                                  .newpassController.text.isNotEmpty) {
                                // Update password only if a new password is provided
                                await controller.changeAuthPassword(
                                  email: data['email'],
                                  password: controller.oldpassController.text,
                                  newpassword:
                                      controller.newpassController.text,
                                );
                              }

                              // Update profile information (name and image)
                              await controller.updateProfile(
                                imgUrl: controller.profileImageLink,
                                name: controller.nameController.text,
                                password: controller.newpassController.text,
                              );

                              VxToast.show(context,
                                  msg: 'Updated Successfully');
                            }
                            controller.isloading(false);
                          },
                          textColor: whiteColor,
                          title: "Save",
                        ),
                      )
              ],
            )
                .box
                .shadowSm
                .padding(const EdgeInsets.all(16))
                .margin(const EdgeInsets.only(top: 50, left: 12, right: 12))
                .rounded
                .white
                .make(),
          ),
        ),
      ),
    );
  }
}
