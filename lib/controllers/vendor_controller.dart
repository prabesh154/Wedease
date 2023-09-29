import 'package:wedease/consts/consts.dart';
import 'package:wedease/models/category_model.dart';

class VendorController extends GetxController {
  var subcat = [];
  var isFav = false.obs;

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

  addToSave({v_name, v_imgs, v_price, context}) async {
    await firestore.collection(saveCollection).doc().set({
      'v_name': v_name,
      'v_imgs': v_imgs,
      'v_price': v_price,
      'saved_by': currentUser!.uid
    }).catchError((error) {
      VxToast.show(context, msg: error.toString());
    });
  }

  addtoWishlist(docId, context) async {
    await firestore.collection(serviceCollection).doc(docId).set({
      'v_wishlist': FieldValue.arrayUnion([currentUser!.uid])
    }, SetOptions(merge: true));
    isFav(true);
    VxToast.show(context, msg: "Added to Saved");
  }

  removeFromWishlist(docId, context) async {
    await firestore.collection(serviceCollection).doc(docId).set({
      'v_wishlist': FieldValue.arrayRemove([currentUser!.uid])
    }, SetOptions(merge: true));

    isFav(false);
    VxToast.show(context, msg: "Removed from Saved");
  }

  checkifFav(data) async {
    if (data['v_wishlist'].contains(currentUser!.uid)) {
      isFav(true);
    } else {
      isFav(false);
    }
  }
}
