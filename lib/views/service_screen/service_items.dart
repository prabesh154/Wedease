import 'package:wedease/consts/consts.dart';
import 'package:wedease/views/service_screen/service_details.dart';
import 'package:wedease/widgets_common/bg_widget.dart';
import 'package:wedease/controllers/service_controller.dart';
import 'package:wedease/widgets_common/loading_indicator.dart';

class ServiceItems extends StatefulWidget {
  final String? title;
  const ServiceItems({Key? key, required this.title,}) : super(key: key);

  @override
  State<ServiceItems> createState() => _ServiceItemsState();
}

class _ServiceItemsState extends State<ServiceItems> {
  @override
  void initState() {
    super.initState();
    switchCategory(widget.title);
  }

  switchCategory(title) {
    if (controller.subcat.contains(title)) {
      serviceMethod = FirestorServices.getSubCategoryservices(title);
    } else {
      serviceMethod = FirestorServices.getServices(title);
    }
  }

  var controller = Get.find<ServiceController>();
//productmethod changed to serviceMethod
  dynamic serviceMethod;

  @override
  Widget build(BuildContext context) {
    return bgWidget(
      child: Scaffold(
        appBar: AppBar(
          title: widget.title!.text.fontFamily(bold).white.make(),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(controller.subcat.length, (index) {
                  return "${controller.subcat[index]}"
                      .text
                      .size(12)
                      .fontFamily(semibold)
                      .color(darkFontGrey)
                      .makeCentered()
                      .box
                      .white
                      .rounded
                      .size(120, 60)
                      .margin(const EdgeInsets.symmetric(horizontal: 4))
                      .make()
                      .onTap(() {
                    switchCategory("${controller.subcat[index]}");
                    setState(() {});
                  });
                }),
              ),
            ),
            20.heightBox,
            StreamBuilder(
              stream: serviceMethod,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Expanded(
                    child: Center(
                      child: loadingIndicator(),
                    ),
                  );
                } else if (snapshot.data!.docs.isEmpty) {
                  return Expanded(
                    child: "Related Services Not Found"
                        .text
                        .color(darkFontGrey)
                        .makeCentered(),
                  );
                } else {
                  var data = snapshot.data!.docs;
                  return Expanded(
                    child: GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: data.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisExtent: 250,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                      ),
                      itemBuilder: (context, index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.network(
                              data[index]['s_imgs'][0],
                              width: 200,
                              height: 150,
                              fit: BoxFit.cover,
                            ).box.roundedSM.clip(Clip.antiAlias).make(),
                            5.heightBox,
                            "${data[index]['s_name']}"
                                .text
                                .fontFamily(semibold)
                                .color(darkFontGrey)
                                .make(),
                            10.heightBox,
                            "Rs ${data[index]['s_price']}"
                                .text
                                .color(redColor)
                                .fontFamily(bold)
                                .size(16)
                                .make(),
                          ],
                        )
                            .box
                            .white
                            .margin(const EdgeInsets.symmetric(horizontal: 4))
                            .roundedSM
                            .outerShadowSm
                            .padding(const EdgeInsets.all(12))
                            .make()
                            .onTap(() {
                          // controller.checkiFav(data[index]);
                          Get.to(() => ServiceDetails(
                              title: "${data[index]['s_name']}",
                              data: data[index]));
                        });
                      },
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
