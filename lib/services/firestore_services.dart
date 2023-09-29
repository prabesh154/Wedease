import 'package:wedease/consts/consts.dart';

class FirestorServices {
  static getUser(uid) {
    return firestore
        .collection(userCollection)
        .where('id', isEqualTo: uid)
        .snapshots();
  }

  // get services according to vendors name

  static getServices(name) {
    return firestore
        .collection(serviceCollection)
        .where('v_category', isEqualTo: name)
        .snapshots();
  }

  static getSubCategoryVendors(title) {
    return firestore
        .collection(serviceCollection)
        .where('v_subcategory', isEqualTo: title)
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

  static searchServices(title) {
    return firestore
        .collection(serviceCollection)
        .where('v_name', isLessThanOrEqualTo: title)
        .get();
  }
}
