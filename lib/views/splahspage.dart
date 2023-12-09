import 'dart:async';
import 'dart:convert';
import 'package:bookbytes/shared/myserverconfig.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import 'mainpage.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    /*User user = User(
         id: "0",
         email: "unregistered@email.com",
         name: "unregistered",
         regdate: "",
         address:"",
         phone:"",
         otp:"",
         );
     Timer(
         const Duration(seconds: 3),
        () => Navigator.pushReplacement(
            context,
             MaterialPageRoute(
               builder: (content) => MainPage(
                       userdata: user,
                     ))));*/
    checkandlogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/images/background.png'), // Replace with your image path
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end, // Align to the bottom
            children: [
              const Spacer(), // Takes up remaining space above the CircularProgressIndicator
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: const EdgeInsets.only(
                      bottom: 32), // Adjust margin as needed
                  child: const CircularProgressIndicator(),
                ),
              ),
              const Text("Version 0.1"),
            ],
          ),
        ),
      ),
    );
  }

  checkandlogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = (prefs.getString('email')) ?? '';
    String password = (prefs.getString('pass')) ?? '';
    bool rem = (prefs.getBool('rem')) ?? false;
    if (rem) {
      http.post(
          Uri.parse("${MyServerConfig.server}/bookbytes/php/login_user.php"),
          body: {"email": email, "password": password}).then((response) {
        if (response.statusCode == 200) {
          var data = jsonDecode(response.body);
          if (data['status'] == "success") {
            User user = User.fromJson(data['data']);
            Timer(
                const Duration(seconds: 3),
                () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (content) => MainPage(
                              userdata: user,
                            ))));
          } else {
            User user = User(
              id: "0",
              email: "unregistered@email.com",
              name: "unregistered",
              regdate: "",
              address: "",
              phone: "",
              otp: "",
            );
            Timer(
                const Duration(seconds: 3),
                () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (content) => MainPage(
                              userdata: user,
                            ))));
          }
        }
      });
    } else {
      User user = User(
        id: "0",
        email: "unregistered@email.com",
        name: "unregistered",
        regdate: "",
        address: "",
        phone: "",
        otp: "",
      );
      Timer(
          const Duration(seconds: 3),
          () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (content) => MainPage(
                        userdata: user,
                      ))));
    }
  }
}
