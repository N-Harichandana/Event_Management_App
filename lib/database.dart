import 'package:appwrite/appwrite.dart';
import 'package:event_management_app/saved_data.dart';

import 'auth.dart';

String databaseId = "668ec2e200296361b064";

final Databases databases = Databases(client);

// Save the user data to appwrite database
Future<void> saveUserData(String name, String email, String userId) async {
  return await databases
      .createDocument(
          databaseId: databaseId,
          collectionId: "668ec30200342c81fda2",
          documentId: ID.unique(),
          data: {
            "name": name,
            "email": email,
            "userid": userId,
          })
      .then((value) => print("Document Created"))
      .catchError((e) => print(e));
}

Future getUserData() async {
  final id = SavedData.getUserId();
  print(id);
  try {
    final data = await databases.listDocuments(
        databaseId: databaseId,
        collectionId: "668ec30200342c81fda2",
        queries: [
          Query.equal("userid", id),
        ]);

    SavedData.saveUserName(data.documents[0].data['name']);
    SavedData.saveUserEmail(data.documents[0].data['email']);

    print(data.documents[0].data['isOrganizer']);
    print(data.documents[0].data['isOrganizer'].runtimeType);

    SavedData.saveUserIsOrganized(
        data.documents[0].data['isOrganizer'] ?? false);

    print("data is data : $data");
  } catch (e) {
    print("error on database : $e");
    print(e);
  }
}

Future<void> createEvent(
    String name,
    String desc,
    String image,
    String location,
    String datetime,
    String createdBy,
    bool isInPersonOrNot,
    String guest,
    String sponsers) async {
  return await databases
      .createDocument(
          databaseId: databaseId,
          collectionId: "668fea120019c339796e",
          documentId: ID.unique(),
          data: {
            "name": name,
            "description": desc,
            "image": image,
            "location": location,
            "datetime": datetime,
            "createdby": createdBy,
            "isinperson": isInPersonOrNot,
            "guests": guest,
            "Sponsers": sponsers
          })
      .then((value) => print("Event Created"))
      .catchError((e) => print(e));
}

Future getAllEvents() async {
  try {
    final data = await databases.listDocuments(
        databaseId: databaseId, collectionId: "668fea120019c339796e");
    return data.documents;
  } catch (e) {
    print(e);
  }
}

Future rsvpEvent(List participants, String documentId) async {
  final userId = SavedData.getUserId();
  participants.add(userId);
  try {
    await databases.updateDocument(
        databaseId: databaseId,
        collectionId: "668fea120019c339796e",
        documentId: documentId,
        data: {"participants": participants});
    return true;
  } catch (e) {
    print(e);
    return false;
  }
}

// list all event created by the user

Future manageEvents() async {
  final userId = SavedData.getUserId();
  try {
    final data = await databases.listDocuments(
        databaseId: databaseId,
        collectionId: "668fea120019c339796e",
        queries: [Query.equal("createdby", userId)]);
    return data.documents;
  } catch (e) {
    print(e);
  }
}

// update the edited event

Future<void> updateEvent(
    String name,
    String desc,
    String image,
    String location,
    String datetime,
    String createdBy,
    bool isInPersonOrNot,
    String guest,
    String sponsers,
    String docID) async {
  return await databases
      .updateDocument(
          databaseId: databaseId,
          collectionId: "668fea120019c339796e",
          documentId: docID,
          data: {
            "name": name,
            "description": desc,
            "image": image,
            "location": location,
            "datetime": datetime,
            "createdby": createdBy,
            "isinperson": isInPersonOrNot,
            "guests": guest,
            "Sponsers": sponsers
          })
      .then((value) => print("Event Updated"))
      .catchError((e) => print(e));
}

// deleting an event

Future deleteEvent(String docID) async {
  try {
    final response = await databases.deleteDocument(
        databaseId: databaseId,
        collectionId: "668fea120019c339796e",
        documentId: docID);

    print(response);
  } catch (e) {
    print(e);
  }
}

Future getUpcomingEvents() async {
  try {
    final now = DateTime.now();
    final response = await databases.listDocuments(
      databaseId: databaseId,
      collectionId: "668fea120019c339796e",
      queries: [
        Query.greaterThan("datetime", now),
      ],
    );

    return response.documents;
  } catch (e) {
    print(e);
    return []; // Handle errors appropriately in your application
  }
}

Future getPastEvents() async {
  try {
    final now = DateTime.now();
    final response = await databases.listDocuments(
      databaseId: databaseId,
      collectionId: "668fea120019c339796e",
      queries: [
        Query.lessThan("datetime", now),
      ],
    );

    return response.documents;
  } catch (e) {
    print(e);
    return [];
  }
}
