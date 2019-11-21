import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

List<CameraDescription> cameras;

Future<void> main() async {
  cameras = await availableCameras();
  runApp(MaterialApp(
    title: 'Sugr',
    initialRoute: '/',
    routes: {
      '/': (context) => Home(),
      '/saved': (context) => Saved(),
    },
  ));
}

class Home extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
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
            showDialog(
              context: context,
              builder: (BuildContext context) => _buildDialog(context),
            );
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
                  "icons/baseline_search_white_18dp.png", "Search desc"),
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

class Saved extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Information"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.pop(context);
              }),
        ],
      ),
      body: InputWidget(),
    );
  }
}

class InputWidget extends StatefulWidget {
  InputWidget({Key key}) : super(key: key);

  @override
  _InputWidgetState createState() => _InputWidgetState();
}

class _InputWidgetState extends State<InputWidget> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: RaisedButton(
              onPressed: () {
                // Validate will return true if the form is valid, or false if
                // the form is invalid.
                if (_formKey.currentState.validate()) {
                  // Process data.
                }
              },
              child: Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
}
