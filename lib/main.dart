import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:sugr/screens/search_screen/search_screen.dart';
import 'package:sugr/screens/home_screen/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:sugr/screens/user_input_screen/user_input_screen.dart';
import 'package:sugr/screens/cam_screen/cam_screen.dart';

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
          '/saved': (context) => UserInput(),
          '/cam': (context) => CamWidget()
        },
      )));
}

class UserInfo with ChangeNotifier {
  // default insulin ratio is usually 10
  int ratio = 10;

  double calculateInsulin(double carbs) {
    double insulin = carbs / ratio;
    return insulin;
  }

  int getRatio() {
    return ratio;
  }

  void setRatio(int newRatio) {
    ratio = newRatio;
  }
}
