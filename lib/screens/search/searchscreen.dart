import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
