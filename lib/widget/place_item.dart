import 'package:favorite_places_app/model/place.dart';
import 'package:favorite_places_app/screens/place_screen.dart';
import 'package:flutter/material.dart';

class PlaceItem extends StatelessWidget {
  const PlaceItem({super.key, required this.place});
  final Place place;

  void onTap(context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PlaceScreen(place: place),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Hero(
        tag: place.id,
        child: Image.file(
          place.image,
          height: 80,
          fit: BoxFit.cover,
        ),
      ),
      title: Text(place.title),
      subtitle: Text(place.address),
      onTap: () => {onTap(context)},
    );
  }
}
