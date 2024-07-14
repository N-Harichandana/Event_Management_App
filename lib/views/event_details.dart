import 'package:appwrite/models.dart';
import 'package:event_management_app/constants/colors.dart';
import 'package:event_management_app/containers/format_datetime.dart';
import 'package:event_management_app/database.dart';
import 'package:event_management_app/saved_data.dart';
import 'package:event_management_app/views/ticket_page.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

class EventDetails extends StatefulWidget {
  final Document data;
  const EventDetails({super.key, required this.data});

  @override
  State<EventDetails> createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  bool isRSVPedEvent = false;
  String id = "";
  String ticketId = "";

  bool isUserPresent(List<dynamic> participants, String userId) {
    return participants.contains(userId);
  }

  @override
  void initState() {
    id = SavedData.getUserId();
    isRSVPedEvent = isUserPresent(widget.data.data["participants"], id);
    super.initState();
  }

  // void attendEvent() {
  //   // Generate a unique ticket ID
  //   ticketId = Uuid().v4();
  //   print(ticketId);

  //   // Navigate to TicketPage with the ticket ID
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => TicketPage(ticketId: ticketId),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Event details"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 300,
                  width: double.infinity,
                  child: ColorFiltered(
                    colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.3), BlendMode.darken),
                    child: Image.network(
                      "https://cloud.appwrite.io/v1/storage/buckets/668ff0c3002bad3cd389/files/${widget.data.data["image"]}/view?project=668eb1ab00388c867e55",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Positioned(
                //   top: 25,
                //   child: IconButton(
                //     onPressed: () => Navigator.pop(context),
                //     icon: Icon(
                //       Icons.arrow_back,
                //       size: 28,
                //       color: Colors.white,
                //     ),
                //   ),
                // ),
                Positioned(
                  bottom: 45,
                  left: 8,
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_month_outlined,
                        size: 18,
                        color: Colors.white,
                      ),
                      SizedBox(width: 4),
                      Text(
                        "${formatDate(widget.data.data["datetime"])}",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      ),
                      SizedBox(width: 14),
                      Icon(
                        Icons.access_time_outlined,
                        size: 18,
                        color: Colors.white,
                      ),
                      SizedBox(width: 4),
                      Text(
                        "${formatTime(widget.data.data["datetime"])}",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 8,
                  child: Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 18,
                        color: Colors.white,
                      ),
                      SizedBox(width: 4),
                      Text(
                        "${widget.data.data["location"]}",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.data.data["name"],
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                          // IconButton(
                          //   icon: Icon(Icons.share, color: kLightGreen),
                          //   onPressed: () {
                          //     // Implement share functionality here
                          //   },
                          // ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        widget.data.data["description"],
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                      SizedBox(height: 16),
                      Text(
                        "${widget.data.data["participants"].length} people are attending.",
                        style: TextStyle(
                            color: kLightGreen,
                            fontWeight: FontWeight.w500,
                            fontSize: 16),
                      ),
                      SizedBox(height: 16),
                      _buildSectionTitle("Special Guests"),
                      Text(
                        widget.data.data["guests"].isEmpty
                            ? "None"
                            : widget.data.data["guests"],
                        style: TextStyle(color: Colors.white70),
                      ),
                      SizedBox(height: 16),
                      _buildSectionTitle("Sponsors"),
                      Text(
                        widget.data.data["Sponsers"].isEmpty
                            ? "None"
                            : widget.data.data["Sponsers"],
                        style: TextStyle(color: Colors.white70),
                      ),
                      SizedBox(height: 16),
                      _buildSectionTitle("More Info"),
                      Text(
                        "Event Type: ${widget.data.data["isinperson"] ? "In Person" : "Virtual"}",
                        style: TextStyle(color: Colors.white70),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Time: ${formatTime(widget.data.data["datetime"])}",
                        style: TextStyle(color: Colors.white70),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Location: ${widget.data.data["location"]}",
                        style: TextStyle(color: Colors.white70),
                      ),
                      SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () {
                          _launchUrl(
                              "https://www.google.com/maps/search/?api=1&query=${widget.data.data["location"]}");
                        },
                        icon: const Icon(Icons.map),
                        label: const Text("Open in Google Maps"),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor: kLightGreen,
                        ),
                      ),
                      SizedBox(height: 16),
                      isRSVPedEvent
                          ? SizedBox(
                              height: 50,
                              width: double.infinity,
                              child: MaterialButton(
                                color: kLightGreen,
                                onPressed: () {
                                  String eventId = widget.data
                                      .$id; // Assuming this gives you the event ID
                                  print("Event ID: $eventId");
                                  Navigator.of(context)
                                      .push(MaterialPageRoute(builder: (_) {
                                    return TicketPage(
                                      data: widget.data,
                                    );
                                  }));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              "You are attending this event.")));
                                  // attendEvent();
                                },
                                child: Text(
                                  "View Ticket",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 20),
                                ),
                              ),
                            )
                          : SizedBox(
                              height: 50,
                              width: double.infinity,
                              child: MaterialButton(
                                color: kLightGreen,
                                onPressed: () {
                                  rsvpEvent(widget.data.data["participants"],
                                          widget.data.$id)
                                      .then((value) {
                                    if (value) {
                                      setState(() {
                                        isRSVPedEvent = true;
                                      });
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content:
                                                  Text("RSVP Successful !!!")));
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                                  "Something went wrong. Try Again.")));
                                    }
                                  });
                                },
                                child: Text(
                                  "RSVP Event",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 20),
                                ),
                              ),
                            )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
          color: Colors.white, fontWeight: FontWeight.w700, fontSize: 20),
    );
  }
}

Future<void> _launchUrl(String url) async {
  if (!await launchUrl(Uri.parse(url))) {
    throw Exception('Could not launch $url');
  }
}
