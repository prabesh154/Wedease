import 'dart:math';

import 'package:wedease/consts/consts.dart';

class AuthController extends GetxController {
  var isloading = false.obs;
  //text controllers
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  //login method
  Future<UserCredential?> loginMethod({context}) async {
    UserCredential? userCredential;

    try {
      userCredential = await auth.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
    } on FirebaseAuthException catch (e) {
      VxToast.show(context, msg: e.toString());
    }

    return userCredential;
  }

  //signup method

  Future<UserCredential?> signupMethod({email, password, context}) async {
    UserCredential? userCredential;

    try {
      userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      VxToast.show(context, msg: e.toString());
    }
    print("saved user id  : ");
    print(userCredential!.user!.uid.toString());
    return userCredential;
  }

  //storing data method in cloud
  storeUserData(
      {required String name,
      required String password,
      required String email}) async {
    DocumentReference store =
        firestore.collection(userCollection).doc(currentUser!.uid);
    print("store user id ");
    // print(currentUser!.uid.toString());
    store.set({
      'name': name,
      'password': password,
      'email': email,
      'imageUrl': '',
      'id': currentUser!.uid
    });
  }

  Future<bool> checkAccountExists(String email) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> result = await FirebaseFirestore
          .instance
          .collection(
              'users') // Replace 'Users' with your actual collection name
          .where('email', isEqualTo: email)
          .get();

      // If there is at least one document with the provided email, an account exists
      return result.docs.isNotEmpty;
    } catch (e) {
      // Handle any potential errors, e.g., Firestore is not initialized or network issues
      print('Error checking account existence: $e');
      return false; // Return false in case of errors
    }
  }

  //signout method

  signoutMethod(context) async {
    try {
      await auth.signOut();
    } catch (e) {
      VxToast.show(context, msg: e.toString());
    }
  }
}
