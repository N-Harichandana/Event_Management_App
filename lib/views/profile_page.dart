import 'package:event_management_app/constants/colors.dart';
import 'package:event_management_app/saved_data.dart';
import 'package:event_management_app/views/login.dart';
import 'package:event_management_app/views/manage_events.dart';
import 'package:event_management_app/views/rsvp_events.dart';
import 'package:flutter/material.dart';
import '../auth.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String name = "";
  String email = "";

  @override
  void initState() {
    super.initState();
    name = SavedData.getUserName();
    email = SavedData.getUserEmail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                    'https://images.pexels.com/photos/3951652/pexels-photo-3951652.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'), // Add your background image asset
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Profile content
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                        fontSize: 28,
                      ),
                    ),
                    Text(
                      email,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        _buildProfileOption(
                          icon: Icons.event,
                          text: "RSVP Events",
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RSVPEvents()),
                          ),
                        ),
                        _buildProfileOption(
                          icon: Icons.manage_accounts,
                          text: "Manage Events",
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ManageEvents()),
                          ),
                        ),
                        _buildProfileOption(
                          icon: Icons.logout,
                          text: "Logout",
                          onTap: () {
                            logoutUser();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileOption(
      {required IconData icon,
      required String text,
      required Function() onTap}) {
    return Card(
      color: Colors.black38,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: kLightGreen),
        title: Text(
          text,
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
        ),
        trailing: Icon(Icons.arrow_forward_ios, color: kLightGreen),
      ),
    );
  }
}
