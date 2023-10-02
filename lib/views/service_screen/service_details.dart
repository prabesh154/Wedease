import 'package:wedease/views/chat_screen/chat_screen.dart';

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
            onPressed: () {},
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
              // color:controller.isFav.value? redColor:darkFontGrey
              color: Color.fromARGB(255, 241, 192, 188),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Swiper actions
              VxSwiper.builder(
                autoPlay: true,
                height: 220,
                itemCount: data['s_imgs'].length,
                viewportFraction: 1.0,
                aspectRatio: 16 / 9,
                itemBuilder: (context, index) {
                  return Image.network(
                    data['s_imgs'][index],
                    width: double.infinity,
                    fit: BoxFit.cover,
                  );
                },
              ),

              // Title and details section
              const SizedBox(height: 10),
              Text(
                title!,
                style: const TextStyle(
                  fontSize: 20,
                  color: darkFontGrey,
                  fontFamily: bold,
                ),
              ),

              const SizedBox(height: 1),

              Container(
                height: 530,
                width: double.infinity,
                color: lightGrey,
                margin: const EdgeInsets.only(bottom: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Price: Rs ${data['s_price'] ?? ''}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Features: ${data['s_features'] ?? ''}",
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      "Location: ${data['s_location'] ?? ''}",
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      "Description: ${data['s_description'] ?? ''}",
                      style: const TextStyle(fontSize: 16),
                    ),

                    // Second box
                    Container(
                      height: 100,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: Colors.black,
                          width: 2,
                        ),
                      ),
                      child: const TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Enter details',
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        ),
                      ),
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
              child: Icon(Icons.message_rounded, color: darkFontGrey),
            ),
            // ).onTap(
            //   // () {
            //   //   Get.to(() => const ChatScreen(),
            //   //       arguments: [data['s_seller'], data['service_id']]);
            //   // },
            // ),
            const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.call, color: darkFontGrey),
            ).onTap(() {
              // Add your call functionality here
            }),
          ],
        ),
      ),
    );
  }
}
