import 'package:wedease/consts/consts.dart';

Widget applogoWidget() {
  return Image.asset(icAppLogos)
      .box
      .white
      .size(77, 77)
      .padding(const EdgeInsets.all(12))
      .rounded
      .make();
}
