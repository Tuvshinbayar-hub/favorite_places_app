import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:path_provider/path_provider.dart';

final googleMapKey = dotenv.env['GOOGLE_MAPS_API_KEY'];

Future<Uint8List?> fetchImage(LatLng latLng) async {
  final lat = latLng.latitude;
  final lng = latLng.longitude;

  String url =
      "https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng&zoom=14&size=400x400&markers=color:red%7Clabel:A%7C$lat,$lng&key=$googleMapKey";

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    return response.bodyBytes;
  }

  return null;
}

Future<String> saveUint8ListImage(Uint8List imageBytes) async {
  String fileName = "${DateTime.now().millisecondsSinceEpoch}";
  final appDir = await getApplicationDocumentsDirectory();
  final filePath = '${appDir.path}/$fileName';

  File file = File(filePath);
  await file.writeAsBytes(imageBytes);

  return filePath;
}
