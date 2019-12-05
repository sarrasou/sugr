import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:sugr/main.dart';

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

              List<dynamic> commonFoods = jsonDecode(response.body)["common"];

              var foods = List<Widget>();

              for (int i = 0; i < commonFoods.length; i++) {
                Map<String, String> foodInfo = {};
                foodInfo["title"] = commonFoods[i]["food_name"];
                foodInfo["serving_unit"] =
                    commonFoods[i]["serving_unit"].toString();
                foodInfo["serving_qty"] =
                    commonFoods[i]["serving_qty"].toString();

                var nutrients = commonFoods[i]["full_nutrients"];

                for (int j = 0; j < nutrients.length; j++) {
                  if (nutrients[j]["attr_id"] == 205) {
                    foodInfo["carbs"] = nutrients[j]["value"].toString();
                  }
                }

                Widget foodCard = FoodCard(foodInfo);

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

class FoodCard extends StatelessWidget {
  final Map<String, String> foodInfo;

  const FoodCard(this.foodInfo);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(this.foodInfo["title"]),
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(this.foodInfo["title"]),
                content: Column(
                  children: <Widget>[
                    Text("Serving Unit: " + this.foodInfo["serving_unit"]),
                    Text("Serving Quantity: " + this.foodInfo["serving_qty"]),
                    Text("Carbs: " + this.foodInfo["carbs"]),
                    Text("Insulin:" +
                        Provider.of<UserInfo>(context, listen: false)
                            .calculateInsulin(
                                double.parse(this.foodInfo["carbs"]))
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
        },
      ),
    );
  }
}
