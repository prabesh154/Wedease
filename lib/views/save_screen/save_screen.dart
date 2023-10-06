import 'package:wedease/consts/consts.dart';
import 'package:wedease/controllers/service_controller.dart';
import 'package:wedease/views/service_screen/service_details.dart';
import 'package:wedease/widgets_common/loading_indicator.dart';

class SaveScreen extends StatelessWidget {
  const SaveScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ServiceController());
    // controller.getSavedServices();

    return Scaffold(
      backgroundColor: lightGrey,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: "Saved".text.color(darkFontGrey).fontFamily(semibold).make(),
      ),
      body: FutureBuilder(
        future: controller.getSavedServices(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: loadingIndicator(),
            );
          } else if (snapshot.hasData && snapshot.data!.length == 0) {
            return Center(
              child: "Nothing is Saved".text.color(darkFontGrey).make(),
            );
          } else if (snapshot.hasData && snapshot.data!.length != 0) {
            var data = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 20,
                children: List.generate(data.length, (index) {
                  return GestureDetector(
                    onTap: () {
                      Get.to(
                        () => ServiceDetails(
                          title: "${data[index]['s_name']}",
                          data: data[index],
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Container(
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                ),
                              ),
                              child: Image.network(
                                "${data[index]['s_imgs'][0]}",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      "${data[index]['s_name']}"
                                          .text
                                          .fontFamily(semibold)
                                          .size(16)
                                          .make(),
                                      4.heightBox,
                                      "Rs ${data[index]['s_price']}"
                                          .text
                                          .fontFamily(semibold)
                                          .size(12)
                                          .color(borderColor)
                                          .make(),
                                      4.heightBox,
                                      "${data[index]['s_location']}"
                                          .text
                                          .fontFamily(semibold)
                                          .size(12)
                                          .color(borderColor)
                                          .make(),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            );
          } else {
            return const Center(
              child: Text("Error during fetch"),
            );
          }
        },
      ),
    );
  }
}
