import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DbMenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: Text("Realtime Database"),
      ),
      body: StreamBuilder(
          stream: Firestore.instance.collection('test').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting ||
                !snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              List<DocumentSnapshot> documents = snapshot.data.documents;
              return ListView.builder(
                itemBuilder: (context, index) {
                  DocumentSnapshot documentSnapshot = documents[index];
                  return new ListTile(
                    title: Text(documentSnapshot.data["title"]),
                    subtitle: Text(
                      documentSnapshot.data["sub_title"],
                    ),
                    onLongPress: () {
                      tryToRemove(context, documentSnapshot);
                    },
                  );
                },
                itemCount: documents.length,
              );
            }
          }),
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          createRecord(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void createRecord(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          final titleController = TextEditingController();
          final subtitleController = TextEditingController();
          return new Dialog(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(hintText: "Enter the title"),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: TextField(
                      controller: subtitleController,
                      decoration:
                          InputDecoration(hintText: "Enter the sub title"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop({
                            'title': titleController.text,
                            'sub_title': subtitleController.text
                          });
                        },
                        child: Text(
                          "Save",
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        )),
                  )
                ],
              ),
            ),
          );
        }).then((result) {
      Firestore.instance.collection("test").document().setData(
          {'title': result['title'], 'sub_title': result['sub_title']});
    });
  }

  void tryToRemove(BuildContext context, DocumentSnapshot document) {
    final String name = document.data['title'];
    showDialog(
        context: context,
        builder: (context) {
          return new AlertDialog(
            title: Text("Are you sure to remove $name ?"),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  "Cancel",
                  style: TextStyle(color: Theme.of(context).disabledColor),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text(
                  "Remove",
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
                onPressed: () {
                  document.reference.delete();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

}