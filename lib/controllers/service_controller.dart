import 'package:wedease/consts/consts.dart';
import 'package:wedease/models/category_model.dart';
import 'package:get/get.dart';

class ServiceController extends GetxController {
  var subcat = [];
  var isSaved = false.obs;

  getSubCategories(title) async {
    subcat.clear();
    var data = await rootBundle.loadString("lib/services/category_model.json");
    var decoded = categoryModelFromJson(data);
    var s =
        decoded.categories.where((element) => element.name == title).toList();

    for (var e in s[0].subcategory) {
      subcat.add(e);
    }
  }

  getVendorPhone(title) async {}

// get saved services in detail.
  Future getSavedServices() async {
    List<Map<String, dynamic>> appendedDataList = [];
    dynamic savedList = await firestore
        .collection(saveCollection)
        .where('saved_by', isEqualTo: currentUser!.uid)
        .get();

    if (savedList.docs.isNotEmpty) {
      // print("length ${savedList.docs.length}");
      for (int i = 0; i < savedList.docs.length; i++) {
        var serviceInfo = await firestore
            .collection(serviceCollection)
            .where("s_name", isEqualTo: savedList.docs[i]["s_name"])
            .get();

        print("index : $i");

        if (serviceInfo.docs.isNotEmpty) {
          appendedDataList.add({
            "s_name": serviceInfo.docs[0]['s_name'],
            "vendor_id": serviceInfo.docs[0]['vendor_id'],
            "s_imgs": serviceInfo.docs[0]['s_imgs'],
            "s_features": serviceInfo.docs[0]['s_features'],
            "s_price": serviceInfo.docs[0]['s_price'],
            "s_location": serviceInfo.docs[0]['s_location'],
            "s_description": serviceInfo.docs[0]['s_description'],
          });
        }
        print("end of one loop");
      }
      print("new");
      print(appendedDataList);
      return appendedDataList;
    }
    return appendedDataList;
  }

// save status retrive;

  getSaveStatus({required service_name}) async {
    return await firestore
        .collection(saveCollection)
        .where("s_name", isEqualTo: service_name)
        .where("saved_by", isEqualTo: currentUser!.uid)
        .get()
        .then((value) => value.size.toString() == "0"
            ? isSaved.value = false
            : isSaved.value = true);
  }

// search, if found : delete; if not found : create;
  toggleSave({required service_name}) async {
    var value = await firestore
        .collection(saveCollection)
        .where("s_name", isEqualTo: service_name)
        .where('saved_by', isEqualTo: currentUser!.uid)
        .get();

    if (value.docs.isEmpty) {
      // it means, the service is not saved by user; so we have to saved it to collection .
      await firestore
          .collection(saveCollection)
          .add({"s_name": service_name, "saved_by": currentUser!.uid});
    } else {
      //means, we have to delete the saved service from collection.
      await firestore.collection(saveCollection).doc(value.docs[0].id).delete();
    }

    //

    // docs().set({'service_id': service_id, 'saved_by': currentUser!.uid})
    //     .catchError((error) {
    //   VxToast.show(Get.context as BuildContext, msg: error.toString());
    // });
  }

  // addtoWishlist(docId, context) async {
  //   await firestore.collection(serviceCollection).doc(docId).set({
  //     's_wishlist': FieldValue.arrayUnion([currentUser!.uid])
  //   }, SetOptions(merge: true));
  //   isFav(true);
  //   VxToast.show(context, msg: "Added to Saved");
  // }

  // removeFromWishlist(docId, context) async {
  //   await firestore.collection(serviceCollection).doc(docId).set({
  //     's_wishlist': FieldValue.arrayRemove([currentUser!.uid])
  //   }, SetOptions(merge: true));

  //   isFav(false);
  //   VxToast.show(context, msg: "Removed from Saved");
  // }

  // checkifFav(data) async {
  //   if (data['s_wishlist'].contains(currentUser!.uid)) {
  //     isFav(true);
  //   } else {
  //     isFav(false);
  //   }
  // }
}
