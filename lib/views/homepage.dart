import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:event_management_app/auth.dart';
import 'package:event_management_app/constants/colors.dart';
import 'package:event_management_app/containers/event_container.dart';

import 'package:event_management_app/database.dart';
import 'package:event_management_app/saved_data.dart';

import 'package:event_management_app/views/create_event_page.dart';
import 'package:event_management_app/views/event_details.dart';
import 'package:event_management_app/views/login.dart';
import 'package:event_management_app/views/popular_item.dart';
import 'package:event_management_app/views/profile_page.dart';

import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String userName = "User";
  List<Document> events = [];
  bool isLoading = true;

  @override
  void initState() {
    userName = SavedData.getUserName().split(" ")[0];
    refresh();
    super.initState();
  }

  Future<void> refresh() async {
    try {
      final value = await getAllEvents();
      setState(() {
        events = value ?? [];
        isLoading = false;
      });
    } on AppwriteException catch (e) {
      if (e.code == 401) {
        // Handle unauthorized error
        print('User unauthorized: $e');
        // Redirect to login or show an error message
      } else {
        print('An error occurred: $e');
      }
    } catch (e) {
      print('Unhandled error: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Profile()),
              );
              refresh();
            },
            icon: Icon(
              Icons.account_circle,
              color: kLightGreen,
              size: 30,
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hi $userName 👋",
                    style: TextStyle(
                      color: kLightGreen,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Explore events around you",
                    style: TextStyle(
                      color: kLightGreen,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (isLoading)
                    Center(
                      child: CircularProgressIndicator(
                        color: kLightGreen,
                      ),
                    )
                  else
                    CarouselSlider(
                      options: CarouselOptions(
                        autoPlay: true,
                        autoPlayInterval: const Duration(seconds: 5),
                        aspectRatio: 16 / 9,
                        viewportFraction: 0.9,
                        enlargeCenterPage: true,
                        scrollDirection: Axis.horizontal,
                      ),
                      items: events.map((event) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: EventContainer(data: event),
                        );
                      }).toList(),
                    ),
                  const SizedBox(height: 16),
                  Text(
                    "Popular Events",
                    style: TextStyle(
                      color: kLightGreen,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (index < events.length && index < 5) {
                  return Column(
                    children: [
                      PopularItem(
                        eventData: events[index],
                        index: index + 1,
                      ),
                      const Divider(),
                    ],
                  );
                }
                return const SizedBox.shrink();
              },
              childCount: events.length,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "All Events",
                style: TextStyle(
                  color: kLightGreen,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => EventContainer(data: events[index]),
              childCount: events.length,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateEventPage()),
          );
          refresh();
        },
        child: Icon(
          Icons.add,
          color: Colors.black,
        ),
        backgroundColor: kLightGreen,
      ),
    );
  }
}
