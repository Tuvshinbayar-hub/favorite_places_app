import 'dart:convert';

import 'package:favorite_places_app/screens/map.dart';
import 'package:favorite_places_app/utils/image_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

class LocationWidget extends StatefulWidget {
  const LocationWidget({super.key, required this.onLocationSelection});

  final void Function(Uint8List, String, LatLng) onLocationSelection;

  @override
  State<LocationWidget> createState() => _LocationWidgetState();
}

class _LocationWidgetState extends State<LocationWidget> {
  LatLng? latLng;
  Uint8List? imageBytes;
  bool isLoading = false;
  final googleMapKey = dotenv.env['GOOGLE_MAPS_API_KEY'];
  String? address;

  @override
  Widget build(BuildContext context) {
    Widget content;

    if (isLoading) {
      content = Center(
        child: SizedBox(
          height: 26,
          width: 26,
          child: CircularProgressIndicator(),
        ),
      );
    } else if (imageBytes == null) {
      content = Center(
        child: Text(
          'No location chosen',
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(color: Colors.white),
        ),
      );
    } else {
      content = Image.memory(
        imageBytes!,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
      );
    }

    return Column(children: [
      Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.white),
        ),
        child: content,
      ),
      SizedBox(
        height: 16,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
              onPressed: onCurrentLocationButtonPressed,
              child: Text("Current Location")),
          ElevatedButton(
              onPressed: onChooseLocationButtonPressed,
              child: Text("Choose Location"))
        ],
      ),
    ]);
  }

  void onCurrentLocationButtonPressed() async {
    await getCurrentLocation();
    await getImage();
    await getAddress();
    widget.onLocationSelection(imageBytes!, address!, latLng!);
  }

  void onChooseLocationButtonPressed() async {
    await getSelectedLocationByNavigating();
    await getImage();
    await getAddress();
    widget.onLocationSelection(imageBytes!, address!, latLng!);
  }

  Future<void> getSelectedLocationByNavigating() async {
    LatLng? selectedLatLng = await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => PlaceOnMapSelecter(),
    ));

    setState(() {
      isLoading = true;
    });

    if (selectedLatLng == null) {
      return;
    }

    latLng = selectedLatLng;
  }

  Future<void> getCurrentLocation() async {
    bool serviceEnabled;
    Location location = Location();
    PermissionStatus permissionGranted;

    setState(() {
      isLoading = true;
    });

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    LocationData locationData = await location.getLocation();

    latLng = LatLng(locationData.latitude!, locationData.longitude!);
  }

  Future<void> getImage() async {
    final fetchedImageBytes = await fetchImage(latLng!);

    if (fetchedImageBytes != null) {
      setState(() {
        imageBytes = fetchedImageBytes;
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> getAddress() async {
    final lat = latLng!.latitude;
    final lng = latLng!.longitude;

    String url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$googleMapKey";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      address = json.decode(response.body)['results'][0]['formatted_address'];
    }
  }
}
