import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

List<CameraDescription> cameras;

Future<void> main() async {
  cameras = await availableCameras();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
            IconButton(icon: Icon(Icons.account_circle), onPressed: _userInfo),
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

  void _userInfo() {
    //  showDialog(
    //   context: context,
    //   builder: (BuildContext context) => _buildDialog(context)
    // );
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
  final String buttonText;
  final String popupDesc;

  const ActionButton(this.buttonText, this.popupDesc);

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
            child: Text(buttonText)),
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
              child: ActionButton("Scan", "scan desc"),
            ),
            Expanded(
              child: ActionButton("Camera", "cam desc"),
            ),
            Expanded(
              child: ActionButton("Search", "search desc"),
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
