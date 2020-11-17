import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test_task/models/models.dart';
import 'package:flutter_test_task/models/user.dart' as user;
import 'package:shared_preferences/shared_preferences.dart';

class PageLogin extends StatefulWidget{

  final String pageName;

  PageLogin({
    this.pageName
  });

  @override
  _PageLoginState createState() => _PageLoginState();

}

class _PageLoginState extends State<PageLogin>{

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String _name;

  @override
  void initState() {
    super.initState();
    _name = widget.pageName;
    _initializeFlutterFire();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text(_name),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: [
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(top: 40),
              child: Text("Email",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 50),
              child: TextFormField(
                controller: _emailController,
                autofocus: true,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    labelText: "Email",
                    suffixIcon: _clearIconButton(_emailController),
                    prefixStyle: TextStyle(color: Colors.black, fontSize: 16),
                    icon: Icon(Icons.email)
                ),
                onChanged: (_){
                  setState(() {});
                },
                validator: (value) {
                  if(!EmailValidator.validate(value)) return "A valid email is required";
                  return null;
                },

              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(top: 40),
              child: Text("Password",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 50),
              child: TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                    labelText: "Password",
                    suffixIcon: _clearIconButton(_passwordController),
                    prefixStyle: TextStyle(color: Colors.black, fontSize: 16),
                    icon: Icon(Icons.lock)
                ),
                validator: (value) {
                  if(value.trim().length < 6) return "Password must be at least 6 characters";
                  return null;
                },
                onChanged: (_){
                  setState(() {});
                },

              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 50),
              child: _name == "Sign In" ? FlatButton(
                onPressed: () async {
                  if(_formKey.currentState.validate()){
                    try {
                      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                        email: _emailController.text,
                        password: _passwordController.text,
                      );
                      if (userCredential.user.uid.isNotEmpty && await _setPrefs(userCredential.user.uid, userCredential.user.email)) {
                        _scaffoldKey.currentState.showSnackBar(
                            SnackBar(
                              duration: Duration(seconds: 1),
                              content: Container(height: 20, child: Text("Login successful"), alignment: Alignment.center,),
                              backgroundColor: Colors.green,
                            )
                        );
                        _navigateToShop(userCredential.user.uid, userCredential.user.email);
                      }
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'user-not-found') {
                        _scaffoldKey.currentState.showSnackBar(
                            SnackBar(
                              duration: Duration(seconds: 1),
                              content: Container(height: 20, child: Text("User not found"), alignment: Alignment.center,),
                              backgroundColor: Colors.orange,
                            )
                        );
                      } else if (e.code == 'wrong-password') {
                        _scaffoldKey.currentState.showSnackBar(
                            SnackBar(
                              duration: Duration(seconds: 1),
                              content: Container(height: 20, child: Text("Wrong password provided for that user"), alignment: Alignment.center,),
                              backgroundColor: Colors.orange,
                            )
                        );
                      }
                    }
                  }
                },
                child: Text("Sign In",
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              ) : FlatButton(
                onPressed: () async {
                  try {
                    UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                      email: _emailController.text,
                      password: _passwordController.text,
                    );
                    if (userCredential.user.uid.isNotEmpty && await _setPrefs(userCredential.user.uid, userCredential.user.email)) {
                      _scaffoldKey.currentState.showSnackBar(
                          SnackBar(
                            duration: Duration(seconds: 1),
                            content: Container(height: 20, child: Text("Register successful"), alignment: Alignment.center,),
                            backgroundColor: Colors.green,
                          )
                      );
                      _navigateToShop(userCredential.user.uid, userCredential.user.email);
                    }
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'weak-password') {
                      _scaffoldKey.currentState.showSnackBar(
                          SnackBar(
                            duration: Duration(seconds: 1),
                            content: Container(height: 20, child: Text("The password provided is too weak."), alignment: Alignment.center,),
                            backgroundColor: Colors.orange,
                          )
                      );
                    } else if (e.code == 'email-already-in-use') {
                      _scaffoldKey.currentState.showSnackBar(
                          SnackBar(
                            duration: Duration(seconds: 1),
                            content: Container(height: 20, child: Text("The account already exists for that email."), alignment: Alignment.center,),
                            backgroundColor: Colors.orange,
                          )
                      );
                    }
                  } catch (e) {
                    print(e);
                  }
                },
                child: Text("Sign Up",
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _clearIconButton(TextEditingController textController) {
    if (textController.text.isEmpty)
      return null;
    else
      return IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            setState(() {
              textController.clear();
            });
          });
  }

  void _initializeFlutterFire() async {
    try {
      await Firebase.initializeApp();
    } catch(e) {
      print(e);
    }
  }

  Future<bool> _setPrefs(String userId, String email) async {
    final _prefs = await SharedPreferences.getInstance();
    return await _prefs.setString("user_id", userId) && await _prefs.setString("user_email", email);
  }

  void _navigateToShop(String userId, String email){
    RouteArgs _args = RouteArgs(
      user: user.User(userID: userId, email: email),
    );
    Navigator.of(context).pushNamedAndRemoveUntil("/shop", (Route<dynamic> route) => false, arguments: _args);
  }

}