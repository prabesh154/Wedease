import 'package:wedease/consts/consts.dart';
import 'package:wedease/consts/lists.dart';
import 'package:wedease/controllers/home_controller.dart';
import 'package:wedease/views/home_screen/components/featured_button.dart';
import 'package:wedease/views/home_screen/search_screen.dart';
import 'package:wedease/views/home_screen/slider_image.dart';
import 'package:wedease/views/service_screen/service_details.dart';
import 'package:wedease/widgets_common/home_buttons.dart';
import 'package:wedease/widgets_common/loading_indicator.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<HomeController>();

    return Container(
      padding: const EdgeInsets.all(0),
      color: lightGrey,
      width: context.screenWidth,
      height: context.screenHeight,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              alignment: Alignment.center,
              height: 60, // Adjust the height as needed
              child: Column(
                children: [
                  // TextFormField(
                  //   decoration: const InputDecoration(
                  //     border: InputBorder.none,
                  //     suffixIcon: Icon(Icons.search),
                  //     filled: true,
                  //     fillColor: whiteColor,
                  //     hintText: 'Search location',
                  //     hintStyle: TextStyle(color: textfieldGrey),
                  //   ),
                  // ),
                  const SizedBox(height: 10.0),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                          20), // Adjust the radius as needed
                      color: const Color.fromARGB(255, 236, 134, 134),
                    ),
                    child: TextFormField(
                      controller: controller.searchController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        suffixIcon: GestureDetector(
                          onTap: () {
                            if (controller
                                .searchController.text.isNotEmptyAndNotNull) {
                              Get.to(() => SearchScreen(
                                    title: controller.searchController.text,
                                  ));
                            }
                          },
                          child: const Icon(Icons.search),
                        ),
                        filled: true,
                        fillColor: Colors
                            .transparent, // Set the fill color to transparent
                        hintText: 'Search any Service or Location',
                        hintStyle: const TextStyle(color: whiteColor),
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    // Category buttons
                    10.heightBox,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(
                        3,
                        (index) => homeButtons(
                          height: context.screenHeight * 0.1,
                          width: context.screenWidth / 3.6,
                          icon: index == 0
                              ? icTopservices
                              : index == 1
                                  ? ictrends
                                  : icRecommend,
                          title: index == 0
                              ? topservices
                              : index == 1
                                  ? trends
                                  : recommend,
                        ),
                      ),
                    ),
                    20.heightBox,
                    const AdvertisementSlider(),
                    20.heightBox,
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: topCategories.text
                            .color(blackColor)
                            .size(18)
                            .fontFamily(bold)
                            .make(),
                      ),
                    ),
                    20.heightBox,
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(
                          2,
                          (index) => Column(
                            children: [
                              featuredButton(
                                icon: featuredImages1[index],
                                title: featuredTitles1[index],
                              ),
                              10.heightBox,
                              featuredButton(
                                icon: featuredImages2[index],
                                title: featuredTitles2[index],
                              ),
                            ],
                          ),
                        ).toList(),
                      ),
                    ),

                    // Featured Services
                    20.heightBox,
                    Container(
                      padding: const EdgeInsets.only(left: 20),
                      width: double.infinity,
                      decoration: const BoxDecoration(color: lightGrey),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          featuredServices.text
                              .color(darkFontGrey)
                              .fontFamily(bold)
                              .size(18)
                              .make(),
                          20.heightBox,
                          SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            child: FutureBuilder<QuerySnapshot>(
                                future: FirestorServices.getFeaturedServices(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return Center(
                                      child: loadingIndicator(),
                                    );
                                  } else if (snapshot.data!.docs.isEmpty) {
                                    return "No Featured Services Available"
                                        .text
                                        .heightTight
                                        .color(Colors.black)
                                        .makeCentered();
                                  } else {
                                    var featuredData = snapshot.data!.docs;
                                    
                                    return Row(
                                      children: List.generate(
                                          featuredData.length,
                                          (index) => Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Image.network(
                                                    featuredData[index]
                                                        ['s_imgs'][0],
                                                    width: 150,
                                                    height: 130,
                                                    fit: BoxFit.cover,
                                                  ),
                                                  10.heightBox,
                                                  "${featuredData[index]['s_name']}"
                                                      .text
                                                      .fontFamily(semibold)
                                                      .color(darkFontGrey)
                                                      .make(),
                                                  10.heightBox,
                                                  "${featuredData[index]['s_price']}"
                                                      .numCurrency
                                                      .text
                                                      .color(redColor)
                                                      .fontFamily(bold)
                                                      .size(16)
                                                      .make(),
                                                  10.heightBox,
                                                ],
                                              )
                                                  .box
                                                  .white
                                                  .margin(const EdgeInsets
                                                      .symmetric(horizontal: 4))
                                                  .roundedSM
                                                  .padding(
                                                      const EdgeInsets.all(8))
                                                  .make()
                                                  .onTap(() {
                                                Get.to(() => ServiceDetails(
                                                      title:
                                                          "${featuredData[index]['s_name']}",
                                                      data: featuredData[index],
                                                    ));
                                              })),
                                    );
                                  }
                                }),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
