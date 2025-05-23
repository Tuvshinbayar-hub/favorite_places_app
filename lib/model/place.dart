import 'dart:io';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';

class Place {
  Place(
      {required this.title,
      required this.imagePath,
      required this.address,
      required this.location,
      required this.mapImagePath})
      : id = Uuid().v4();
  String id;
  String title;
  String imagePath;
  String address;
  LatLng location;
  String mapImagePath;

  File get image {
    return File(imagePath);
  }

  File get mapImage {
    return File(mapImagePath);
  }
}
