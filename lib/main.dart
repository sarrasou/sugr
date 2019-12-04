import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:sugr/screens/search/searchscreen.dart';
import 'package:sugr/screens/home/homescreen.dart';
import 'package:provider/provider.dart';

List<CameraDescription> cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(ChangeNotifierProvider(
      builder: (context) => UserInfo(),
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => Home(),
          '/search': (context) => SearchWidget(),
          '/saved': (context) => SearchWidget(),
        },
      )));
}

class UserInfo with ChangeNotifier {
  int ratio;

  double calculateInsulin(double carbs) {
    double insulin = carbs / ratio;
    return insulin;
  }

  int getRatio(){
    return ratio;
  }

  void setRatio(int newRatio) {
    ratio = newRatio;
  }
}
