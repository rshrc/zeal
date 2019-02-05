import 'package:flutter/material.dart';

class DiscoverPeoplePage extends StatefulWidget {
  @override
  _DiscoverPeoplePageState createState() => _DiscoverPeoplePageState();
}

class _DiscoverPeoplePageState extends State<DiscoverPeoplePage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 32.0),
      child: GridView.count(
        // Create a grid with 2 columns. If you change the scrollDirection to
        // horizontal, this would produce 2 rows.
        crossAxisCount: 2,
        // Generate 100 Widgets that display their index in the List
        children: List.generate(100, (index) {
          return GestureDetector(
            onTap: (){
              Navigator.of(context).pushNamed("/other_profile");
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
              ),
              child: Column(
                children: <Widget>[
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                          radius: 48.0,
                          backgroundImage: AssetImage("assets/sample_image.jpg")),
                    ),
                  ),
                  Text("Username"),
                  RaisedButton(
                    onPressed: () {},
                    color: Theme.of(context).primaryColor,
                    child: Text(
                      "Connect",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
