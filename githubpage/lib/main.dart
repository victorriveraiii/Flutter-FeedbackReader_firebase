import 'package:flutter/material.dart';
import './models/user_repository.dart';
import 'package:provider/provider.dart';
import './login_page.dart';
import './homepage.dart';

void main() => runApp(MyApp());


class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Github Page',
      theme: ThemeData.dark().copyWith(
          primaryColor: Colors.deepOrange,
          accentColor: Colors.deepOrangeAccent),
      home: RootPage(),
    );
  }
}

class RootPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (_) => UserRepository.instance(),
      child: Consumer(
        builder: (context, UserRepository user, _) {
          switch (user.status) {
            case Status.Uninitialized:
              return Splash();
            case Status.Unauthenticated:
            case Status.Authenticating:
              return LoginPage();
            case Status.Authenticated:
              return HomePage(user: user.user);
          }
        },
      ),
    );
  }
}

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "Loading...",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
