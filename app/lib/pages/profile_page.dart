import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/interactive/event_card_viewer.dart';
import '../components/interactive/my_button.dart';
import '../components/interactive/profile_info.dart';
import '../models/volunteer.dart';
import '../services/data/database_manager.dart';
import '../utils/alignment.dart';

class ProfilePage extends StatefulWidget {
  final Volunteer _volunteer;
  final DatabaseManager _dbManager;

  /* CONSTRUCTOR */
  ProfilePage(
      {required Volunteer volunteer,
      required DatabaseManager dbManager,
      Key? key})
      : _volunteer = volunteer,
        _dbManager = dbManager,
        super(key: key);

  /* METHOD */
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  /* METHODS */
  void _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Column(
          children: [
            addVerticalSpace(40),
            Center(
              child: Text(
                'Profile',
                style: TextStyle(
                  fontSize: 40,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            addVerticalSpace(10),
            ProfileInfo(widget._volunteer, widget._dbManager),
            addVerticalSpace(24),
            Center(
              child: Text(
                'Recent Events',
                style: Theme.of(context).textTheme.displayMedium,
              ),
            ),
            SizedBox(
              height: 330,
              width: 360,
              child: EventCardViewer(
                events: widget._volunteer.organizedEvents,
                dbManager: widget._dbManager,
              ),
            ),
            MyButton(
              onTap: _signOut,
              text: const Text("Sign out"),
            ),
          ],
        ),
      ),
    );
  }
}
