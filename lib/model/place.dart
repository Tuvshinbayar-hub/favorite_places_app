import 'dart:io';

import 'package:uuid/uuid.dart';

class Place {
  Place({required this.title, required this.imagePath}) : id = Uuid().v4();
  String id;
  String title;
  String imagePath;

  File get image {
    return File(imagePath);
  }
}
