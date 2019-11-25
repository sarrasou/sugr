import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:sugr/main.dart';

class Home extends StatelessWidget {
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

class CameraApp extends StatefulWidget {
  @override
  _CameraAppState createState() => _CameraAppState();
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
