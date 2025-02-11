import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Dataprovider extends ChangeNotifier {
  late List<String> choosedMale, choosedfemale, choosedkids;
  String? eventType;
  String? _cuisineType;
  String _foodBudget = "";
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

  void setCuisineType(String cuisine) {
    _cuisineType = cuisine;
    notifyListeners();
  }

  // Getter for cuisine type
  String? get getCuisineType => _cuisineType;
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

  // List<int> selectedPricesIn = [];
  // List<int> selectedPricesIt = [];
  // List<int> selectedPricesPak = [];
  // List<int> selectedPricesAr = [];

  // void setIndianPrice(List<int> indian) {
  //   selectedPricesIn = indian;
  //   notifyListeners();
  // }

  // // Getter for cuisine type
  // List<int> get getIndianPrice => selectedPricesIn;

  // void setItalianPrice(List<int> italian) {
  //   selectedPricesIt = italian;
  //   notifyListeners();
  // }

  // // Getter for cuisine type
  // List<int> get getItalianPrice => selectedPricesIt;

  // void setPakPrice(List<int> pak) {
  //   selectedPricesPak = pak;
  //   notifyListeners();
  // }

  // // Getter for cuisine type
  // List<int> get getPakPrice => selectedPricesPak;

  // void setAraPrice(List<int> arabian) {
  //   selectedPricesAr = arabian;
  //   notifyListeners();
  // }

  // // Getter for cuisine type
  // List<int> get getArabianPrice => selectedPricesAr;

  // List<int> selectedPricesIn = [];
  // List<int> selectedPricesIt = [];
  // List<int> selectedPricesPak = [];
  // List<int> selectedPricesAr = [];

  // // Add or remove a price from the Indian cuisine list
  // void updateIndianPrice(int price, bool isSelected) {
  //   if (isSelected) {
  //     selectedPricesIn.add(price); // Add price if selected
  //   } else {
  //     selectedPricesIn.remove(price); // Remove price if deselected
  //   }
  //   notifyListeners();
  // }

  // // Getter for Indian cuisine prices
  // List<int> get getIndianPrice => selectedPricesIn;

  // // Add or remove a price from the Italian cuisine list
  // void updateItalianPrice(int price, bool isSelected) {
  //   if (isSelected) {
  //     selectedPricesIt.add(price); // Add price if selected
  //   } else {
  //     selectedPricesIt.remove(price); // Remove price if deselected
  //   }
  //   notifyListeners();
  // }

  // // Getter for Italian cuisine prices
  // List<int> get getItalianPrice => selectedPricesIt;

  // // Add or remove a price from the Pakistani cuisine list
  // void updatePakPrice(int price, bool isSelected) {
  //   if (isSelected) {
  //     selectedPricesPak.add(price); // Add price if selected
  //   } else {
  //     selectedPricesPak.remove(price); // Remove price if deselected
  //   }
  //   notifyListeners();
  // }

  // // Getter for Pakistani cuisine prices
  // List<int> get getPakPrice => selectedPricesPak;

  // // Add or remove a price from the Arabian cuisine list
  // void updateAraPrice(int price, bool isSelected) {
  //   if (isSelected) {
  //     selectedPricesAr.add(price); // Add price if selected
  //   } else {
  //     selectedPricesAr.remove(price); // Remove price if deselected
  //   }
  //   notifyListeners();
  // }

  // // Getter for Arabian cuisine prices
  // List<int> get getArabianPrice => selectedPricesAr;

  // // Clear all lists (optional)
  // void clearAllPrices() {
  //   selectedPricesIn.clear();
  //   selectedPricesIt.clear();
  //   selectedPricesPak.clear();
  //   selectedPricesAr.clear();
  //   notifyListeners();
  // }

  final Map<String, Map<String, int>> _selectedItems = {
    "Indian": {},
    "Italian": {},
    "Pakistani": {},
    "Arabian": {},
  };

  // Add or remove an item from the selected list
  void updateSelectedItem(
      String cuisineType, String item, int price, bool isSelected) {
    if (isSelected) {
      _selectedItems[cuisineType]![item] = price; // Add item and price
    } else {
      _selectedItems[cuisineType]!.remove(item); // Remove item
    }
    notifyListeners();
  }

  // Get selected items for a specific cuisine
  Map<String, int> getSelectedItems(String cuisineType) {
    return _selectedItems[cuisineType]!;
  }

  // Get all selected prices for a specific cuisine
  // List<int> getSelectedPrices(String cuisineType) {
  //   return _selectedItems[cuisineType]!.values.toList();
  // }

  List<int> getSelectedPrices() {
    return _selectedItems.values
        .expand((cuisineItems) => cuisineItems.values)
        .toList();
  }

  // Clear all selections (optional)
  void clearAllSelections() {
    _selectedItems.forEach((cuisineType, items) {
      items.clear();
    });
    notifyListeners();
  }

  void setFoodBudget(String budget) {
    _foodBudget = budget;
    notifyListeners();
  }

  String get getFoodBudget => _foodBudget;
}
