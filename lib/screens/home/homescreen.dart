import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:sugr/main.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';

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
                  Icon(Icons.scanner, color: Colors.white), "scan"),
            ),
            Expanded(
              child: ActionButton(
                  Icon(Icons.photo_camera, color: Colors.white), "Camera desc"),
            ),
            Expanded(
              child: ActionButton(
                  Icon(Icons.search, color: Colors.white), "search"),
            ),
          ],
        ),
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  final Icon icon;
  final String popupDesc;

  const ActionButton(this.icon, this.popupDesc);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      color: Colors.blue[300],
      width: 100.0,
      height: 50.0,
      child: Center(
        child: FlatButton(
          onPressed: () async {
            if (popupDesc == "search") {
              Navigator.pushNamed(context, '/search');
            } else if (popupDesc == "scan") {
              String barcodeValue = (await FlutterBarcodeScanner.scanBarcode(
                  "#FF0000", "Cancel", false, ScanMode.BARCODE));
              dynamic barcodeNutritionResponse =
                  await barcodeValueResponse(barcodeValue);
              String servingUnit = barcodeNutritionResponse[0]["serving_unit"];
              String servingQuantity =
                  barcodeNutritionResponse[0]["serving_qty"].toString();
              String carbs =
                  barcodeNutritionResponse[0]["nf_total_carbohydrate"].toString();
              // nutrition info
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(barcodeNutritionResponse[0]["food_name"]),
                    content: Column(
                      children: <Widget>[
                        Text("Serving Unit: " + servingUnit),
                        Text("Serving Quantity: " + servingQuantity),
                        Text("Carbs: " + carbs),
                        Text("Insulin:" +
                            Provider.of<UserInfo>(context, listen: false)
                                .calculateInsulin(double.parse(carbs))
                                .toString()),
                        Text("Current ratio:" +
                            "1/" +
                            Provider.of<UserInfo>(context, listen: false)
                                .getRatio()
                                .toString())
                      ],
                    ),
                  );
                },
              );
            } else {
              showDialog(
                context: context,
                builder: (BuildContext context) => _buildDialog(context),
              );
            }
          },
          child: icon,
        ),
      ),
    );
  }

  dynamic barcodeValueResponse(String barcodeValue) async {
    var url =
        "https://trackapi.nutritionix.com/v2/search/item?upc=" + barcodeValue;
    var headers = {
      "x-app-id": "314dccf6",
      "x-app-key": "3ff9cb2d68cd00e7779deb4fa93fea07"
    };

    var response = await http.get(url, headers: headers);

    dynamic barcodeNutritionInfo = jsonDecode(response.body)["foods"];
    print(jsonDecode(response.body)["foods"]);

    print(barcodeNutritionInfo[0]["serving_unit"]);
    print(barcodeNutritionInfo[0]["serving_qty"]);
    print(barcodeNutritionInfo[0]["nf_total_carbohydrate"]);

    return barcodeNutritionInfo;
  }

  Widget _buildDialog(BuildContext context) {
    return new AlertDialog(
      title: Text(popupDesc),
    );
  }
}
