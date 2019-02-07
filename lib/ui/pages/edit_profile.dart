import 'package:flutter/material.dart';

/// Changeable User Attributes
/// Email Address
/// Phone Number
/// Password
/// Add or Remove Hobbies
/// Change Profile Picture
/// Many more (not yet decided attributes)

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Dialog(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: "Email ID",
                  hintText: "Email ID",
                  suffixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: "Phone Number",
                  hintText: "Phone Number",
                  suffixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: ButtonTheme(
                    shape: OutlineInputBorder(
                        borderSide: BorderSide(
                      color: Colors.black,
                    )),
                    buttonColor: Colors.grey,
                    child: RaisedButton(
                      onPressed: () {},
                      child: Text(
                        "Zeal It!",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: ButtonTheme(
                    shape: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                        )),
                    buttonColor: Colors.grey,
                    child: RaisedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "Go Back",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
