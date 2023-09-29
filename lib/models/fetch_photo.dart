// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:wedease/models/post_model.dart';

// Future<List<PostsModel>> fetchPhotoData({int limit = 20}) async {
//   final response = await http.get(
//       Uri.parse('https://jsonplaceholder.typicode.com/photos?_limit=$limit'));
//   var data = jsonDecode(response.body.toString());
//   print(data);

//   if (response.statusCode == 200) {
//     return List<PostsModel>.from(data.map((item) => PostsModel.fromJson(item)));
//   } else {
//     return [];
//   }
// }
