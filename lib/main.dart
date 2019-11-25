import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;

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

class Home extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("sugr"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.account_circle),
              onPressed: () {
                Navigator.pushNamed(context, '/saved');
              }),
        ],
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Center(
                child: CameraWidget(),
              ),
            ),
            Center(
              child: ActionBar(),
            ),
          ],
        ),
      ),
    );
  }
}

class CameraWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      color: Colors.blue[300],
      height: 400.0,
      width: 265.0,
      child: Center(
        child: CameraApp(),
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  final String iconPath;
  final String popupDesc;

  const ActionButton(this.iconPath, this.popupDesc);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      color: Colors.blue[300],
      width: 100.0,
      height: 50.0,
      child: Center(
        child: FlatButton(
          onPressed: () {
            if (popupDesc == "search") {
              Navigator.pushNamed(context, '/search');
            } else {
              showDialog(
                context: context,
                builder: (BuildContext context) => _buildDialog(context),
              );
            }
          },
          child: Image(image: AssetImage(iconPath)),
        ),
      ),
    );
  }

  Widget _buildDialog(BuildContext context) {
    return new AlertDialog(
      title: Text(popupDesc),
    );
  }
}

class ActionBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: ActionButton(
                  "icons/baseline_scanner_white_18dp.png", "Scan desc"),
            ),
            Expanded(
              child: ActionButton(
                  "icons/baseline_photo_camera_white_18dp.png", "Camera desc"),
            ),
            Expanded(
              child: ActionButton(
                  "icons/baseline_search_white_18dp.png", "search"),
            ),
          ],
        ),
      ),
    );
  }
}

class CameraApp extends StatefulWidget {
  @override
  _CameraAppState createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  CameraController controller;

  @override
  void initState() {
    super.initState();
    controller = CameraController(cameras[0], ResolutionPreset.medium);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container();
    }
    return AspectRatio(
        aspectRatio: controller.value.aspectRatio,
        child: CameraPreview(controller));
  }
}

class SearchWidget extends StatefulWidget {
  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.pop(context);
              }),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: searchController,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        // When the user presses the button, show an alert dialog containing
        // the text that the user has entered into the text field.
        onPressed: () async {
          var url =
              "https://trackapi.nutritionix.com/v2/search/instant?query=${searchController.text}&detailed=true";
          var headers = {
            "x-app-id": "314dccf6",
            "x-app-key": "3ff9cb2d68cd00e7779deb4fa93fea07"
          };
          var response = await http.get(url, headers: headers);

          return showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                // Retrieve the text the that user has entered by using the
                // TextEditingController.
                content: Text(response.body),
              );
            },
          );
        },
        tooltip: 'Show me the value!',
        child: Icon(Icons.search),
      ),
    );
  }
}
