import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import './models/user_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  final FirebaseUser user;
  const HomePage({Key key, this.user}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Firestore _db = Firestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging();
  @override
  void initState() {
    // _fcm.configure(
    //   onMessage: (Map<String, dynamic> message) async {
    //     print("onMessage: $message");
    //     showDialog(
    //       context: context,
    //       builder: (context) => AlertDialog(
    //         content: ListTile(
    //           title: Text(message['notification']['title']),
    //           subtitle: Text(message['notification']['body']),
    //         ),
    //         actions: <Widget>[
    //           FlatButton(
    //             child: Text('Ok'),
    //             onPressed: () => Navigator.of(context).pop(),
    //           ),
    //         ],
    //       ),
    //     );
    //   },
    //     onLaunch: (Map<String, dynamic> message) async {
    //       print("onLaunch: $message");
    //       // TODO optional
    //     },
    //     onResume: (Map<String, dynamic> message) async {
    //       print("onResume: $message");
    //       // TODO optional
    //     },
    // );
    _saveDeviceToken();
  }

  _saveDeviceToken() async {
    String fcmToken = await _fcm.getToken();

    if (fcmToken != null) {
      var token = _db.collection('tokens').document('key');

      token.setData({'token': fcmToken});
      print(fcmToken);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GitHub Page Messages'),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              var token = _db.collection('tokens').document('key');
              token.setData({'token': 'null'});
              Provider.of<UserRepository>(context).signOut();
            },
            icon: Icon(Icons.exit_to_app),
            tooltip: "SignOut",
          )
        ],
      ),
      body: StreamBuilder(
        stream: Firestore.instance
            .collection('database')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());
          return FirestoreListView(documents: snapshot.data.documents);
        },
      ),
    );
  }
}

class FirestoreListView extends StatelessWidget {
  final List<DocumentSnapshot> documents;
  FirestoreListView({this.documents});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: documents.length,
        itemBuilder: (BuildContext context, int index) {
          String name = documents[index].data['name'].toString();
          String subject = documents[index].data['subject'].toString();

          return Card(
            child: InkWell(
              onTap: () {
                String email = documents[index].data['email'].toString();
                String message = documents[index].data['message'].toString();
                showMore(context, documents[index].documentID, name, email,
                    subject, message);
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  ListTile(
                    leading: Text(
                      'Name:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    title: Text(
                      name,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  ListTile(
                    leading: Text(
                      'Subject:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    title: Text(subject),
                  ),
                ],
              ),
            ),
          );
        });
  }
}

showMore(context, docId, name, email, subject, message) {
  showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          child: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Wrap(
              children: <Widget>[
                Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                          child: Center(
                            child: Text(
                              name,
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                          child: Text(
                            "Email : " + email,
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                          child: Text(
                            "Subject : " + subject,
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: Text(
                            "Message : " + message,
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ],
                    )),
                Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      FlatButton(
                        child: Text(
                          "Delete",
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                          Firestore.instance
                              .collection('database')
                              .document(docId)
                              .delete()
                              .catchError((e) {
                            print(e);
                          });
                        },
                      ),
                      FlatButton(
                        child: Text(
                          "Done",
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      });
}
