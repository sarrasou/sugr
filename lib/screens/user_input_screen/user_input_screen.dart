import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sugr/main.dart';

class UserInput extends StatefulWidget {
  @override
  _UserInputState createState() => _UserInputState();
}

class _UserInputState extends State<UserInput> {
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
          title: Text('Ratio Input'),
          // actions: <Widget>[
          //   IconButton(
          //       icon: Icon(Icons.arrow_back_ios),
          //       onPressed: () {
          //         Navigator.pop(context);
          //       }),
          // ],
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
                child: Text("Input carbs per unit of insulin above."),
              ),
            ],
          ),
        ),
        floatingActionButton: Builder(builder: (BuildContext context) {
          return FloatingActionButton(
            // When the user presses the button, show an alert dialog containing
            // the text that the user has entered into the text field.
            onPressed: () {
              var text = searchController.text;
              Provider.of<UserInfo>(context, listen: false)
                  .setRatio(int.parse(text));
              Navigator.pop(context);
            },
            child: Icon(Icons.add),
          );
        }));
  }
}
