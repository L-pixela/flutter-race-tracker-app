import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class AddUser extends StatelessWidget {
  final String fullName;
  final String company;
  final int age;

  const AddUser(this.fullName, this.company, this.age, {super.key});

  @override
  Widget build(BuildContext context) {
    // Create a CollectionReference called users that references the firestore collection
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    Future<void> addUser() {
      // Call the user's CollectionReference to add a new user
      return users
          .add({
            'full_name': fullName, // John Doe
            'company': company, // Stokes and Sons
            'age': age // 42
          })
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));
    }

    return TextButton(
      onPressed: addUser,
      child: Text(
        "Add User",
      ),
    );
  }
}

class GetUserByName extends StatelessWidget {
  final String fullName;

  const GetUserByName(this.fullName, {super.key});

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    return FutureBuilder<QuerySnapshot>(
      future: users.where('full_name', isEqualTo: fullName).get(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return Text("Something went wrong");
        if (snapshot.connectionState != ConnectionState.done) {
          return Text("loading...");
        }

        if (snapshot.data!.docs.isEmpty) return Text("User not found");

        final data = snapshot.data!.docs.first.data() as Map<String, dynamic>;
        return Text(
            "Full Name: ${data['full_name']}, Company: ${data['company']}");
      },
    );
  }
}

class UpdateUserByName extends StatelessWidget {
  final String fullName;

  const UpdateUserByName(this.fullName, {super.key});

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    Future<void> updateUser() async {
      final snapshot =
          await users.where('full_name', isEqualTo: fullName).get();

      if (snapshot.docs.isNotEmpty) {
        final docId = snapshot.docs.first.id;
        await users.doc(docId).update({'company': 'Updated Company'});
        print("User Updated");
      } else {
        print("User not found");
      }
    }

    return ElevatedButton(
      onPressed: updateUser,
      child: Text("Update User"),
    );
  }
}

class DeleteUserByName extends StatelessWidget {
  final String fullName;

  const DeleteUserByName(this.fullName, {super.key});

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    Future<void> deleteUser() async {
      final snapshot =
          await users.where('full_name', isEqualTo: fullName).get();

      if (snapshot.docs.isNotEmpty) {
        final docId = snapshot.docs.first.id;
        await users.doc(docId).delete();
        print("User Deleted");
      } else {
        print("User not found");
      }
    }

    return ElevatedButton(
      onPressed: deleteUser,
      child: Text("Delete User"),
    );
  }
}
