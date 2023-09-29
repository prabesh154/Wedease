import 'dart:convert';
import 'package:http/http.dart' as http;

class Photo {
  final int id;
  final String title;
  final String thumbnailUrl;
  final String imageUrl; // New property

  Photo({
    required this.id,
    required this.title,
    required this.thumbnailUrl,
    required this.imageUrl,
  });
}

class FetchPhoto {
  Future<Photo> fetchPhotoById(int id) async {
    final response = await http
        .get(Uri.parse('https://jsonplaceholder.typicode.com/photos/$id'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return Photo(
        id: data['id'],
        title: data['title'],
        thumbnailUrl: data['thumbnailUrl'],
        imageUrl: data[
            'url'], // Assuming the full-sized image URL is provided as 'url'
      );
    } else {
      throw Exception('Failed to fetch photo');
    }
  }
}
