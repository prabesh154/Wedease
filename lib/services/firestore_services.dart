import 'package:wedease/consts/consts.dart';

class FirestorServices {
  // static getUser(uid) {
  //   return firestore
  //       .collection(userCollection)
  //       .where('id', isEqualTo: uid)
  //       .snapshots();
  // }

  static getUser(uid) {
    try {
      return firestore.collection(userCollection).doc(uid).snapshots();
    } catch (e) {
      print("Error fetching user data: $e");
      // Handle the error as needed (e.g., show an error message).
      rethrow; // Rethrow the error to propagate it up the call stack.
    }
  }

  // get services according to services name

  static getServices(name) {
    return firestore
        .collection(serviceCollection)
        .where('s_category', isEqualTo: name)
        .snapshots();
  }

  static getSubCategoryservices(title) {
    return firestore
        .collection(serviceCollection)
        .where('s_subcategory', isEqualTo: title)
        .snapshots();
  }

  //get saved services by users
  static getSaved(uid) {
    return firestore
        .collection(saveCollection)
        .where('saved_by', isEqualTo: uid)
        .snapshots();
  }

  //deleteDocument
  static deleteDocument(docId) {
    return firestore.collection(saveCollection).doc(docId).delete();
  }

  //get all chat messages

  static getChatMessages(docId) {
    return firestore
        .collection(chatsCollection)
        .doc(docId)
        .collection(messagesCollection)
        .orderBy('created_on', descending: false)
        .snapshots();
  }

  //get featured products;

  static getFeaturedServices() {
    return firestore
        .collection(serviceCollection)
        .where('is_featured', isEqualTo: true)
        .get();
  }

  //Attention needed

  static searchServices(title) {
    return firestore
        .collection(serviceCollection)
        .where('s_name', isLessThanOrEqualTo: title)
        .get();
  }
}
