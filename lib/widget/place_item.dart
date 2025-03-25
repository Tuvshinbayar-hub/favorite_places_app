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
    return InkWell(
      onTap: () {
        onTap(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Stack(
          children: [
            Hero(
              tag: place.id,
              child: Image.file(
                place.image,
                width: double.infinity,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: 80,
              child: Row(children: [
                SizedBox(
                  width: 16,
                ),
                Text(
                  place.title,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(color: Colors.black),
                ),
              ]),
            )
          ],
        ),
      ),
    );
  }
}
