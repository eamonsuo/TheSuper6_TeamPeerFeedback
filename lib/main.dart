// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:deco3801_project/mainStructures/student_home.dart';
import 'package:deco3801_project/mainStructures/tutor_home.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: SignInPage(),
    );
  }
}

class SignInPage extends StatefulWidget {
  @override
  _SignInPage createState() => _SignInPage();
}

class _SignInPage extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              alignment: Alignment.topCenter,
              padding: const EdgeInsets.all(20),
              child: const Text(
                'Team Peer Feedback',
                style: TextStyle(
                  fontFamily: 'Arial',
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 38, 153, 251),
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height / 2.7,
              padding: const EdgeInsets.all(20),
              child: Image.asset('assets/images/logo.png'),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 21, 91, 148),
                          minimumSize: MediaQuery.of(context).size.width < 600
                              ? Size(
                                  MediaQuery.of(context).size.width / 1.5, 50)
                              : const Size(400.0, 50.0)),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => StudentHome()),
                        );
                      },
                      child: const Text("Students",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 35,
                              fontWeight: FontWeight.bold)),
                    )),
                const SizedBox(
                  height: 20,
                ),
                Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 21, 91, 148),
                          minimumSize: MediaQuery.of(context).size.width < 600
                              ? Size(
                                  MediaQuery.of(context).size.width / 1.5, 50)
                              : const Size(400.0, 50.0)),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => TutorHome()),
                        );
                      },
                      child: const Text("Tutors",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 35,
                              fontWeight: FontWeight.bold)),
                    ))
              ],
            )
          ],
        ),
      ),
      backgroundColor: Color.fromARGB(255, 241, 249, 255),
    );
  }
}
