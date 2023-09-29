// import 'package:wedease/consts/consts.dart';
// import 'package:wedease/consts/lists.dart';
// import 'package:wedease/views/vendor_screen/vendor_details.dart';
// import 'package:wedease/models/post_model.dart';
// import 'package:wedease/models/fetch_photo.dart';

// class VendorScreen extends StatefulWidget {
//   const VendorScreen({Key? key}) : super(key: key);

//   @override
//   _VendorScreenState createState() => _VendorScreenState();
// }

// class _VendorScreenState extends State<VendorScreen> {
//   List<PostsModel> postList = [];

//   Future<void> getPostApi() async {
//     postList = await fetchPhotoData(limit: 4);
//     setState(() {});
//   }

//   @override
//   void initState() {
//     super.initState();
//     getPostApi();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: lightGrey,
//       appBar: AppBar(
//         title: const Text(
//           'Vendors',
//           style: TextStyle(fontWeight: FontWeight.bold, color: blackColor),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.only(),
//         child: GridView.builder(
//           shrinkWrap: true,
//           itemCount: postList.length,
//           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 1,
//             mainAxisSpacing: 8,
//             crossAxisSpacing: 1,
//             mainAxisExtent: 150,
//           ),
//           itemBuilder: (context, index) {
//             final vendorName = vendorsList[index];
//             return Column(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(top: 3),
//                   child: Image.network(
//                     postList[index].thumbnailUrl!,
//                     height: 110,
//                     alignment: Alignment.centerLeft,
//                     fit: BoxFit.fitWidth,
//                   ),
//                 ),
//                 const SizedBox(height: 5),
//                 Text(
//                   vendorName,
//                   style: const TextStyle(color: darkFontGrey),
//                   textAlign: TextAlign.center,
//                 ),
//               ],
//             )
//                 .box
//                 .white
//                 .rounded
//                 .clip(Clip.antiAlias)
//                 .outerShadowSm
//                 .make()
//                 .onTap(() {
//               Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => VendorDetails(vendorName: vendorName),
//                   ));
//             });
//           },
//         ),
//       ),
//     );
//   }
// }

import 'package:wedease/consts/consts.dart';
import 'package:wedease/consts/lists.dart';
import 'package:wedease/views/vendor_screen/vendor_details.dart';
import 'package:wedease/controllers/vendor_controller.dart';

class VendorScreen extends StatelessWidget {
  const VendorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(VendorController());

    return Scaffold(
      backgroundColor: lightGrey,
      appBar: AppBar(
        title: const Text(
          'Vendors',
          style: TextStyle(fontWeight: FontWeight.bold, color: blackColor),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(),
        child: GridView.builder(
          shrinkWrap: true,
          itemCount: 4,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              mainAxisSpacing: 8,
              crossAxisSpacing: 1,
              mainAxisExtent: 150),
          itemBuilder: (context, index) {
            return Column(
              children: [
                Image.asset(vendorImages[index],
                    height: 120,
                    width: 100,
                    alignment: Alignment.centerLeft,
                    fit: BoxFit.fitWidth),
                1.heightBox,
                vendorsList[index]
                    .text
                    .color(darkFontGrey)
                    .align(TextAlign.center)
                    .make(),
              ],
            )
                .box
                .white
                .rounded
                .clip(Clip.antiAlias)
                .outerShadowSm
                .make()
                .onTap(() {
              controller.getSubCategories(vendorsList[index]);
              Get.to(() => VendorDetails(title: vendorsList[index]));
              //categoreisList = vendoesList
            });
          },
        ),
      ),
    );
  }
}
