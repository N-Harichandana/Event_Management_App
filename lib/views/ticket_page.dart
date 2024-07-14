import 'package:appwrite/models.dart';
import 'package:event_management_app/saved_data.dart';
import 'package:flutter/material.dart';
import 'package:event_management_app/containers/event_container.dart';
import 'package:event_management_app/database.dart';
import 'package:intl/intl.dart'; // Import your database methods

class TicketPage extends StatefulWidget {
  final Document data;
  TicketPage({super.key, required this.data});

  @override
  State<TicketPage> createState() => _TicketPageState();
}

class _TicketPageState extends State<TicketPage> {
  String name = "";
  String email = "";
  String id2 = '';
  @override
  void initState() {
    super.initState();
    id2 = SavedData.getUserId();
    name = SavedData.getUserName();
    email = SavedData.getUserEmail();
  }

  @override
  Widget build(BuildContext context) {
    String eventTime = DateFormat('hh:mm a')
        .format(DateTime.parse(widget.data.data['datetime']));
    String eventDate = DateFormat('dd MMM yyyy')
        .format(DateTime.parse(widget.data.data['datetime']));
    String last4Digits = widget.data.$id.substring(widget.data.$id.length - 2);
    String last2Digits = id2.substring(widget.data.$id.length - 2);
    return Scaffold(
        appBar: AppBar(
          title: Text("My Ticket"),
        ),
        body: Center(
          child: Container(
            padding: EdgeInsets.all(16.0),
            margin: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'My Ticket',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.0),
                Image.network(
                  'https://cloud.appwrite.io/v1/storage/buckets/668ff0c3002bad3cd389/files/${widget.data.data["image"]}/view?project=668eb1ab00388c867e55', // Make sure to add the image to your assets folder and declare it in pubspec.yaml
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 16.0),
                Text(
                  widget.data.data['name'],
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.0),
                buildInfoRow('Name', name),
                buildInfoRow('Date', eventDate),
                buildInfoRow('Time', eventTime),
                buildInfoRow('Ticket ID', '${last4Digits}+${last2Digits}'),
                SizedBox(height: 16.0),
                // Container(
                //   height: 80.0,
                //   child: Image.asset(
                //     'assets/barcode.png', // Make sure to add the barcode image to your assets folder
                //     fit: BoxFit.contain,
                //   ),
                // ),
              ],
            ),
          ),
        ));
  }
}

Widget buildInfoRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16.0,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}
