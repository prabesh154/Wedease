import 'package:share_plus/share_plus.dart';
import 'package:wedease/views/chat_screen/chat_screen.dart';
import 'package:wedease/views/service_screen/inquiry_section.dart';
import 'package:wedease/widgets_common/normal_text.dart';
import 'package:wedease/widgets_common/our_button.dart';

import '../../consts/consts.dart';
import 'package:wedease/controllers/service_controller.dart';

class ServiceDetails extends StatelessWidget {
  final String? title;
  final dynamic data;

  const ServiceDetails({
    Key? key,
    required this.title,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ServiceController());
    return Scaffold(
      backgroundColor: lightGrey,
      appBar: AppBar(
        title: Text(
          title!,
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
              controller.addToSave(
                s_name: data['s_name'],
                s_imgs: data['s_imgs'][0],
                s_price: data['s_price'],
              );
              VxToast.show(context, msg: "Saved Successfully");
            },
            icon: const Icon(
              Icons.favorite,
              color: Color.fromARGB(255, 241, 192, 188),
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
                itemCount: data['s_imgs'].length,
                autoPlay: true,
                autoPlayAnimationDuration: const Duration(seconds: 3),
                aspectRatio: 16 / 9,
                itemBuilder: (context, index) {
                  return Image.network(
                    data['s_imgs'][index],
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
                            text: "${data['s_name']}",
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
                            text: "${data['s_location']}",
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
                                text: "${data['s_rating']}",
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
                            text: "${data['s_price']}",
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
                        text: "${data['s_features']}",
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
                      text: "${data['s_description']}",
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
            ),
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
