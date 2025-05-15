import 'package:flutter/material.dart';
import 'package:race_tracker_project/theme/theme.dart';
import 'package:race_tracker_project/widgets/app_button.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile', style: RaceTextStyles.darkHeading),
        backgroundColor: RaceColors.primary,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage(''),
                ),
                const SizedBox(height: 20),
                Text(
                  'Ronan The Best',
                  style: RaceTextStyles.body,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Ronan is the best@gmail.com',
                  style: RaceTextStyles.label,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                Button(
                  text: 'Edit Profile',
                  onPressed: () {},
                  icon: Icons.edit_outlined,
                ),
                SizedBox(
                  height: 12,
                ),
                Button(
                  text: '  Log  Out ',
                  onPressed: () {},
                  type: ButtonType.red,
                  icon: Icons.login_outlined,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
