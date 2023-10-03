import 'package:flutter/material.dart';
import 'package:wedease/consts/consts.dart';
import 'package:wedease/views/service_screen/service_details.dart';
import 'package:wedease/widgets_common/loading_indicator.dart';

class SearchScreen extends StatelessWidget {
  final String? title;

  const SearchScreen({
    Key? key,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: title!.text.color(darkFontGrey).make(),
      ),
      body: FutureBuilder(
        future: FirestorServices.searchServices(title),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: loadingIndicator(),
            );
          } else {
            var data = snapshot.data!.docs;
            var filtered = data
                .where(
                  (element) =>
                      element['s_name']
                          .toString()
                          .toLowerCase()
                          .contains(title!.toLowerCase()) ||
                      element['s_location'].toString().toLowerCase().contains(
                          title!
                              .toLowerCase()), // Search in s_name and s_location
                )
                .toList();

            if (filtered.isEmpty) {
              return "No Services Found".text.makeCentered();
            } else {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    mainAxisExtent: 300,
                  ),
                  children: filtered
                      .mapIndexed((currentValue, index) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.network(
                                filtered[index]['s_imgs'][0],
                                height: 200,
                                width: 150,
                                fit: BoxFit.cover,
                              ),
                              const Spacer(),
                              "${filtered[index]['s_name']}"
                                  .text
                                  .fontFamily(semibold)
                                  .color(darkFontGrey)
                                  .make(),
                              10.heightBox,
                              "${filtered[index]['s_price']}"
                                  .text
                                  .fontFamily(bold)
                                  .color(redColor)
                                  .make(),
                              10.heightBox,
                              "${filtered[index]['s_location']}"
                                  .text
                                  .fontFamily(bold)
                                  .color(redColor)
                                  .make(),
                            ],
                          )
                              .box
                              .white
                              .outerShadowMd
                              .margin(const EdgeInsets.symmetric(horizontal: 4))
                              .roundedSM
                              .padding(const EdgeInsets.all(12))
                              .make()
                              .onTap(() {
                            Get.to(() => ServiceDetails(
                                title: "${filtered[index]['s_name']}",
                                data: filtered[index]));
                          }))
                      .toList(),
                ),
              );
            }
          }
        },
      ),
    );
  }
}
