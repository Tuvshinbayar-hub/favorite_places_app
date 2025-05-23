import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlaceOnMapSelecter extends StatefulWidget {
  const PlaceOnMapSelecter(
      {super.key, this.initialLatLng, this.isEditing = true});
  final LatLng? initialLatLng;
  final bool isEditing;

  @override
  State<StatefulWidget> createState() {
    return _PlaceOnMapSelecterState();
  }
}

class _PlaceOnMapSelecterState extends State<PlaceOnMapSelecter> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  Set<Marker> markers = {};
  late LatLng location;
  late CameraPosition initialCameraPosition;

  @override
  void initState() {
    super.initState();

    location = widget.initialLatLng ??
        LatLng(37.42796133580664, -122.085749655962); // Google head office

    initialCameraPosition = CameraPosition(
      target: location,
      zoom: 14.4746,
    );

    markers.add(Marker(
      markerId: const MarkerId('initialLocation'),
      position: location,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? 'Select location' : 'Your location'),
      ),
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: initialCameraPosition,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: markers,
        onTap: onMapTapped,
        zoomControlsEnabled: true,
        zoomGesturesEnabled: true,
        myLocationEnabled: true,
      ),
      floatingActionButton: widget.isEditing
          ? FloatingActionButton.extended(
              onPressed: onSubmit,
              label: const Text('Choose'),
              icon: const Icon(Icons.location_on),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void onMapTapped(LatLng position) {
    if (!widget.isEditing) return;

    setState(() {
      markers.clear();
      markers.add(
          Marker(markerId: MarkerId('clickedLocation'), position: position));
    });
  }

  void onSubmit() {
    if (markers.isEmpty) {
      navigateToPreviousScreen(null);
      return;
    }

    LatLng selectedLocation = markers.first.position;
    navigateToPreviousScreen(selectedLocation);
  }

  void navigateToPreviousScreen(LatLng? selectedLocation) {
    Navigator.of(context).pop(selectedLocation);
  }
}
