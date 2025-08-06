import 'package:activity/Specify.dart';
import 'package:activity/dataProvider.dart';
import 'package:activity/output.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PictureDecor extends StatefulWidget {
  // final Function(int) onNavigate;
  // const PictureDecor({super.key, required this.onNavigate});
  @override
  State<PictureDecor> createState() => _PictureDecorState();
}

class _PictureDecorState extends State<PictureDecor> {

// venues data upload function (for hyd):
void uploadHyderabadVenues(List<Map<String, dynamic>> venues) async {
  try {
    await FirebaseFirestore.instance
        .collection('Venues')
        .doc('Hyderabad')
        .set({'restaurants': venues});
    print('Data uploaded successfully');
  } catch (e) {
    print('Error uploading data: $e');
  }
}



TextEditingController _budgetController = TextEditingController();



  List<String> Apics = [
    "images/hyd.png",
    "images/karachi.png",
    "images/Islamabad.png",
    "images/lahore.png"
  ];


  List<String> Atitle = ["Hyderabad", "Karachi", "Islamabad", "Lahore"];
  List<String> Epics = [
    "images/birthday.png",
    "images/wedding.png",
    "images/christmas.png",
    "images/baby.png",
    "images/bachelor.png",
    "images/graduation.png"
  ];
  List<String> Etitle = [
    "Birthday",
    "Wedding",
    "Christmas",
    "Baby Shower",
    "Bachelor",
    "Graduation"
  ];










  _showActivityDialog(BuildContext context, String eventCollection) {
    print("Opening Activity Dialog for $eventCollection"); // Debug
    final dataProvider = context.read<Dataprovider>();
    // Fetch data and then show dialog
    dataProvider.retrieveActivityData(eventCollection).then((_) {
      print("Data fetched, opening dialog...");
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Consumer<Dataprovider>(
            builder: (context, provider, child) {
              if (provider.isLoading) {
                return AlertDialog(
                  title: const Text("Loading"),
                  content: Center(child: CircularProgressIndicator()),
                );
              }

              print(
                  "Dialog data: Male=${provider.male}, Female=${provider.female}, Kids=${provider.kids}"); // Debug

              return AlertDialog(
                title: const Text(
                  "Choose Activity",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                content: SizedBox(
                  width: double.maxFinite,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildOptionCard(
                        context,
                        "Option 1",
                        provider.male['option1'] ?? [],
                        provider.female['option1'] ?? [],
                        provider.kids['option1'] ?? [],
                      ),
                      _buildOptionCard(
                        context,
                        "Option 2",
                        provider.male['option2'] ?? [],
                        provider.female['option2'] ?? [],
                        provider.kids['option2'] ?? [],
                      ),
                      _buildOptionCard(
                        context,
                        "Option 3",
                        provider.male['option3'] ?? [],
                        provider.female['option3'] ?? [],
                        provider.kids['option3'] ?? [],
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: const Text("Cancel"),
                  ),
                ],
              );
            },
          );
        },
      );
    }).catchError((error) {
      print("Error fetching data: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $error")),
      );
    });
  }

  Widget _buildOptionCard(BuildContext context, String title,
      List<dynamic> male, List<dynamic> female, List<dynamic> kids) {
    return GestureDetector(
      onTap: () {
        List<String> maleActivities = male.cast<String>();
        List<String> femaleActivities = female.cast<String>();
        List<String> kidsActivities = kids.cast<String>();
        context
            .read<Dataprovider>()
            .setChoosedData(maleActivities, femaleActivities, kidsActivities);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => OutputPage()));
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 6),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text("Male:   ${male.join(', ')}"),
              Text("Female:   ${female.join(', ')}"),
              Text("Kids:   ${kids.join(', ')}"),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Center(
                  child: Text(
                    "Venue Vibes",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.orangeAccent,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Budget Section

// Budget Section
const Text(
  "Budget",
  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
),
const SizedBox(height: 8),
Container(
  height: screenHeight * 0.15,
  decoration: BoxDecoration(
    color: Colors.purple[50],
    borderRadius: BorderRadius.circular(12),
  ),
  child: Padding(
    padding: EdgeInsets.all(screenWidth * 0.02),
    child: Row(
      children: [
        Expanded(
          child: TextField(
            controller: _budgetController,
            decoration: InputDecoration(
              hintText: "Enter your budget for venue",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            keyboardType: TextInputType.number,
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: () {


            
            final budgetText = _budgetController.text.trim();
            if (budgetText.isEmpty || int.tryParse(budgetText) == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Please enter a valid numeric budget")),
              );
            } else {
              context.read<Dataprovider>().setVenueBudget(budgetText);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Budget set successfully")),
              );
            }
          },
          child: const Text("Set Budget"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purple[100],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    ),
  ),
),




                // const Text(
                //   "Budget",
                //   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                // ),
                // const SizedBox(height: 8),
                // Container(
                //   height: screenHeight * 0.15,
                //   decoration: BoxDecoration(
                //     color: Colors.purple[50],
                //     borderRadius: BorderRadius.circular(12),
                //   ),
                //   child: Padding(
                //     padding: EdgeInsets.all(screenWidth * 0.02),
                //     child: Row(
                //       children: [
                //         Expanded(
                //           child: TextField(
                //             decoration: InputDecoration(
                //               hintText: "Enter your budget for venue",
                //               border: OutlineInputBorder(
                //                 borderRadius: BorderRadius.circular(12),
                //               ),
                //             ),
                //             keyboardType: TextInputType.number,
                //           ),
                //         ),
                //         const SizedBox(width: 8),
                //         ElevatedButton(
                //           onPressed: () {
                //           // uploadHyderabadVenues(hyderabadVenues);

                //             // Set budget logic
                //           },
                //           child: const Text("Set Budget"),
                //           style: ElevatedButton.styleFrom(
                //             backgroundColor: Colors.purple[50],
                //             shape: RoundedRectangleBorder(
                //               borderRadius: BorderRadius.circular(12),
                //             ),
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),



                const SizedBox(height: 20),

                // Area Selection Section
                Specify().buildCardListArea("Choose Area", Apics, Atitle),
                const SizedBox(height: 20),

                // Event Type Section
                Specify().buildCardListEvent("Event Type", Epics, Etitle),
                const SizedBox(height: 20),

                // add activity:
                const Text(
                  "Choose Activity",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    var dataProvider = context.read<Dataprovider>();
                    var event = dataProvider.getEventType;

                    if (event != null && event.isNotEmpty) {
                      // dataProvider.retrieveActivityData(event);
                      _showActivityDialog(
                          context, event); // Display the activity dialog
                    } else {
                      print("Error: Event type is not set.");
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Please select an event type first!")));
                    }
                  },
                  child: const Text("Select Activity"),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Add Photo Section
                Container(
                  height: screenHeight * 0.15,
                  decoration: BoxDecoration(
                    color: Colors.purple[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Add Photo",
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: FloatingActionButton(
                          mini: true,
                          backgroundColor: Colors.purple,
                          child: Icon(Icons.add, size: 20, color: Colors.grey),
                          onPressed: () {
                            // Add photo logic here
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Generate Button
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      //  widget.onNavigate(0);
                      // setState(() {});
                    },
                    child: const Text("Generate"),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, screenHeight * 0.07),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
