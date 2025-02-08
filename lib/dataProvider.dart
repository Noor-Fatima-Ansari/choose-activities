import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Dataprovider extends ChangeNotifier {
  late List<String> choosedMale, choosedfemale, choosedkids;
  String? eventType;

  void setChoosedData(
      List<String> maleData, List<String> femaleData, List<String> kidsData) {
    this.choosedMale = maleData;
    this.choosedfemale = femaleData;
    this.choosedkids = kidsData;
    ChangeNotifier();
  }

  List<String> get maleData => choosedMale;
  List<String> get femaleData => choosedfemale;
  List<String> get kidsData => choosedkids;

  void setEventType(String event) {
    this.eventType = event.toLowerCase();
    notifyListeners();
  }

  String? get getEventType => eventType;
  // void retrieveActivityData(String eventCollection) async {
  //   // Reference to the Firestore collection and document
  //   var eventType = eventCollection.toLowerCase();
  //   DocumentSnapshot eventSnapshot = await FirebaseFirestore.instance
  //       .collection(eventType) // Use the dynamic collection name
  //       .doc('activity1')
  //       .get();

  //   if (eventSnapshot.exists) {
  //     // Retrieve the data from the document snapshot
  //     Map<String, dynamic> activityData =
  //         eventSnapshot.data() as Map<String, dynamic>;

  //     // Access data

  //     male = activityData['male'];
  //     female = activityData['female'];
  //     kids = activityData['kids'];

  //     print("Male Activities: $male");
  //     print("Female Activities: $female");
  //     print("Kids Activities: $kids");

  //     // You can now use this data in your app as needed
  //   } else {
  //     print('No such document!');
  //   }

  //   notifyListeners();
  // }

  Map<String, dynamic> male = {};
  Map<String, dynamic> female = {};
  Map<String, dynamic> kids = {};

  bool isLoading = false; // To handle loading state

  // Function to retrieve data
  Future<void> retrieveActivityData(String eventCollection) async {
    try {
      isLoading = true; // Start loading
      notifyListeners();

      // Fetch data from Firestore
      var eventType = eventCollection.toLowerCase();
      DocumentSnapshot eventSnapshot = await FirebaseFirestore.instance
          .collection(eventType)
          .doc('activity1')
          .get();

      if (eventSnapshot.exists) {
        Map<String, dynamic> activityData =
            eventSnapshot.data() as Map<String, dynamic>;

        // Save the data
        male = activityData['male'];
        female = activityData['female'];
        kids = activityData['kids'];
      }
    } catch (e) {
      print("Error fetching activity data: $e");
    } finally {
      isLoading = false; // Stop loading
      notifyListeners(); // Notify listeners after loading is done
    }
  }
}
