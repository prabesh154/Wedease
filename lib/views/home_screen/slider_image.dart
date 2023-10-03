import 'package:wedease/consts/consts.dart';
import 'package:carousel_slider/carousel_slider.dart';

List<String> advertisementImages = [
  'assets/images/slider3.png',
  'assets/images/slider4.png',

  // Add more image paths as needed
];

class AdvertisementSlider extends StatelessWidget {
  const AdvertisementSlider({super.key});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        autoPlay: true,
        aspectRatio: 16 / 9, // You can adjust the aspect ratio
        enlargeCenterPage: true,
        scrollDirection: Axis.horizontal,
        autoPlayInterval:
            const Duration(seconds: 3), // Change slide interval as needed
      ),
      items: advertisementImages.map((imagePath) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
              ),
            );
          },
        );
      }).toList(),
    );
  }
}
