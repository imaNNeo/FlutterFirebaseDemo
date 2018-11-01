import 'package:flutter/material.dart';
import 'package:flutter_demo/database/db_menu.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: Text("Home"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              onPressed: () {
                openDbMenuPage(context);
              },
              child: Text("Realtime Database"),
            )
          ],
        ),
      ),
    );
  }

  void openDbMenuPage(BuildContext context) {
    Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
      return new DbMenuPage();
    }));
  }
}
