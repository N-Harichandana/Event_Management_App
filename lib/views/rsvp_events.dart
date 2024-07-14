import 'package:appwrite/models.dart';
import 'package:event_management_app/constants/colors.dart';
import 'package:event_management_app/database.dart';
import 'package:event_management_app/saved_data.dart';
import 'package:event_management_app/views/event_details.dart';
import 'package:flutter/material.dart';

class RSVPEvents extends StatefulWidget {
  const RSVPEvents({super.key});

  @override
  State<RSVPEvents> createState() => _RSVPEventsState();
}

class _RSVPEventsState extends State<RSVPEvents> {
  List<Document> events = [];
  List<Document> userEvents = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    refresh();
  }

  void refresh() {
    String userId = SavedData.getUserId();
    getAllEvents().then((value) {
      setState(() {
        events = value;
        userEvents = events.where((event) {
          List<dynamic> participants = event.data["participants"];
          return participants.contains(userId);
        }).toList();
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "RSVP Events",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: kLightGreen,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: userEvents.length,
                itemBuilder: (context, index) {
                  final event = userEvents[index];
                  return Card(
                    color: Colors.grey[900],
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: ListTile(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EventDetails(data: event),
                        ),
                      ),
                      contentPadding: const EdgeInsets.all(16.0),
                      title: Text(
                        event.data["name"],
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          event.data["location"],
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      trailing: Icon(
                        Icons.check_circle,
                        color: kLightGreen,
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
