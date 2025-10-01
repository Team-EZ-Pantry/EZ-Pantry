// fetch pantry items here
// then store them in the relevant model

import 'package:http/http.dart' as http;

Future<http.Response> fetchAlbum() {
  return http.get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));   // sample http get request
}

// make the model here? or transfer the data?