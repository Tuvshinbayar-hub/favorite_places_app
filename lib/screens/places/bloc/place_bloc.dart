import 'package:favorite_places_app/model/place.dart';
import 'package:favorite_places_app/screens/places/bloc/place_event.dart';
import 'package:favorite_places_app/screens/places/bloc/place_state.dart';
import 'package:favorite_places_app/utils/database_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlaceBloc extends Bloc<PlaceEvent, PlaceState> {
  PlaceBloc() : super(PlaceState(places: [])) {
    on<AddToPlaces>(_addPlace);
    on<RemoveFromPlaces>(_removePlace);
    on<FetchPlaces>(_fetchPlaces);
  }

  void _addPlace(event, emit) async {
    try {
      await DatabaseHelper().insertPlace({
        'title': event.place.title,
        'imagePath': event.place.imagePath,
        'address': event.place.address,
        'latitude': event.place.location.latitude,
        'longitude': event.place.location.longitude,
        'mapImagePath': event.place.mapImagePath,
      });

      final updatedPlaces = List<Place>.from(state.places)..add(event.place);
      emit(PlaceState(places: updatedPlaces));
    } catch (e) {
      emit(PlaceState(places: []));
    }
  }

  void _removePlace(RemoveFromPlaces event, Emitter<PlaceState> emit) async {
    final updatedPlaces = List<Place>.from(state.places)..remove(event.place);
    emit(PlaceState(places: updatedPlaces));
  }

  Future<void> _fetchPlaces(event, emit) async {
    List<Map<String, dynamic>> placesData =
        await DatabaseHelper().getAllPlaces();

    print(placesData);

    List<Place> places = placesData
        .map((place) => Place(
              title: place['title'],
              imagePath: place['imagePath'],
              address: place['address'],
              location: LatLng(
                place['latitude'],
                place['longitude'],
              ),
              mapImagePath: place['mapImagePath'],
            ))
        .toList();
    emit(PlaceState(places: places));
  }
}
