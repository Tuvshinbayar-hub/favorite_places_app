import 'dart:io';

import 'package:favorite_places_app/model/place.dart';
import 'package:favorite_places_app/screens/places/bloc/place_bloc.dart';
import 'package:favorite_places_app/screens/places/bloc/place_event.dart';
import 'package:favorite_places_app/screens/places/bloc/place_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class PlaceCreatorScreen extends StatefulWidget {
  const PlaceCreatorScreen({super.key});

  @override
  State<PlaceCreatorScreen> createState() => _PlaceCreatorScreenState();
}

class _PlaceCreatorScreenState extends State<PlaceCreatorScreen> {
  final formKey = GlobalKey<FormState>();
  String? givenName;

  // implement error message to show different errors
  String? errorMessage;

  final ImagePicker _picker = ImagePicker();
  File? pickedImage;

  void uploadImage() async {
    XFile? takenImage =
        await _picker.pickImage(source: ImageSource.camera, maxWidth: 600);

    if (takenImage == null) {
      return;
    }

    final appDir = await getApplicationDocumentsDirectory();
    final fileName = path.basename(takenImage.path);
    final savedImage =
        await File(takenImage.path).copy('${appDir.path}/$fileName');

    setState(() {
      pickedImage = savedImage;
    });
  }

  void navigateToNextScreen(context) {
    Navigator.of(context).pop();
  }

  void saveValues(PlaceBloc bloc) {
    final newPlace = Place(title: givenName!, imagePath: pickedImage!.path);

    bloc.add(
      AddToPlaces(newPlace),
    );
  }

  bool validateTakenImage() {
    return pickedImage != null;
  }

  @override
  Widget build(BuildContext context) {
    final placeBloc = context.read<PlaceBloc>();

    Widget content = IconButton(
      iconSize: 40,
      onPressed: uploadImage,
      icon: Icon(
        Icons.camera,
      ),
    );

    if (pickedImage != null) {
      content = Image.file(pickedImage!, fit: BoxFit.cover);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Create new place'),
      ),
      body: BlocBuilder<PlaceBloc, PlaceState>(
        builder: (context, state) => Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        value.trim().length <= 1 ||
                        value.length >= 100) {
                      return 'Name be between 2...100 character';
                    }
                    return null;
                  },
                  decoration: InputDecoration(labelText: "Place name"),
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(),
                  onChanged: (value) => givenName = value,
                ),
                SizedBox(
                  height: 16,
                ),
                Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.white)),
                    child: content),
                SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (!formKey.currentState!.validate()) {
                          return;
                        }
                        if (!validateTakenImage()) {
                          return;
                        }
                        saveValues(placeBloc);
                        navigateToNextScreen(context);
                      },
                      child: Text(
                        'Submit',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: Colors.white),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
