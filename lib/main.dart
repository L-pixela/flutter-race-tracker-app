import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:race_tracker_project/data/firebase/firebase_testing.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  final String full_name = "John Doe";

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        print(doc["full_name"]);
      });
    });
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(
            title: Text("Cookies"),
            centerTitle: true,
          ),
          body: Column(
            children: [
              AddUser("John Doe", "Acme Inc.", 30),
              SizedBox(
                height: 15,
              ),
              GetUserByName(full_name),
              SizedBox(
                height: 15,
              ),
              UpdateUserByName(full_name),
              SizedBox(
                height: 15,
              ),
              DeleteUserByName(full_name),
            ],
          )),
    );
  }
}
