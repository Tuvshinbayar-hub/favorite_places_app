import 'package:favorite_places_app/model/place.dart';

abstract class PlaceEvent {}

class RemoveFromPlaces extends PlaceEvent {
  RemoveFromPlaces(this.place);

  final Place place;
}

class AddToPlaces extends PlaceEvent {
  AddToPlaces(this.place);

  final Place place;
}
