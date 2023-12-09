import 'dart:convert';
//import 'package:bookbytes/main.dart';
import 'package:bookbytes/shared/myserverconfig.dart';
import 'package:bookbytes/views/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController _nameEditingController = TextEditingController();
  final TextEditingController _emailditingController = TextEditingController();
  final TextEditingController _phoneEditingController = TextEditingController();
  final TextEditingController _passEditingController = TextEditingController();
  final TextEditingController _pass2EditingController = TextEditingController();
  final TextEditingController _addressEditingController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String eula = "";
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Registration Form")),
        body: SingleChildScrollView(
          child: Center(
            child: Column(children: [
              Image.asset("assets/images/profile.png"),
              Container(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Card(
                    elevation: 10,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                      child: Column(children: [
                        const Text(
                          "User Registration",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        TextFormField(
                          controller: _nameEditingController,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            labelText: 'Name',
                            icon: Icon(Icons.person),
                          ),
                          validator: (val) => val!.isEmpty || (val.length < 3)
                              ? "name must be longer than 3"
                              : null,
                        ),
                        TextFormField(
                          controller: _emailditingController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            icon: Icon(Icons.email),
                          ),
                          validator: (val) => val!.isEmpty ||
                                  !val.contains("@") ||
                                  !val.contains(".")
                              ? "enter a valid email"
                              : null,
                        ),
                        TextFormField(
                          controller: _phoneEditingController,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            labelText: 'Phone',
                            icon: Icon(Icons.person),
                          ),
                          /*validator: (val) => val!.isEmpty || (val.length < 3)
                              ? "name must be longer than 3"
                              : null,*/
                        ),
                        TextFormField(
                          controller: _passEditingController,
                          keyboardType: TextInputType.text,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: 'Password',
                            icon: Icon(Icons.lock),
                          ),
                          validator: (val) => validatePassword(val.toString()),
                        ),
                        TextFormField(
                          controller: _pass2EditingController,
                          keyboardType: TextInputType.text,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: 'Re-enter Password',
                            icon: Icon(Icons.lock),
                          ),
                          validator: (val) => validatePassword(val.toString()),
                        ),
                        TextFormField(
                          controller: _addressEditingController,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            labelText: 'Address',
                            icon: Icon(Icons.person),
                          ),
                          /*validator: (val) => val!.isEmpty || (val.length < 3)
                              ? "name must be longer than 3"
                              : null,*/
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Checkbox(
                              value: _isChecked,
                              onChanged: (bool? value) {
                                setState(() {
                                  _isChecked = value!;
                                });
                              },
                            ),
                            GestureDetector(
                                /*onTap: _showEULA,*/
                                child: const Text("Agree with terms?")),
                            ElevatedButton(
                                onPressed: _registerUserDialog,
                                child: const Text("Register"))
                          ],
                        )
                      ]),
                    ),
                  ),
                ),
              ),
            ]),
          ),
        ));
  }

  String? validatePassword(String value) {
    String pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{6,}$';
    RegExp regex = RegExp(pattern);
    if (value.isEmpty) {
      return 'Please enter password';
    } else {
      if (!regex.hasMatch(value)) {
        return 'Enter valid password';
      } else {
        return null;
      }
    }
  }

  void _registerUserDialog() {
    String _pass = _passEditingController.text;
    String _pass2 = _pass2EditingController.text;
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (!_isChecked) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please accept EULA"),
        backgroundColor: Colors.red,
      ));
      return;
    }
    if (_pass != _pass2) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Password do not match!!!"),
        backgroundColor: Colors.red,
      ));
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "Register new account?",
            style: TextStyle(),
          ),
          content: const Text("Are you sure?", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                print('Yes button pressed');
                Navigator.of(context).pop();
                _registerUser();
              },
            ),
            TextButton(
              child: const Text(
                "No",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Registration Canceled"),
                  backgroundColor: Colors.red,
                ));
              },
            ),
          ],
        );
      },
    );
  }

  loadEula() async {
    eula = await rootBundle.loadString('assets/eula.txt');
  }

  void _showEULA() {
    loadEula();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("EULA", style: TextStyle()),
          content: SizedBox(
            // Get screen width and height using MediaQuery
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: SingleChildScrollView(
                    child: RichText(
                      softWrap: true,
                      textAlign: TextAlign.justify,
                      text: TextSpan(
                        style: const TextStyle(
                            fontSize: 12.0, color: Colors.black),
                        text: eula,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  void _registerUser() {
    try {
      print("Registering user...");

      String _name = _nameEditingController.text;
      String _email = _emailditingController.text;
      String _pass = _passEditingController.text;
      String _phone = _phoneEditingController.text;
      String _address = _addressEditingController.text;

      http.post(
          Uri.parse("${MyServerConfig.server}/BookBytes/php/register_user.php"),
          body: {
            "register": "true",
            "name": _name,
            "email": _email,
            "phone": _phone,
            "password": _pass,
            "address": _address,
          }).then((response) async {
        print("Response status code: ${response.statusCode}");
        print("Response body: ${response.body}");

        if (response.statusCode == 200) {
          var data = json.decode(response.body);
          print(data);
          if (data['status'] == "success") {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Registration Success"),
              backgroundColor: Colors.green,
            ));
            Navigator.push(
                context, MaterialPageRoute(builder: (content) => LoginPage()));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Registration Failed"),
              backgroundColor: Colors.red,
            ));
          }
        }
      });
    } catch (e) {
      print("Error in _registerUser(): $e");
    }
  }
}
