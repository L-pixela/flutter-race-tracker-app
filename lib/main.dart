import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:race_tracker_project/data/firebase/firebase_testing.dart';
import 'package:race_tracker_project/screens/manager_screens/dash_board_screen.dart';
import 'package:race_tracker_project/theme/theme.dart';
import 'package:race_tracker_project/widgets/race_botton.dart';
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
      theme: raceAppTheme,
      home: Scaffold(
        // appBar: AppBar(
        //   backgroundColor: RaceColors.primary,
        //   title: Text(
        //     "Cookies",
        //     style: RaceTextStyles.darkHeading,
        //   ),
        //   centerTitle: true,
        // ),
        body: const DashboardScreen(),

        // RegisterForm(selectedGender: '',)

        // body: Column(

        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     /// test the race button
        //     // Center(
        //     //   child: RaceButton(
        //     //     text: '09002',
        //     //     onPressed: () => print('Button clicked!'),
        //     //     width: 100,
        //     //   ),
        //     // ),

        //     Image.asset("assets/images/triathlon-yellow.gif")
        //     // AddUser("John Doe", "Acme Inc.", 30),
        //     // SizedBox(
        //     //   height: 15,
        //     // ),
        //     // GetUserByName(full_name),
        //     // SizedBox(
        //     //   height: 15,
        //     // ),
        //     // UpdateUserByName(full_name),
        //     // SizedBox(
        //     //   height: 15,
        //     // ),
        //     // DeleteUserByName(full_name),
        //   ],
        // )
      ),
    );
  }
}
