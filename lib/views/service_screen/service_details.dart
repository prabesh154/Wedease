import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wedease/views/chat_screen/chat_screen.dart';
import 'package:wedease/views/service_screen/inquiry_section.dart';
import 'package:wedease/widgets_common/normal_text.dart';
import 'package:wedease/widgets_common/our_button.dart';

import '../../consts/consts.dart';
import 'package:wedease/controllers/service_controller.dart';

class ServiceDetails extends StatefulWidget {
  final String? title;
  final dynamic data;

  const ServiceDetails({
    Key? key,
    required this.title,
    required this.data,
  }) : super(key: key);

  @override
  State<ServiceDetails> createState() => _ServiceDetailsState();
}

class _ServiceDetailsState extends State<ServiceDetails> {
  late dynamic data;
  var controller;

  @override
  void initState() {
    super.initState();
    // Initialize 'data' with the widget's data
    data = widget.data;
    controller = Get.put(ServiceController());
  }

  @override
  void dispose() {
    super.dispose();
    controller.isSaved.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightGrey,
      appBar: AppBar(
        title: Text(
          widget.title!,
          style: const TextStyle(color: darkFontGrey, fontFamily: bold),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Share.share('check out my website https://wedease.com');
            },
            icon: const Icon(Icons.share),
          ),
          FutureBuilder(
              future:
                  controller.getSaveStatus(service_name: widget.data["s_name"]),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    return IconButton(
                      onPressed: () async {
                        controller.isSaved.value = !controller.isSaved.value;
                        await controller.toggleSave(
                            service_name: widget.data["s_name"]);

                        setState(() {});

                        VxToast.show(context, msg: "Favorite Updated");
                      },
                      icon: Icon(
                        Icons.favorite,
                        color: controller.isSaved.value
                            ? Colors.red
                            : const Color.fromARGB(255, 241, 192, 188),
                      ),
                    );
                  }
                }
                return const LinearProgressIndicator(
                  backgroundColor: fontGrey,
                );
              }),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.only(
              left: 8.0, right: 8.0, top: 16.0, bottom: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Swiper images
              VxSwiper.builder(
                itemCount: widget.data['s_imgs'].length,
                autoPlay: true,
                autoPlayAnimationDuration: const Duration(seconds: 3),
                aspectRatio: 16 / 9,
                itemBuilder: (context, index) {
                  return Image.network(
                    widget.data['s_imgs'][index],
                    width: double.infinity,
                    fit: BoxFit.cover,
                  );
                },
              ),
              // Service details
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        boldText(text: 'Name:', size: 16.0, color: blackColor),
                        8.widthBox,
                        normalText(
                            text: "${widget.data['s_seller']}",
                            size: 16.0,
                            color: blackColor),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        boldText(
                            text: 'Location:', size: 16.0, color: blackColor),
                        8.widthBox,
                        normalText(
                            text: "${widget.data['s_location']}",
                            size: 16.0,
                            color: blackColor),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        boldText(text: 'Rate:', size: 16.0, color: blackColor),
                        8.widthBox,
                        normalText(
                            text: "${widget.data['s_price']}",
                            size: 16.0,
                            color: blackColor),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: blueColor,
                            borderRadius: BorderRadius.circular(5),
                            shape: BoxShape.rectangle),
                        child: Center(
                          child: boldText(
                              text: 'Features:', size: 16.0, color: blackColor),
                        )),
                    const SizedBox(height: 8),
                    normalText(
                        text: "${widget.data['s_features']}",
                        size: 16.0,
                        color: blackColor),
                    const SizedBox(height: 16),
                    Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: blueColor,
                            borderRadius: BorderRadius.circular(5),
                            shape: BoxShape.rectangle),
                        child: Center(
                          child: boldText(
                              text: 'Description:',
                              size: 16.0,
                              color: blackColor),
                        )),
                    const SizedBox(height: 8),
                    normalText(
                      text: "${widget.data['s_description']}",
                      size: 16.0,
                      color: blackColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SizedBox(
        width: double.infinity,
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.message_rounded, color: lightPink),
            ).onTap(() {
              Get.to(() => const ChatScreen(),
                  arguments: [data['s_seller'], data['vendor_id']]);
            }),
            ourButton(
              title: 'Send Inquiry',
              color: lightPink,
              textColor: blackColor,
              onPress: () {
                // Navigate to the InquirySection when the button is pressed
                showModalBottomSheet<void>(
                  isScrollControlled: true,
                  showDragHandle: true,

                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  barrierColor: fontGreyOpacity,
                  backgroundColor: whiteColor,
                  // Set background color to transparent
                  context: context,
                  builder: (BuildContext context) {
                    return InquirySection(
                        vendor_id: widget.data["vendor_id"],
                        s_name: widget.data["s_name"]);
                  },
                );
              },
            ),
            const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.call, color: lightPink),
            ).onTap(
              () {
                callVendor(data['vendor_id']);

                print(data['vendor_id']);

                // Add your call functionality here
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> callVendor(id) async {
    try {
      // Query the Firestore collection to get the vendor's information
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('seller_vendors') // Replace with your collection name
          .where('id', isEqualTo: id)
          .get(); // Use get() instead of snapshots()

      if (querySnapshot.docs.isNotEmpty) {
        // Extract the vendor's phone number from the first document
        var data = querySnapshot.docs[0].data()
            as Map<String, dynamic>; // Explicit cast to Map<String, dynamic>

        if (data.containsKey('vendor_mobile')) {
          String phoneNumber = data['vendor_mobile'];

          // Check if the phone number is valid and launch the phone app to make the call
          if (await canLaunch('tel:$phoneNumber')) {
            await launch('tel:$phoneNumber');
          } else {
            throw 'Could not launch $phoneNumber';
          }
        } else {
          throw 'Invalid or missing vendor_mobile field';
        }
      } else {
        throw 'Vendor not found'; // Handle the case where the vendor is not found
      }
    } catch (e) {
      print('Error: $e');
      // Handle errors here
    }
  }
}
