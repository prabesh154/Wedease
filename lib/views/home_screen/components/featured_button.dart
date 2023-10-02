import 'package:wedease/consts/consts.dart';
import 'package:wedease/views/service_screen/service_items.dart';

Widget featuredButton({String? title, icon}) {
  return Row(
    children: [
      Image.asset(icon, width: 50, fit: BoxFit.fill),
      10.widthBox,
      title!.text.fontFamily(semibold).color(darkFontGrey).make(),
    ],
  )
      .box
      .width(174)
      .margin(const EdgeInsets.symmetric(horizontal: 3))
      .white
      .padding(const EdgeInsets.all(3))
      .outerShadowSm
      .make()
      .onTap(() {
    Get.to(() => ServiceItems(title: title,));
  });
}
