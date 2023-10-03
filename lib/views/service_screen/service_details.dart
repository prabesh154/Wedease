import 'package:share_plus/share_plus.dart';
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
  List<Map<String, dynamic>> savedServices = [];
  bool isFavorite = false;
  // Declare 'data' variable here to make it accessible throughout the widget
  late dynamic data;

  @override
  void initState() {
    super.initState();
    // Initialize 'data' with the widget's data
    data = widget.data;
  }

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ServiceController());
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
          IconButton(
            onPressed: () {
              bool isAlreadySaved = savedServices.any((services) =>
                  services['s_name'] == widget.data['s_name'] &&
                  services['s_imgs'] == widget.data['s_imgs'][0] &&
                  services['s_price'] == widget.data['s_price']);

              if (!isAlreadySaved) {
                controller.addToSave(
                  s_name: widget.data['s_name'],
                  s_imgs: widget.data['s_imgs'][0],
                  s_price: widget.data['s_price'],
                );

                VxToast.show(context, msg: "Saved Successfully");

                setState(() {
                  // Toggle the favorite icon color
                  isFavorite = true;

                  // Add the saved service to the list
                  savedServices.add({
                    's_name': widget.data['s_name'],
                    's_imgs': widget.data['s_imgs'][0],
                    's_price': widget.data['s_price'],
                  });
                });
              } else {
                // If the service is already saved, you can show a message to the user
                VxToast.show(context, msg: "Service is already saved");
              }
            },
            icon: Icon(
              Icons.favorite,
              color: isFavorite
                  ? Colors.red
                  : const Color.fromARGB(255, 241, 192, 188),
            ),
          ),
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
                            text: "${widget.data['s_name']}",
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
                        boldText(
                            text: 'Ratings 8.40 :',
                            size: 16.0,
                            color: blackColor),
                        8.widthBox,
                        Row(
                          children: [
                            const Icon(Icons.star,
                                color: Color.fromARGB(255, 224, 212, 10)),
                            const Icon(Icons.star,
                                color: Color.fromARGB(255, 234, 212, 10)),
                            const Icon(Icons.star,
                                color: Color.fromARGB(255, 234, 212, 10)),
                            const Icon(Icons.star,
                                color: Color.fromARGB(255, 234, 212, 10)),
                            const Icon(Icons.star_border,
                                color: Color.fromARGB(255, 232, 212, 10)),
                            const SizedBox(width: 4),
                            normalText(
                                text: "${widget.data['s_rating']}",
                                size: 16.0,
                                color: blackColor),
                          ],
                        ),
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
                    return const InquirySection();
                  },
                );
              },
            ),
            const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.call, color: lightPink),
            ).onTap(
              () {
                // Add your call functionality here
              },
            ),
          ],
        ),
      ),
    );
  }
}
