import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SearchWidget extends StatefulWidget {
  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final searchController = TextEditingController();
  Widget _foods = ListView(children: <Widget>[]);

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
        body: Container(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: searchController,
                ),
              ),
              Expanded(
                child: _foods,
              ),
            ],
          ),
        ),
        floatingActionButton: Builder(builder: (BuildContext context) {
          return FloatingActionButton(
            // When the user presses the button, show an alert dialog containing
            // the text that the user has entered into the text field.
            onPressed: () async {
              var url =
                  "https://trackapi.nutritionix.com/v2/search/instant?query=${searchController.text}&detailed=true";
              var headers = {
                "x-app-id": "314dccf6",
                "x-app-key": "3ff9cb2d68cd00e7779deb4fa93fea07"
              };

              Scaffold.of(context)
                  .showSnackBar(SnackBar(content: Text("Loading")));

              var response = await http.get(url, headers: headers);

              Scaffold.of(context).hideCurrentSnackBar();
              Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text("Loaded"), duration: Duration(seconds: 1)));

              Map<String, dynamic> body = jsonDecode(response.body);

              var foods = List<Widget>();

              for (int i = 0; i < body["common"].length; i++) {
                Widget foodCard = Card(
                  child: ListTile(
                    title: Text(body["common"][i]["food_name"]),
                  ),
                );

                foods.add(foodCard);
              }

              setState(() {
                _foods = ListView(children: foods);
              });
            },
            child: Icon(Icons.search),
          );
        }));
  }
}
