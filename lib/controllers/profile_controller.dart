import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:wedease/consts/consts.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';

//import 'package:wedease/consts/consts.dart';
class ProfileController extends GetxController {
  var profileImgPath = ''.obs;

  var profileImageLink = '';
  var isloading = false.obs;
  //textfield
  var nameController = TextEditingController();
  var oldpassController = TextEditingController();
  var newpassController = TextEditingController();

  changeImage(context) async {
    try {
      final img = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
      );

      if (img == null) return;

      // Check the file size of the selected image
      File selectedImage = File(img.path);
      int fileSizeInBytes = await selectedImage.length();
      int fileSizeInMB =
          fileSizeInBytes ~/ (1024 * 1024); // Convert bytes to MB

      // Set the maximum allowed file size in MB
      int maxAllowedFileSizeInMB = 4;

      if (fileSizeInMB > maxAllowedFileSizeInMB) {
        VxToast.show(
          context,
          msg:
              'Please select an image with a maximum file size of $maxAllowedFileSizeInMB MB',
        );
        return;
      }

      profileImgPath.value = img.path;
    } on PlatformException catch (e) {
      VxToast.show(context, msg: e.toString());
    }
  }

  uploadProfileImage() async {
    var filename = basename(profileImgPath.value);
    var destination = 'images/${currentUser!.uid}/$filename';
    Reference ref = FirebaseStorage.instance.ref().child(destination);
    await ref.putFile(File(profileImgPath.value));
    profileImageLink = await ref.getDownloadURL();
  }

  updateProfile(
      {required String? name,
      required String? password,
      required String? imgUrl}) async {
    var store = firestore.collection(userCollection).doc(currentUser!.uid);
    await store.set({
      'name': name,
      'password': password,
      'imageUrl': imgUrl,
    }, SetOptions(merge: true));
    isloading(false);
  }

  changeAuthPassword({email, password, newpassword}) async {
    final cred = EmailAuthProvider.credential(email: email, password: password);

    await currentUser!.reauthenticateWithCredential(cred).then((value) {
      currentUser!.updatePassword(newpassword);
    }).catchError((error) {
      print(error.toString());
    });
  }
}
