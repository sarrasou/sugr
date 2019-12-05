import 'dart:async';
import 'dart:convert';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:sugr/main.dart';
import 'package:http/http.dart' as http;

class CamWidget extends StatefulWidget {
  @override
  _CamWidgetState createState() => _CamWidgetState();
}

class _CamWidgetState extends State<CamWidget> {
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Camera'),
      ),
      body: AspectRatio(
          aspectRatio: controller.value.aspectRatio,
          child: CameraPreview(controller)),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera_alt),
        onPressed: () async {
          final path = join(
            // Store the picture in the temp directory.
            // Find the temp directory using the `path_provider` plugin.
            (await getTemporaryDirectory()).path,
            '${DateTime.now()}.png',
          );
          await controller.takePicture(path);

          String url =
              "https://eastus.api.cognitive.microsoft.com/vision/v2.1/analyze?visualFeatures=Tags&language=en";
          var headers = {
            "Ocp-Apim-Subscription-Key": "1c41559437aa49af831d9d70a8ce8c10",
            "Content-Type": "application/octet-stream",
          };

          final picture = new File(path).readAsBytesSync();

          var response = await http.post(url, headers: headers, body: picture);
          print(response.body);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DisplayPictureScreen(imagePath: path),
            ),
          );
        },
      ),
    );
  }
}

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({Key key, this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Display the Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Image.file(File(imagePath)),
    );
  }
}
