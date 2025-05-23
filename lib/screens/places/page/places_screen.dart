import 'package:favorite_places_app/model/place.dart';
import 'package:favorite_places_app/screens/place_creator_screen.dart';
import 'package:favorite_places_app/screens/places/bloc/place_bloc.dart';
import 'package:favorite_places_app/screens/places/bloc/place_event.dart';
import 'package:favorite_places_app/screens/places/bloc/place_state.dart';
import 'package:favorite_places_app/widget/place_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlacesScreen extends StatefulWidget {
  const PlacesScreen({super.key});

  @override
  State<PlacesScreen> createState() => _PlacesScreenState();
}

class _PlacesScreenState extends State<PlacesScreen> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    context.read<PlaceBloc>().add(FetchPlaces());
  }

  // navigate to the individual favorite place
  void onPressedAdd(context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => PlaceCreatorScreen(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final placeBloc = context.read<PlaceBloc>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite places'),
        actions: [
          IconButton(
              onPressed: () {
                onPressedAdd(context);
              },
              icon: Icon(Icons.add))
        ],
      ),
      body: BlocBuilder<PlaceBloc, PlaceState>(
        builder: (context, state) => Stack(
          children: [
            ListView.builder(
              itemCount: placeBloc.state.places.length,
              itemBuilder: (context, index) => PlaceItem(
                place: Place(
                    title: placeBloc.state.places[index].title,
                    imagePath: placeBloc.state.places[index].imagePath,
                    address: placeBloc.state.places[index].address,
                    location: placeBloc.state.places[index].location,
                    mapImagePath: placeBloc.state.places[index].mapImagePath),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
