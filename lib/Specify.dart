import 'package:activity/dataProvider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Specify {
  Future<void> _showCuisineItemsDialog(
      BuildContext context, String cuisineType) async {
    final firestore = FirebaseFirestore.instance;
    final dataprovider = Provider.of<Dataprovider>(context, listen: false);

    final docSnapshot =
        await firestore.collection("Cuisines").doc(cuisineType).get();
    if (!docSnapshot.exists) {
      print("No data found for $cuisineType");
      return;
    }

    final data = docSnapshot.data() as Map<String, dynamic>;
    final List<String> items = data.keys.toList();

    // Initialize selected items map based on stored selection state
    final Map<String, bool> selectedItems = {};
    final storedSelections = dataprovider.getSelectedItems(cuisineType);
    for (var item in items) {
      selectedItems[item] = storedSelections.containsKey(item);
    }

    // Show dialog box
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("Select Items from $cuisineType"),
              content: SingleChildScrollView(
                child: Column(
                  children: items.map((item) {
                    return CheckboxListTile(
                      title: Text(item),
                      value: selectedItems[item],
                      onChanged: (value) {
                        setState(() {
                          selectedItems[item] = value!;

                          // Update the selection state in the provider
                          final price = data[item] as int;
                          dataprovider.updateSelectedItem(
                              cuisineType, item, price, value);
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancel"),
                ),
                TextButton(
                  onPressed: () {
                    // Retrieve and print all selected prices for the current cuisine
                    final selectedPrices = dataprovider.getSelectedPrices();
                    print("Selected Prices for $cuisineType: $selectedPrices");
                    // print(context.watch<Dataprovider>().totalSelectedPrice);
                    Navigator.pop(context); // Close the dialog
                  },
                  child: Text("Save"),
                ),
              ],
            );
          },
        );
      },
    );
  }
  // for cuisine
  // Widget buildCardListCuisine(
  //     String label, List<String> pictureList, List<String> titleList) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Padding(
  //         padding: const EdgeInsets.symmetric(vertical: 8.0),
  //         child: Text(
  //           label,
  //           style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
  //         ),
  //       ),
  //       SizedBox(
  //         height: 150,
  //         child: ListView.builder(
  //           scrollDirection: Axis.horizontal,
  //           itemCount: pictureList.length,
  //           itemBuilder: (context, index) {
  //             return Padding(
  //               padding: const EdgeInsets.all(8.0),
  //               child: InkWell(
  //                 onTap: () {
  //                   String cuisineTitle = titleList[index];
  //                   context
  //                       .read<Dataprovider>()
  //                       .setCuisineType(cuisineTitle); // Update the provider
  //                   print('$cuisineTitle tapped!');

  //                   var dataProvider = context.read<Dataprovider>();
  //                   var cuisine = dataProvider.getCuisineType;
  //                   if (cuisine != null && cuisine.isNotEmpty) {
  //                     // dataProvider.retrieveActivityData(event);
  //                     _showCuisineItemsDialog(
  //                         context, cuisine); // Display the activity dialog
  //                   }

  //                   // cuisineType = titleList[index];

  //                   // print('Card ${titleList[index]} tapped');
  //                   //  _showCuisineItemsDialog(context, cuisineType);
  //                 },
  //                 child: Container(
  //                   width: 90,
  //                   decoration: BoxDecoration(
  //                     color: Colors.grey[300],
  //                     borderRadius: BorderRadius.circular(12),
  //                   ),
  //                   child: Stack(
  //                     children: [
  //                       // Background image
  //                       ClipRRect(
  //                         borderRadius: BorderRadius.circular(12),
  //                         child: Image.asset(
  //                           pictureList[index], // Use image from picture list
  //                           width: 90,
  //                           height: 150,
  //                           fit: BoxFit.cover, // Cover the whole container
  //                         ),
  //                       ),
  //                       // Title at the bottom
  //                       Align(
  //                         alignment: Alignment.bottomCenter,
  //                         child: Container(
  //                           height: 20,
  //                           width: double.infinity,
  //                           decoration: BoxDecoration(
  //                             color: Colors.black.withOpacity(
  //                                 0.5), // Semi-transparent background for the text
  //                             borderRadius: const BorderRadius.only(
  //                               bottomLeft: Radius.circular(12),
  //                               bottomRight: Radius.circular(12),
  //                             ),
  //                           ),
  //                           padding: const EdgeInsets.symmetric(vertical: 4.0),
  //                           child: Text(
  //                             titleList[index], // Title from the title list
  //                             style: const TextStyle(
  //                               color: Colors.white,
  //                               fontSize: 7,
  //                               fontWeight: FontWeight.bold,
  //                             ),
  //                             textAlign: TextAlign.center,
  //                           ),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //             );
  //           },
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget buildCardListCuisine(
      String label, List<String> pictureList, List<String> titleList) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        SizedBox(
          height: 150,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: pictureList.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    String cuisineTitle = titleList[index];
                    // Update the provider
                    Provider.of<Dataprovider>(context, listen: false)
                        .setCuisineType(cuisineTitle);
                    print('$cuisineTitle tapped!');

                    // Retrieve the cuisine type from the provider
                    var dataProvider =
                        Provider.of<Dataprovider>(context, listen: false);
                    var cuisine = dataProvider.getCuisineType;
                    if (cuisine != null && cuisine.isNotEmpty) {
                      _showCuisineItemsDialog(
                          context, cuisine); // Display the dialog
                    }
                  },
                  child: Container(
                    width: 90,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Stack(
                      children: [
                        // Background image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            pictureList[index], // Use image from picture list
                            width: 90,
                            height: 150,
                            fit: BoxFit.cover, // Cover the whole container
                          ),
                        ),
                        // Title at the bottom
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: 20,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(
                                  0.5), // Semi-transparent background for the text
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(12),
                                bottomRight: Radius.circular(12),
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text(
                              titleList[index], // Title from the title list
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 7,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

// for event

  Widget buildCardListEvent(
      String label, List<String> pictureList, List<String> titleList) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        SizedBox(
          height: 150,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: pictureList.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    // When tapped, fetch event data from Firestore
                    String eventTitle = titleList[index];
                    context
                        .read<Dataprovider>()
                        .setEventType(eventTitle); // Update the provider
                    print('$eventTitle tapped!');
                  },
                  child: Container(
                    width: 90,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            pictureList[index],
                            width: 90,
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: 20,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(12),
                                bottomRight: Radius.circular(12),
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text(
                              titleList[index],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 7,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

// for area
  Widget buildCardListArea(
      String label, List<String> pictureList, List<String> titleList) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        SizedBox(
          height: 150,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: pictureList.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    print('Card ${titleList[index]} tapped');
                  },
                  child: Container(
                    width: 90,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            pictureList[index],
                            width: 90,
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: 20,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(12),
                                bottomRight: Radius.circular(12),
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text(
                              titleList[index],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 7,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // grey code
  Widget buildGreyText(String label) {
    return Text(
      label,
      style: TextStyle(
        color: Colors.grey[700],
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
