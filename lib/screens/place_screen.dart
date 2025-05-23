import 'package:favorite_places_app/model/place.dart';
import 'package:favorite_places_app/screens/map.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlaceScreen extends StatefulWidget {
  const PlaceScreen({super.key, required this.place});
  final Place place;

  @override
  State<PlaceScreen> createState() => _PlaceScreenState();
}

class _PlaceScreenState extends State<PlaceScreen> {
  bool showContent = false;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          showContent = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.place.title),
      ),
      body: Stack(
        children: [
          Hero(
            tag: widget.place.id,
            child: Image.file(widget.place.image,
                fit: BoxFit.cover,
                width: double.infinity,
                height: screenHeight),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: AnimatedOpacity(
              opacity: showContent ? 1.0 : 0.0,
              duration: Duration(milliseconds: 300),
              child: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                      const Color.fromARGB(0, 0, 0, 0),
                      const Color.fromARGB(180, 0, 0, 0)
                    ])),
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 32),
                child: Text(
                  widget.place.address,
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: AnimatedOpacity(
        opacity: showContent ? 1.0 : 0.0,
        duration: Duration(milliseconds: 300),
        child: Container(
          margin: EdgeInsets.only(bottom: 46),
          child: GestureDetector(
            onTap: () {
              nagivateToMapScreen(widget.place.location);
            },
            child: Container(
              width: 156,
              height: 156,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: FileImage(widget.place.mapImage),
                  fit: BoxFit.cover,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    spreadRadius: 2,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void nagivateToMapScreen(LatLng initialLatLng) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => PlaceOnMapSelecter(
        initialLatLng: initialLatLng,
        isEditing: false,
      ),
    ));
  }
}
