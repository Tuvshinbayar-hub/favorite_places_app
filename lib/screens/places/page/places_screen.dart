import 'package:favorite_places_app/screens/places/bloc/place_bloc.dart';
import 'package:favorite_places_app/screens/places/bloc/place_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlacesScreen extends StatelessWidget {
  const PlacesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite places'),
      ),
      body: BlocBuilder<PlaceBloc, PlaceState>(
        builder: (context, state) => Stack(
          children: [
            ListView.builder(
              itemCount: 3,
              itemBuilder: (context, index) => Text('jojo'),
            )
          ],
        ),
      ),
    );
  }
}
