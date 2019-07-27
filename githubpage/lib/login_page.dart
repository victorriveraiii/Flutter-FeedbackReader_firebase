import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './models/user_repository.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _email;
  String _password;
  String _subtittle = 'Please Login to Continue';

  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  final _key = GlobalKey<ScaffoldState>();

  TextEditingController _emailcon = TextEditingController();
  TextEditingController _passwordcon = TextEditingController();

  FocusNode passfocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _emailcon = TextEditingController(text: "");
    _passwordcon = TextEditingController(text: "");
  }

  @override
  void dispose() {
    _emailcon.dispose();
    _passwordcon.dispose();
    super.dispose();
  }

  bool isFormValid() {
    if (_emailcon.text != '' && _passwordcon.text != '') {
      return true;
    }
    return false;
  }

  void submitButton() async {
    final user = Provider.of<UserRepository>(context);
    if (isFormValid()) {
      _email = _emailcon.text.toString();
      _password = _passwordcon.text.toString();
      try {
        bool x = await user.signIn(_email, _password);
        if (!x) {
          setState(() {
            _subtittle = 'Sign In Error';
          });
        }
      } catch (e) {
        setState(() {
          _subtittle = 'Sign In Error';
          // _subtittle = 'Sign In Error\n\n${e.toString()}';
        });
        print("Sign In Error :: $e");
      }
    } else {
      setState(() {
        _subtittle = 'Please Enter Correct Email and Pasword';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // final user = Provider.of<UserRepository>(context);
    // ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);
    return Scaffold(
        key: _key,
        body: ListView(children: <Widget>[
          Container(
              // height: MediaQuery.of(context).size.height,
              // decoration: BoxDecoration(
              // color: widget.backgroundColor,
              // ),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
//WelCome Text
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(top: 50.0, bottom: 50.0),
                  // margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                  child: Column(
                    children: <Widget>[
                      Text(
                        "WELCOME",
                        style: TextStyle(
                          fontSize: 50.0,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      Text(
                        _subtittle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w300,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
// Email Text Field
                Padding(
                  padding: const EdgeInsets.only(left: 40.0),
                  child: Text(
                    "Email",
                    style: TextStyle(color: Colors.grey, fontSize: 16.0),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.5),
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  margin: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 20.0),
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 15.0),
                        child: Icon(
                          Icons.person_outline,
                          color: Colors.grey,
                        ),
                      ),
                      Container(
                        height: 30.0,
                        width: 1.0,
                        color: Colors.grey.withOpacity(0.5),
                        margin: const EdgeInsets.only(left: 00.0, right: 10.0),
                      ),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Enter your email',
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                          autofocus: false,
                          autocorrect: false,
                          controller: _emailcon,
                          keyboardType: TextInputType.emailAddress,
                          onSubmitted: (value) {
                            FocusScope.of(context).requestFocus(passfocus);
                          },
                        ),
                      )
                    ],
                  ),
                ),
// Password Text Field
                Padding(
                  padding: const EdgeInsets.only(left: 40.0),
                  child: Text(
                    "Password",
                    style: TextStyle(color: Colors.grey, fontSize: 16.0),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.5),
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  margin: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 20.0),
                  child: Row(
                    children: <Widget>[
                      new Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 15.0),
                        child: Icon(
                          Icons.lock_open,
                          color: Colors.grey,
                        ),
                      ),
                      Container(
                        height: 30.0,
                        width: 1.0,
                        color: Colors.grey.withOpacity(0.5),
                        margin: const EdgeInsets.only(left: 00.0, right: 10.0),
                      ),
                      new Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Enter your password',
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                          focusNode: passfocus,
                          obscureText: true,
                          autofocus: false,
                          autocorrect: false,
                          controller: _passwordcon,
                          onSubmitted: (value) {
                            submitButton();
                          },
                        ),
                      )
                    ],
                  ),
                ),
// Login Button
                Container(
                  margin: const EdgeInsets.only(top: 20.0),
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: FlatButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0)),
                          splashColor: Theme.of(context).primaryColor,
                          color: Theme.of(context).primaryColor,
                          child: Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Text(
                                  'Log In',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              new Expanded(
                                child: Container(),
                              ),
                              new Transform.translate(
                                offset: Offset(15.0, 0.0),
                                child: new Container(
                                  padding: const EdgeInsets.only(right: 5),
                                  child: FlatButton(
                                    shape: new RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(28.0)),
                                    splashColor: Colors.white,
                                    color: Colors.white,
                                    child: Icon(
                                      Icons.arrow_forward,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    onPressed: submitButton,
                                  ),
                                ),
                              )
                            ],
                          ),
                          onPressed: submitButton,
                        ),
                      ),
                    ],
                  ),
                ),
              ]))
        ]));
  }
}
