import 'package:favorite_places_app/model/place.dart';
import 'package:favorite_places_app/screens/places/bloc/place_event.dart';
import 'package:favorite_places_app/screens/places/bloc/place_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlaceBloc extends Bloc<PlaceEvent, PlaceState> {
  PlaceBloc() : super(PlaceState(places: [])) {
    on<AddToPlaces>((event, emit) {
      final updatedPlaces = List<Place>.from(state.places)..add(event.place);
      emit(PlaceState(places: updatedPlaces));
    });
    on<RemoveFromPlaces>((event, emit) {
      final updatedMeals = List<Place>.from(state.places);

      updatedMeals.remove(event.place);
      emit(PlaceState(places: updatedMeals));
    });
  }
}
