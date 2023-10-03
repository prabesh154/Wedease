import 'package:wedease/consts/consts.dart';
import 'package:wedease/consts/lists.dart';
import 'package:wedease/views/service_screen/service_details.dart';
import 'package:wedease/views/service_screen/service_items.dart';
import 'package:wedease/controllers/service_controller.dart';

class ServiceScreen extends StatelessWidget {
  const ServiceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ServiceController());

    return Scaffold(
      backgroundColor: lightGrey,
      appBar: AppBar(
        title: const Text(
          'Services',
          style: TextStyle(fontWeight: FontWeight.bold, color: blackColor),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(),
        child: GridView.builder(
          shrinkWrap: true,
          itemCount: serviceList.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              mainAxisSpacing: 10,
              crossAxisSpacing: 0,
              mainAxisExtent: 160),
          itemBuilder: (context, index) {
            return Column(
              children: [
                Image.asset(serviceImages[index],
                    height: 120,
                    width: 160,
                    alignment: Alignment.topLeft,
                    fit: BoxFit.fitWidth),
                serviceList[index]
                    .text
                    .size(20)
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
              controller.getSubCategories(serviceList[index]);
              Get.to(() => ServiceItems(title: serviceList[index]));
              //categoreisList = vendoesList
            });
          },
        ),
      ),
    );
  }
}
