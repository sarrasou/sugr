import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:sugr/screens/search/searchscreen.dart';
import 'package:sugr/screens/home/homescreen.dart';

List<CameraDescription> cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(MaterialApp(
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    initialRoute: '/',
    routes: {
      '/': (context) => Home(),
      '/search': (context) => SearchWidget(),
      '/saved': (context) => SearchWidget(),
    },
  ));
}
